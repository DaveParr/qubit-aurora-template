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
  The SDK silently discards the red value — no crash, G and B still set normally.
- Driven by knob hue (same `hsvToRgb` path as numbered LEDs); red component is just dropped.
- **Initial mapping (unverified — update after hardware test):**
  - `LED_BOT_1` → `KNOB_TIME`
  - `LED_BOT_2` → `KNOB_REFLECT`
  - `LED_BOT_3` → `KNOB_MIX`

## Knob Physical Layout

Two columns, top to bottom, left to right:
- Left column: WARP, BLUR, MIX
- Right column: TIME, REFLECT, ATMOSPHERE
