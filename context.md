# Aurora Project Context

## Hardware Layout Notes

- The Aurora has 6 knobs (TIME, REFLECT, MIX, ATMOSPHERE, BLUR, WARP) and 11 RGB LEDs.
- The numbered LEDs (LED_1 through LED_6) form an arc around the module — like an upside-down L:

```
  [2]   [3]   [4]
                 [5]
[1]              [6]
```

  - `LED_1` — bottom left
  - `LED_2`, `LED_3`, `LED_4` — across the top (left to right)
  - `LED_5`, `LED_6` — down the right side (top to bottom)

- Physical adjacency to knobs (informational — do NOT assume LEDs are "paired" to these knobs):
  - `LED_2` is near `KNOB_WARP`
  - `LED_4` is near `KNOB_TIME`
  - `LED_5` is near `KNOB_REFLECT`
  - `LED_6` is near `KNOB_ATMOSPHERE`
  - `LED_1` and `LED_3` have no adjacent knob

- The code mapping (KNOB_TIME → LED_1, etc.) is **logical**, not spatial. Do not redesign
  around physical adjacency unless explicitly requested.

## Button LEDs (physically paired)

- `SW_FREEZE` button has `LED_FREEZE` directly attached — snowflake icon.
- `SW_REVERSE` button has `LED_REVERSE` directly attached — arrows icon, relates to mode.
- These are the only LEDs with a clear physical/semantic relationship to a control.

## Bottom LEDs

- Hardware constraint: no red channel (`r = -1` in LedMap), green and blue only.
  The SDK silently discards the red value — no crash, G and B still set normally.
- The "BOT" name refers to the LED driver chip, not physical position — these LEDs
  are scattered around the module, not grouped at the bottom.

**Verified physical positions (confirmed by hardware test):**

| SDK name | Knob driving it | Physical position |
|----------|----------------|-------------------|
| `LED_BOT_1` | `KNOB_TIME` | Middle of module |
| `LED_BOT_2` | `KNOB_REFLECT` | Right of module |
| `LED_BOT_3` | `KNOB_MIX` | Top of module |

## Knob Physical Layout

Two columns, top to bottom, left to right:
- Left column: WARP, BLUR, MIX
- Right column: TIME, REFLECT, ATMOSPHERE
