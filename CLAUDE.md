# CLAUDE.md

## Project Overview

**asma** is a collection of x86 assembly language programs targeting DOS as .COM executables. These are small command-line utilities and demos written in 16-bit real-mode assembly, using direct BIOS and DOS interrupts for I/O.

- **Language**: x86 Assembly (16-bit real mode)
- **Target**: DOS .COM executables
- **License**: Apache 2.0

## Repository Structure

```
asma/
├── CLAUDE.md              # This file
├── README.md              # Project overview
├── LICENSE                # Apache License 2.0
├── cga_test/
│   └── cga_test.asm       # CGA graphics mode demo (320x200, 4-color)
└── racer/
    └── racer.asm           # Text-mode DOS racing game
```

Each subdirectory contains a standalone `.asm` program that assembles into a single `.COM` executable.

## Programs

### cga_test
A minimal CGA graphics demo that sets 320x200 4-color graphics mode, changes the palette, plots a single green pixel at (160, 100), waits for a keypress, then restores text mode and exits.

### racer
A text-mode DOS racing game with track rendering, keyboard input handling, speed management, collision detection, and a game loop driven by system time for pacing.

## Build & Run

There is no Makefile or automated build system. Programs are assembled manually using a MASM-compatible assembler (e.g., MASM, TASM).

Typical workflow:
```
masm <program>.asm;
link <program>.obj;
exe2bin <program>.exe <program>.com
```

Run the resulting `.com` file in a DOS environment or emulator (e.g., DOSBox).

## Testing

No automated tests. Testing is manual: assemble, run in DOS/emulator, and verify behavior visually.

## Code Conventions

- **Memory model**: `.MODEL SMALL` — code and data in a single 64KB segment
- **Entry point**: `ORG 100h` for .COM format; main procedure named `MASTER` or `master`
- **Mnemonics and registers**: uppercase (`MOV`, `AX`, `INT 10h`)
- **Procedure/label names**: lowercase with underscores (`load_prop`, `clear_s`, `mov_cur`)
- **Constants**: lowercase with underscores, defined via `EQU` (`fill equ 010h`)
- **Comments**: inline with `;` — every instruction should have a comment explaining its purpose
- **Register preservation**: procedures save/restore registers with `PUSH`/`POP`
- **Program termination**: `INT 20h`

## Key Patterns

- **BIOS video services** via `INT 10h`: set video mode (AH=0), set palette (AH=0Bh), write pixel (AH=0Ch), set cursor (AH=02h), read/write character (AH=08h/09h), scroll screen (AH=06h)
- **DOS services** via `INT 21h`: keyboard input (AH=07h), check keyboard status (AH=0Bh), get system time (AH=2Ch)
- **Procedure structure**: `<name> PROC NEAR` / `<name> ENDP` with matching `PUSH`/`POP` for callee-saved registers
- **Input dispatch**: table-driven input handling — arrays of (key, handler_address) pairs scanned linearly

## Guidelines for AI Assistants

- Preserve the existing comment style: every assembly instruction should have an inline `;` comment
- Keep uppercase for x86 mnemonics and register names; lowercase for labels and constants
- Each program is self-contained in its own directory with a single `.asm` file
- Do not introduce modern tooling (Makefiles, CI, linters) unless explicitly requested
- When adding new programs, follow the existing pattern: new subdirectory with a single `.asm` file
- Maintain `.COM` executable conventions: `ORG 100h`, `SMALL` model, terminate with `INT 20h`
