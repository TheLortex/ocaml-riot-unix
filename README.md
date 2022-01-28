## RIOT / OCaml build system

To setup, you need to clone RIOT-OS somewhere:
https://github.com/RIOT-OS/RIOT

And set up the `RIOTBASE` environment variable to point on that folder.

Then run `make` to build the project.

GCC 32bit libraries: 
- on debian: `sudo apt install gcc-multilib`
- on fedora: `sudo dnf install glibc-devel.i686`

OCaml version: 4.12.1
