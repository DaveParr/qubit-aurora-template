# Aurora Firmware Template

A minimal, ready-to-fork starting point for writing your own firmware for the [Qu-Bit Aurora](https://www.qubitelectronix.com/shop/aurora) eurorack module.

## What's included

| Path | Purpose |
|------|---------|
| `hello-aurora/` | Example project: knob-driven LED colours + audio passthrough |
| `lib/Aurora-SDK` | Git submodule — Aurora BSP, libDaisy, DaisySP |
| `config.mk` | Shared toolchain and SDK path config |
| `Makefile` | Top-level `build` / `flash` / `libdaisy` targets |

### hello-aurora

A small firmware that exercises the main hardware features:

- Each knob drives the hue of its paired RGB LED (HSV colour model)
- `KNOB_MIX` also scales the stereo audio passthrough volume
- `SW_FREEZE` and `SW_REVERSE` light their attached LEDs white when held
- `LED_BOT_1/2/3` mirror the first three knob colours (useful for physical position mapping)

The `hello-aurora/tests/` directory has host-side unit tests for the `colour.h` and `audio.h` helpers, built and run with plain `g++` and [doctest](https://github.com/doctest/doctest).

## Getting started

### 1. Use this template

Click **"Use this template"** on GitHub (top-right of the repo page) to create your own repository. Then clone it **with submodules**:

```sh
git clone --recurse-submodules https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
```

If you forgot `--recurse-submodules`:

```sh
git submodule update --init --recursive
```

### 2. Install the ARM toolchain

The build uses `gcc-arm-none-eabi`. The default path in `config.mk` is:

```
~/.local/share/gcc-arm-none-eabi/gcc-arm-none-eabi-10-2020-q4-major/bin
```

You can install the toolchain there, or override the path at build time:

```sh
make build PROJECT=hello-aurora GCC_PATH=/path/to/your/arm-gcc/bin
```

The [Aurora-SDK README](lib/Aurora-SDK/README.md) has OS-specific toolchain installation instructions for Windows, macOS, and Linux.

### 3. Build libDaisy (one-time)

```sh
make libdaisy
```

This compiles the libDaisy static library from source inside the submodule. Only needed once, or after updating the submodule.

### 4. Build and flash hello-aurora

Put the Aurora into **bootloader mode** (hold the encoder while powering on, or use the bootloader firmware), then mount the USB drive it presents.

```sh
# Build
make build PROJECT=hello-aurora

# Flash (adjust MOUNT to where the Aurora appears on your system)
make flash PROJECT=hello-aurora MOUNT=/media/YOUR_USER/AURORA
```

The `flash` target copies the `.bin` and syncs — safely eject the Aurora afterward to boot into your firmware.

### 5. Run the unit tests

The tests compile and run on your host machine (no hardware needed):

```sh
cd hello-aurora/tests
make
```

## Starting your own project

1. Copy `hello-aurora/` to a new directory:
   ```sh
   cp -r hello-aurora my-effect
   ```
2. Update the `TARGET` variable in `my-effect/Makefile` to match the folder name.
3. Edit `my-effect/main.cpp` — the `hw` object, `AudioCallback`, and `main` loop are your entry points.
4. Build and flash:
   ```sh
   make build PROJECT=my-effect
   make flash PROJECT=my-effect MOUNT=/media/YOUR_USER/AURORA
   ```

## Hardware reference

See [context.md](context.md) for notes on physical LED positions, knob layout, button names, and bottom-LED hardware constraints that aren't obvious from the SDK headers.

## License

MIT — see [LICENSE](LICENSE).
