# 0079. Sparklescope says a line when it learns an unknown chest

- Date: 2026-11-27
- Status: accepted
- Scope: Sparklescope 6000
- Kind: chat

## Context

Sparklescope said one line, once: the object plates line on keyboard. Chests on its shipped list sparkle from the start; a chest on no list is learned when the player opens it, which is rare.

## Decision

When an opened chest was on no list, found or shared, Sparklescope says "chirps. Unknown container logged! Added to the lens array!" It can repeat, so it sits behind a Show Chat Alerts checkbox, on by default, in Chest Sources (0043). The first sparkle ever shown says, once per install, "whirs to life. Calibration complete! Sparkle emitters online!", as the device starting up.

## Reasons

- The device noticing a new object is what a gadget would report.
- A repeating line gets one Chat Alerts checkbox (0043).

## Rejected

- No new lines.
- A greeting at login: the first sparkle is the moment the device does something.

## Versions

- Sparklescope6000 d760140 (chest line), 04bc4ec (first sparkle)

## Tests

- scripts/check passes; not yet heard in game.

## Reopen if

The line shows for chests the player already sees sparkle, or players find it noisy.
