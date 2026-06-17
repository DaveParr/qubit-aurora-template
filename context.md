# Aurora Project Context

## Hardware Layout Notes

- The Aurora has 6 knobs (TIME, REFLECT, MIX, ATMOSPHERE, BLUR, WARP) and 11 RGB LEDs.
- The numbered LEDs (LED_1 through LED_6) are **not** physically adjacent to the knobs.
  They are abstract/decorative — the knob-to-LED mapping is a logical one, not a spatial one.
- Do not design UX around the assumption that a LED is "next to" its paired knob.

## Button LEDs (physically paired)

- `SW_FREEZE` button has `LED_FREEZE` directly attached — snowflake icon.
- `SW_REVERSE` button has `LED_REVERSE` directly attached — arrows icon, relates to mode.
- These are the only LEDs with a clear physical/semantic relationship to a control.

## Bottom LEDs

- `LED_BOT_1`, `LED_BOT_2`, `LED_BOT_3` — physical location unknown beyond "bottom".
- Hardware constraint: no red channel (`r = -1` in LedMap), green and blue only.
- Left dark for now — not used in the initial feature.
