# Control test

A throwaway addon, `JigBoltgripControlTest`, with one options page ("Control Test", under AddOns) of every candidate Blizzard Settings control, built with Blizzard's own API only (no toolkit). It shows which controls work with the d-pad on the Steam Deck (Gamepad UI) and with mouse and keyboard. It is never packaged (`.pkgmeta` ignores `tools`) and is removed after the test.

Every control prints one chat line, `ControlTest: <name> = <value>`. `ADDON_ACTION_BLOCKED`, `ADDON_ACTION_FORBIDDEN` and the "Interface action failed" message print too.

## Controls

| Section | Control | API |
|---|---|---|
| Basic | Checkbox | `Settings.CreateCheckbox` |
| Basic | Checkbox with an indented child | `SetParentInitializer(parent, predicate)` |
| Basic | Slider with named stops (Off to Max) | `Settings.CreateSlider`, label formatter |
| Dropdown | Dropdown of four words | `Settings.CreateDropdown` |
| Grouped choices | 18 checkboxes in 3 groups of 6 | `Settings.CreateCheckbox` |
| Other | Button row | `CreateSettingsButtonInitializer` |
| Other | Checkbox and slider in one row | `CreateSettingsCheckboxSliderInitializer` |

Skipped: a key binding row. Binding names are declared in a `Bindings.xml`, which a module-free addon does not have.

## Run it

```
tools/ControlTest/deploy-deck            # copy to the Deck (host deck-host)
tools/ControlTest/deploy-deck --remove   # take it off the Deck
```

Reload the game, then open Options, AddOns, Control Test.

## Steps

Gamepad, for each control: reach it with the d-pad. Change it with left/right or A. For the dropdown, open it with A, pick an entry, then move up and down the list. Then go to another category and back.

Pass means all of: no "Interface action failed" and no `ADDON_ACTION_*` line, the cursor never sticks, other addons' pages still navigate.

Keyboard and mouse: click or drag each control. Pass means the value changes and its chat line prints.

## Results

| Control | Gamepad | Mouse | Notes |
|---|---|---|---|
| Checkbox | | | |
| Checkbox with child | | | |
| Slider with named stops | | | |
| Dropdown | | | |
| Grouped checkboxes | | | |
| Button row | | | |
| Checkbox and slider row | | | |
