# Hello Aurora: Knob Colour Control & Audio Passthrough

**Date:** 2026-06-17
**Project:** `hello-aurora`

## Overview

Extend the minimal `hello-aurora` starter project to:

1. Map each of the 6 knobs to the hue of a corresponding abstract LED, cycling through the full rainbow as the knob is turned.
2. Pass stereo audio through the module with volume controlled by the MIX knob.
3. Light the FREEZE and REVERSE button LEDs while their buttons are held.
4. Leave the bottom LEDs (`LED_BOT_1/2/3`) dark.

---

## Hardware Context

- **6 knobs:** `KNOB_TIME`, `KNOB_REFLECT`, `KNOB_MIX`, `KNOB_ATMOSPHERE`, `KNOB_BLUR`, `KNOB_WARP`
- **11 RGB LEDs total:**
  - `LED_1`–`LED_6`: abstract/decorative — not physically adjacent to any knob
  - `LED_FREEZE`, `LED_REVERSE`: physically attached to their respective buttons
  - `LED_BOT_1/2/3`: unknown physical location; green+blue only (no red channel); left dark
- **2 buttons:** `SW_FREEZE` (snowflake icon), `SW_REVERSE` (arrows icon, relates to mode)
- **API:** `hw.GetButton(SW_FREEZE).Pressed()` — use `GetButton`, not the stale `GetSwitch` comment in the header

---

## Architecture

```
hello-aurora/
├── main.cpp           # hardware wiring only — no logic
├── colour.h           # pure HSV→RGB math, no Aurora/Daisy dependency
├── audio.h            # pure stereo volume scale, no Aurora/Daisy dependency
├── Makefile           # existing ARM embedded build (unchanged)
└── tests/
    ├── Makefile       # host g++ build — runs on Linux, no ARM toolchain
    ├── test_colour.cpp
    └── test_audio.cpp
```

`colour.h` and `audio.h` have **zero dependency on Aurora or Daisy headers** — they operate on plain floats only. `main.cpp` is the only file that touches the SDK.

---

## Modules

### `colour.h`

```cpp
struct Rgb { float r, g, b; };
Rgb hsvToRgb(float h, float s, float v);
```

- `h` in `[0, 1)` — hue cycles through the rainbow
- `s = 1.0f`, `v = 1.0f` always (fully saturated, full brightness)
- `h = 1.0` wraps to red (same as `h = 0.0`)
- Standard 6-sector HSV→RGB algorithm

Knob→LED mapping (logical, not spatial):

| Knob | LED |
|------|-----|
| `KNOB_TIME` | `LED_1` |
| `KNOB_REFLECT` | `LED_2` |
| `KNOB_MIX` | `LED_3` |
| `KNOB_ATMOSPHERE` | `LED_4` |
| `KNOB_BLUR` | `LED_5` |
| `KNOB_WARP` | `LED_6` |

`KNOB_MIX` doubles as both volume control and `LED_3` hue — same physical dial, two effects.

### `audio.h`

```cpp
struct StereoFrame { float left, right; };
StereoFrame scaleVolume(StereoFrame in, float volume);
```

- `volume` from `KNOB_MIX` in `[0, 1]`
- Scales both channels by `volume`
- Called per sample inside the audio callback in `main.cpp`

### `main.cpp`

Responsibilities:
- `hw.Init()` and `hw.StartAudio(AudioCallback)`
- Audio callback: `hw.ProcessAllControls()`, read `KNOB_MIX`, call `scaleVolume()` per sample
- Main loop (runs as fast as possible — no delay): `hw.ClearLeds()`, set `LED_1`–`LED_6` via `hsvToRgb(hw.GetKnobValue(knob), 1, 1)`, set button LEDs, `hw.WriteLeds()`
- Button LEDs: `GetButton(SW_FREEZE).Pressed()` → `SetLed(LED_FREEZE, 1,1,1)`, else off; same for `SW_REVERSE`/`LED_REVERSE`

---

## Testing

### Framework

[doctest](https://github.com/doctest/doctest) — single-header, downloads at test build time if absent.

### `tests/Makefile`

Compiles with `g++` on the host. No ARM toolchain required. Runs both test binaries after building.

### `test_colour.cpp` — hue boundary cases

| Input `h` | Expected RGB |
|-----------|-------------|
| 0.0 | (1, 0, 0) red |
| 1/6 | (1, 1, 0) yellow |
| 1/3 | (0, 1, 0) green |
| 1/2 | (0, 1, 1) cyan |
| 2/3 | (0, 0, 1) blue |
| 5/6 | (1, 0, 1) magenta |
| 1.0 | (1, 0, 0) wraps to red |

### `test_audio.cpp` — volume cases

| `volume` | Input | Expected output |
|----------|-------|-----------------|
| 1.0 | (0.5, -0.3) | (0.5, -0.3) |
| 0.0 | (0.5, -0.3) | (0.0, 0.0) |
| 0.5 | (0.8, 0.4) | (0.4, 0.2) |

---

## Out of Scope

- CV inputs (not wired in this feature)
- `LED_BOT_1/2/3` (left dark)
- Any use of `SW_SHIFT` or gate inputs
- Calibration or persistent storage
