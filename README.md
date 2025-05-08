# COMAL80 Sound2 Package (Loadable)

This repository contains an extracted and standalone **Sound Package** for **COMAL80** (e.g., on the C64). It provides the internal assembler routines used by the COMAL sound commands (`SOUND`, `TONE`, etc.).

## Features

- Based on the original COMAL80 sound module.
- Can be loaded independently, via `LINK` command from Disk
- Includes a patch for the **IRQ routine** to enable calling the relocated sound routine from a different memory page.
- Commands are available under modified names to avoid conflicts (`NOTE2`, `PULSE2`, etc.).

## Usage

The package can be loaded from disk using the COMAL command:

```
LINK "SOUND2"
```

This makes the additional sound commands and IRQ patching available.

The commands provided by this package mirror the original COMAL sound commands but use a `2` suffix:

- `NOTE2`
- `PULSE2`
- `PLAYSCORE2`
- (and others)

These allow for side-by-side use without name collisions. However, **once the new IRQ routine is active**, the original commands (e.g. `NOTE`) will no longer function correctly, as their IRQ handler is no longer in use.

### Switching Between Sound Systems

To support both versions in the same COMAL session:

1. Load both packages:
   ```comal
   USE SOUND
   USE SOUND2
   ```

2. Switch between the IRQ handlers with:
   - `SET'IRQ` – redirects the IRQ to the new sound routine (for use with `NOTE2`, etc.)
   - `RESET'IRQ` – restores the original COMAL IRQ routine (for use with `NOTE`, etc.)

This makes it possible to test or use both systems dynamically.

## Purpose

The main goal of creating this standalone package was to allow for **custom extensions and modifications** of the sound routines without altering the original COMAL80 system. This enables experimentation and integration of user-defined sound logic.

## License

MIT License – see license notice in the source code.

---

*This documentation was prepared with the assistance of AI (ChatGPT by OpenAI).*