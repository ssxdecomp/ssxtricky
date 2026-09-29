# Compiler tools

The following compilers were known to be used for SSX OG:

| Compiler                | Description                                                                                                          |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------- |
| ee-gcc 2.9-ee-990721    | From the Pre-release toolchain 0.5.0 (EB-S8220) for the EE. Used presumably from TC 0.5 release to TC 1.0 release    |
| ee-gcc 2.9-ee-991111    | Used from Toolchain 1.0(?) Release date (~November 11, 1999) to gold builds                                          |

We have been able to recover important compiler flags (for at least C) from a makefile fragment that was accidentally included as uninitalized memory in a US demo build. They are:

| Type                    | Flags                                    | Notes                                                              |
| ----------------------- | ---------------------------------------- | ------------------------------------------------------------------ |
| Debug                   | `-g -G0 -O0`                             | Interestingly also disables usage of gp register..                 |
| Test                    | `-g -O2 -fno-edge-lcm`                   | Close to release flags but with -g (debug info) and no fp-omission |
| Release (and ReleaseCD) | `-O2 -fno-edge-lcm -fomit-frame-pointer` | Adds fp-omission.                                                  |

`-fno-exceptions` is no longer a guess: without it, gcc 2.9 emits a
`_GLOBAL_$F$<translation unit>` frame-registration entry into `.data` for every
C++ translation unit -- 0x18 bytes apiece -- and a build carrying those cannot
match. Passing it takes the object's `.data` to zero.

`-fno-rtti` is still an assumption. On a trivial translation unit it changes
nothing observable (it does *not* suppress the frame entry on its own), so it can
only be confirmed or refuted against real classes with virtual functions.

`-fno-edge-lcm` does not exist in ee-990721, which is how it has been figured out that ee-991111 was used for the final builds.