# 0053. A square for the best lure and one for the best Fishing food

- Date: 2026-11-23
- Status: accepted
- Scope: Tackletron
- Kind: panel

## Context

Players want to see the lure and food they have, and whether one is on.

## Decision

Small action buttons sit left of the fishing button, the lure nearest, each with its count and shown when there is one. A click uses the item whether or not it is needed; the key never eats, since eating means sitting for ten seconds. They are secure, so they change out of combat only, and their macros stay filled so they still work in combat. The lure square stays while a lure is on the pole and none is left, dimmed with a count of 0 and the enchantment's own icon, so its time left and the lure setting stay in reach. A lure on the pole or Well Fed from Fishing food shows as the time left, in the action button's own cooldown sweep. The client gives a lure's time left but not its length, so the sweep starts when the lure is first seen.

## Reasons

- An action button shows a used-up item dimmed (`ActionButton.lua`, icon vertex color 0.4).
- The buff frame shows the enchantment's icon, so it matches the pole.
- Anchoring frame to frame, since a protected frame cannot anchor to a texture.

## Rejected

- The key eating food.

## Versions

- Tackletron `eda4fa1`, `e3a4372`, `df4c385`, `bd4d638`, `90dc147`, `790d581`

## Tests

- Specs "a lure in the bags: its square shows, and a click puts it on the pole", "the last lure went on the pole: a square stays with the enchantment's own icon, dimmed at 0", "Fishing food in the bags: its square shows left of the lure's, and a click eats it", "lure on the pole: its square counts down ten minutes", "five minutes later: the same sweep, not a new one", "Well Fed: the food square counts down from when it began".

## Reopen if

The client gives a lure's length, so the sweep need not start at first sight.
