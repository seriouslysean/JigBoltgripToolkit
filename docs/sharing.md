# Sharing

How a toolkit module shares what its player finds with other players of the same module, and takes theirs in. The library holds the transport; a module supplies only its row shape. Recipe Vacuum's transport was lifted into the kit, done right with no shortcuts and no release candidate, because the modules are in daily use. API: `lib:NewShare` and `lib.wire` in `JigBoltgripToolkit.lua`, since `MINOR` 48.

Scope (`cairn:h1qwg`): party, raid, guild and friends. Public channels are a future phase. What the player finds (found) and what others sent (shared) stay apart. Received data is never executed, every row is validated against game data, and addon messages are invisible in chat.

## Prior art

| Source | What it shows | What we took |
|---|---|---|
| [C_ChatInfo.SendAddonMessage](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage) | At most 255 characters a message, at most 16 in a prefix; each prefix starts with 10 sends and regains 1 a second, and an empty allowance fails with `AddonMessageThrottle`; the per-prefix limit does not apply to whispers outside instanced content; the receiver must register the prefix; chat types PARTY, RAID (sent as PARTY outside a raid), INSTANCE_CHAT, GUILD, OFFICER, WHISPER, CHANNEL (retail) | One prefix pair per module; replies split by AceComm; whispers for data |
| Forever's own API documents (`Blizzard_APIDocumentationGenerated/ChatInfoDocumentation.lua`, `ChatConstantsDocumentation.lua`, client 1.60.1.71091) | `InChatMessagingLockdown` ("API security restrictions regarding chat messaging are in effect"), `SendAddonMessageResult` including `AddonMessageThrottle` and `ChannelThrottle`, `RegisterAddonMessagePrefixResult` including `MaxPrefixes` | Nothing is sent while the lockdown is on; the share retries when it ends |
| AceComm-3.0 and ChatThrottleLib (embedded in each module's `Libs/`) | AceComm splits a message into 255-byte chunks (the limit is tested in its source comment), rebuilds it per prefix, channel and sender, and sends through ChatThrottleLib with a priority; ChatThrottleLib round-robins connections and shares bandwidth between BULK, NORMAL and ALERT | All sends are BULK through AceComm; the kit never calls `SendAddonMessage` itself |
| another addon `Loader.lua` | One loader owns two prefixes (`another addon`, and another addon `D5`) and routes by the first letter of the message to boss and plugin handlers; a group's version query is answered after a 3 second timer so many replies collapse; a throttled send is retried after 3 seconds | Probe answers are delayed and coalesced per channel (3 seconds); the kit is the one owner of transport code, the module is the handler |
| another addon README | Serialize, compress with another addon, encode for the addon channel, reverse on receipt and return early when any step fails; gives no guidance on untrusted input | The client has the same chain built in (`C_EncodingUtil`: CBOR, deflate, base64), so no library is embedded; every step may fail and a failure drops the message |
| another addon (2021, recorded in Recipe Vacuum's `docs/data.md`) | Received text ran through `loadstring`, which let a sender run code in the receiver's game | Rows are parsed as CBOR data and checked field by field; nothing received is run |

Not established: how many prefixes a client may register (`MaxPrefixes` exists; no limit is documented in the sources above), and whether Forever allows `CHANNEL` addon messages. Neither matters until public channels are in scope.

## Decisions

- One prefix pair per module, `<AddOn><protocol>` and `<AddOn><protocol>D`, such as `RecipeVacuum2` and `RecipeVacuum2D`. Modules are independent addons that can be installed alone, so one suite-wide prefix (another addon shape) would tie their versions together. The prefix must fit 16 characters with the `D`; `NewShare` stops with an error when it does not. An addon whose name leaves no room passes `spec.prefix`, a shorter name used in place of the addon's (Sparklescope6000 is 16 characters on its own).
- The protocol number is the module's wire version. Old and new copies with different numbers use different prefixes and never hear each other. Adding a row kind or a field does not need a bump: a row of a kind a version does not read is skipped, and the rest of the batch is kept.
- One collection per module: an ID, a revision counter and, for each peer, the revision received so far. It is saved in the module's table as `db.exchange = { id, revision, received }`, the same layout in every module.
- Throttling is AceComm and ChatThrottleLib's, at BULK priority. The kit adds only its own pacing: one request in flight at a time, a 30 second timeout with two retries, replies built in batches of at most 64 rows and halved until the encoded text is under 4000 bytes, a reply cached per starting revision until a new find, one answer per channel after 3 seconds of quiet, and no whisper to a name the game said is not playing until that name has been offline.
- Limits before work: an encoded reply over 6000 bytes is not decoded, a decompressed one over 65536 bytes is not read, and a header must name a collection ID of at most 32 characters and numbers below 2^32.

## What the library does

1. Probes, on joining a guild, group or instance, on reconnecting and when a friend comes online. A probe carries the collection ID and the revision (0 when the player does not send).
2. A peer that is behind whispers a request for everything after its cursor.
3. The owner replies with one batch; the receiver validates it, merges it, saves its cursor and asks again until it reaches the tip.
4. Only a friend, guild member or group member is listened to. A reply is accepted only from the peer asked, for the range asked.

The message kinds are `H` (hello), `A` (answer), `O` (offer), `G` (get) and `D` (data), each followed by a collection ID and a number. They are the wire format.

## What a module supplies

```lua
ns.share = toolkit:NewShare(ns.module, {
	protocol = 2,                       -- in both prefixes
	kinds = { trainer = true },         -- row kinds this version reads; every row has a kind in `k`
	wire = function(entry, context) end, -- one found entry as a row of plain numbers, strings and booleans
	validate = function(row) end,       -- true, or false and a reason, for one row of a known kind
	merge = function(rows) end,         -- checked rows into the shared layer; returns whether anything changed
	sending = function() end,           -- the player shares their finds
	receiving = function() end,         -- the player takes others' in
	changed = function() end,           -- optional: after a request's rows were merged, once
})
```

Calls, all on the share:

| Call | When |
|---|---|
| `Load(db, each)` | Once saved data is loaded. `each(add)` calls `add(entry, context)` for every entry of the found layer; an entry with no revision gets the next one, and a counter behind its entries is renumbered under a new collection ID so peers resync. |
| `Mark(entry, context)` | A found entry is new or changed. It gets the next revision and peers are offered it, once per frame. |
| `Update()` | A sharing setting changed: connects or disconnects, drops pending requests when receiving stops, offers at once when sending starts. |
| `Since(after, limit)` | Rows after a revision, for an export. |
| `Merge(rows)` | The batch checks and the module's merge; the receive path calls it, and a module's own specs can. |
| `SelfTest(report, merge, summary)` | A working build's one-account check (below). |

`lib.wire` holds the checks every module builds its `validate` from, so rows are checked one way everywhere: `ID`, `Number`, `Coordinate`, `Flag`, `Time` (not ahead of a skewed clock), `Name(value, maxLength)` (no control characters or pipes) and `Optional(check, value)`.

The kit checks the batch itself: it must be a list, no longer than 64 rows, with no gaps and only tables. A batch that is not is refused whole and the cursor moves past it, since asking again would fail the same way. Inside a good batch each row is its own case: an unknown kind is skipped, an invalid row is dropped and counted, and the rest merge.

## What stays in the module

- The row shape: what `wire` sends and `validate` accepts, written against the module's own data and the game's (map IDs, item and recipe lookups, spells).
- The two layers. The kit never reads or writes either. `Mark` and `Load` take found entries only; `merge` is the only way received data enters, and it writes the shared layer only. A module never moves shared data into found or into its export, so a shared row can never be mistaken for something the player saw.
- How shared data is shown, and the settings that decide `sending` and `receiving`. Sending and receiving are separate choices (Recipe Vacuum: Share My Finds and the source level); the connection is up while either is on.
- How rows merge. Recipe Vacuum merges per field with the time each was learned, so any order of the same reports gives the same result and a repeat changes nothing.

A module that shares embeds AceComm-3.0 and ChatThrottleLib (the kit takes them from LibStub when it first connects) and lists them in its TOC before the kit.

## Logging

Every step goes to the module's working-build log through `lib:Trace`, as lines starting `SHARE`: each message sent (and each not sent, with why), each probe and request heard and each ignored with its reason (not trusted, wrong channel, unreadable header, not the reply asked for, receiving off), each peer queued or dropped, each batch received with its size and range, each row rejected with its reason (the module's `validate` reason), the merge result, timeouts, retries and giving up, and counter renumbering. The shared frame's events are written to every sharing module's log by the kit. Nothing is built unless the log is on.

## Working build

`share:SelfTest(report, merge, summary)` builds every reply with the real code, checks it against the limits and the receiver's header rules, decodes it, hands the rows to `merge(rows)` (the module merges into a scratch copy of its data and returns `changed, skipped`), and whispers each reply to the same character over the `<prefix>T` test prefix to prove it arrives unchanged. It does not cover choosing who to share with or the probe exchange between two players, which need two clients. A module calls it from its own debug-only command.

## Consumers

| Module | Rows | Status |
|---|---|---|
| Recipe Vacuum | trainer, vendor, quest, drop | On the kit; protocol 2 unchanged |
| Sparklescope (`cairn:4bpdf`) | herbs, ore, bobbers, chests learned from loot | Designed for: several kinds in `k`, validation against game data by the module |
| Tackletron zones | later | Same shape |

## Known gaps

| Gap | Who can reach it today | What would make it worth fixing |
|---|---|---|
| AceComm buffers a multipart message before the kit checks the sender or its size; the 64 KiB expanded limit is checked after decompression | Any player who can send addon messages to a module's prefix | A measured memory or frame cost, or a report |
| A module's rows are limited to what CBOR carries (numbers, strings, booleans, lists, tables) | Module authors | A module that needs more |
| Log lines for ignored messages are written for every message that reaches the prefix, trusted or not | Working builds only | A log filling with strangers' traffic |
| Any group member is trusted, random dungeon groups included, and a row's source cannot be checked against game data, so a modified client can add made-up sources to the shared layer without limit | A player in the same group or guild running a modified client; never seen | A report of invented sources; the fix is a cap on shared sources per recipe |
| A newer copy of the kit that loads after an older one has started working-build frames (`blockedListener`, `watchFrame`, `logWriter`) keeps the older copy's scripts on them | Working builds only, and only while modules carry different kit versions | A working-build log missing events after a partial update |
