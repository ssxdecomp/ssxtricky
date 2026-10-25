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

If what you have is a disc image rather than loose files, pull just the executable out of it:

```bash
$ mkdir -p disc
$ isoinfo -i /path/to/ssx.iso -x '/SLUS_203.26;1' > disc/SLUS_203.26
$ sha1sum disc/SLUS_203.26
45e9fd5fa4c0b30ffbd4155a9e256d5eabc65d23  disc/SLUS_203.26
```

Keep the image itself outside the working tree; `disc/` and the usual disc-image extensions are ignored.

Download the toolchain -- the decompals binutils and ee-gcc 2.9, both pinned
and checked against a sha256:

```bash
$ ./download.sh
```

Neither lives in the repository. Re-running is a no-op once the versions on disk
match the pins; delete `tools/binutils` or `tools/cc/ee-991111-01` to force a
re-download. See `tools/cc/README.md` for where the compiler comes from and
under what terms.

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
