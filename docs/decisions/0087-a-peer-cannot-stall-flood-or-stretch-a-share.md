# 0087. A peer cannot stall, flood or stretch a share

- Date: 2026-11-28
- Status: accepted
- Scope: all modules that share (Recipe Vacuum, Sparklescope 6000)
- Kind: safety

## Context

A friend, guild member or group member is listened to, random dungeon groups included. An offline spec fed the real share code the messages a modified client could send. Four held:

| What the peer sent | What happened |
|---|---|
| A reply whose payload decodes to a number or `true` | A Lua error in the listener. The request never finished: no other peer was asked for 90 seconds, and the same peer could repeat it at its next offer |
| 500 requests, each from a different revision | 500 replies built and queued, each a full encode and up to 4000 bytes in the send queue |
| An offer of revision 4294967295, then replies of 64 rows that each moved one revision | After 200 replies the request was still running: 12,801 sources on one recipe |
| Nothing hostile: any probe from a player with Share My Finds off | The probe carried the account's collection ID, so a guild or group could tell which characters are one player |

No hostile peer has been seen. The first row needs no intent: any reply damaged into a CBOR scalar does it.

## Decision

1. A reply that is not a list is skipped without reading its length; the cursor moves past it and the request finishes.
2. One reply in flight per sender. A request that arrives before the last reply's final chunk has left is dropped; a reply that never reports back stops counting after the request timeout (30 seconds).
3. A reply never holds more rows than the revisions it covers, and one request takes at most 64 replies. A peer with more is asked again at its next probe, from the saved cursor. Recipe Vacuum also caps the shared sources one recipe keeps.
4. A player who does not send their finds sends `0-0` in place of the collection ID. A probe from our own character with that ID is our own, echoed by the channel, and gets no answer.

## Reasons

- The listener runs inside AceComm's callback: an error there leaves the request open, so one bad reply costs every other peer its turn.
- An honest peer asks once and waits for the reply, so one reply in flight per sender costs it nothing.
- Each row is one revision (`Share:Since`), so rows above the revisions covered can only be made up. The tip is the peer's own claim, so it cannot be what ends a request; a count of replies can.
- 64 replies of 64 rows is 4096 rows a probe, more than any collection seen so far; a larger one still arrives, a probe at a time.
- The game does not tell a guild or group member which characters share an account. The ID did, and Share My Finds off did not stop it.

## Rejected

- A cap on rows per peer for good: an honest collection has no upper size.
- A collection ID per character: it stops the link fully but changes how collections resync. Bigger; its own decision if the link matters to a player who shares.
- Rejecting names that are not valid UTF-8, whole-number prices, pruning `db.exchange.received`: display only or slow growth, recorded in `docs/sharing.md`, "Known gaps".

## Versions

- Kit `MINOR` 87 (`Share:HandleData`, `Share:SendData`, `Share:Offer`, `Share:OnProbe`). Recipe Vacuum `Finds.lua` (the cap and the field checks).
- Kit `MINOR` 88 (`Share:SendData`): a reply clears only its own in-flight mark. A peer asks again after 30 seconds, the moment the mark stops counting, so a reply still queued then finished after the next had started and freed the sender for a third.

## Tests

- `tests/share_spec.lua`, one spec per row of the table, each failing on `MINOR` 86: "a reply that is a number or a boolean is skipped, and the request finishes", "a sender gets one reply at a time" (from `MINOR` 88 also a reply that leaves after the timeout, which failed on 87), "a reply with more rows than the revisions it covers is refused", "a request ends after a fixed number of replies", "a player who does not share sends no collection ID".
- Not tested in game: two clients have not exchanged finds since this change, and whether a channel hands our own probe back under our own plain name is read from AceComm's sender handling, not seen.

## Reopen if

- An honest collection needs more than 4096 rows at once and the probe-by-probe catch-up is seen to lag.
- A report of invented sources, or a guild-size test that shows a burst of answers.
