# SSX Tricky

This is a work-in-progress decompilation of SSX Tricky for the PlayStation 2.

This project builds the NTSC-U version of the game (`SLUS_203.26`). Other regions and versions may be considered once NTSC-U has been completed and matched.

## Setup

You will need:

- a Linux system that can run 32 bit applications. WSL2 should work as well.
  The compiler in `tools/cc` is a 32 bit i386 binary.
- Python 3.13, with pipenv
- A NTSC-U disc image (obtained legally)

### Arch Linux

`# pacman -S lib32-gcc-libs`

### Debian/Ubuntu

`# apt install -y pipenv ninja-build`

### Fedora

`# dnf install -y python3.13 ninja-build glibc.i686`

Fedora does not package pipenv; install it with `pip install --user pipenv` or `uv tool install pipenv`.

Make a `disc` directory in the root of this repository, and copy the files from the NTSC-U game disc. Only `disc/SLUS_203.26` is needed to build; the rest of the disc is for asset work later.

Download required tools:

```bash
$ ./download.sh
```

Setup a venv for splat:

```bash
$ pipenv install
```

`pipenv run ./configure.py` ultimately does the setup.

## Building

`ninja` should do the trick.

The build is correct when the rebuilt image is byte-identical to the disc's executable, which `ninja` checks for you against `config/checksum.sha1`. Pass `--skip-checksum` to `configure.py` while you are deliberately mid-change.

## Tools

| | |
| --- | --- |
| `pipenv run python -m mapfile_parser first_diff out/SLUS_203.26.map disc/SLUS_203.26` | report the first byte that diverges from the disc's executable, and which symbol it is in |
| `tools/compdb` | write `compile_commands.json` for clangd |
| `./configure.py --objects` | build objects twice, into `obj/target` and `obj/current`, and write `objdiff.json` |

## Documentation

- `doc/styleguide.md` -- naming and formatting, following the original codebase.
