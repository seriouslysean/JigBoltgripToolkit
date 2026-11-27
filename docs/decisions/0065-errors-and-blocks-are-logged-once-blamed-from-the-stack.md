# 0065. Errors and blocks are logged once, blamed from the stack

- Date: 2026-11-27
- Status: accepted
- Scope: all modules
- Kind: gamepad and taint

## Context

Every module embeds a copy of the kit, and LibStub runs the first-loaded copy of the highest MINOR, so the game blames whichever module carried that copy for any taint the kit causes ([client-notes.md](../client-notes.md), taint blame). The working build wrote each blocked action and Lua error into every module's log, so one error appeared five times, under a module that may not have caused it.

## Decision

Each blocked action, "interface action failed" message and Lua error is written once, to one module's log, chosen from its stack:

- the first frame in a module's own file (`AddOns/<Folder>/…`, not its `Libs/JigBoltgripToolkit` copy) owns it;
- a stack through kit code only goes to the module whose copy ran it, tagged `[kit, via <Folder>'s copy]`;
- with no addon file in the stack (a block raised from C), it goes to the module the game named, tagged `[game blames <addon>]`.

The entry keeps the stack and, for blocks, the tainted gamepad fields (`lib:ScanTaint`, MINOR 77). The grey `[Debug]` chat line carries the same tag. Shared context (zone, device, pad moves) still goes to every log.

## Reasons

- AutoOmniadjustor was blamed on the Deck (2026-11-27 07:02) while its kit copy was the one running for every module, so the blame could have been the kit's.
- The stack names the file that actually ran; the game's blame names only the addon whose code was executing when taint was found.

## Owner's words

"Once, blamed from the stack" (2026-11-27, choosing between this, a separate dev-only log addon and keeping every log).

## Rejected

- A separate working-build-only addon holding one shared log: one more folder to deploy, against the earlier call to keep test fixtures inside an existing module.
- Keeping each error in every module's log.

## Versions

- Kit MINOR 80; Recipe Vacuum takes it in the same change. Client 1.60.1 (71139).

## Tests

- Specs (`tests/loadorder_spec.lua`): "an error goes once, to the module whose own file is in its stack", "an error through kit code only goes to the module whose copy ran it, tagged as the kit's", "a block with no addon file in its stack goes to the module the game blamed". Each fails when its rule is removed.
- Deck: pending. The next blocked action or Lua error shows one log entry and a `[Debug]` line with the owner's tag.

## Reopen if

A stack's file paths turn out unreliable on Forever (missing, or naming Blizzard code only), or a module needs errors it did not cause in its own log.
