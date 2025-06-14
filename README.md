# NixOS2505BuildOpenModelicaFromSource

## to all the nerds
Feel free to optimize this build and push it to [https://github.com/NixOS/nixpkgs.git](https://github.com/NixOS/nixpkgs.git) or something.

## example instructions
Tested for NixOS 25.05 on 2025-06-10.
```bash
git clone https://github.com/MBanucu/NixOS2505BuildOpenModelicaFromSource.git
cd NixOS2505BuildOpenModelicaFromSource
nix-shell -p '(import ./default.nix).openmodelica'
```
Inside the nix shell the most interesting available program is
```bash
OMEdit
```

## working features
- compilation of openmodelica-core (using "-DOM_OMEDIT_ENABLE_QTWEBENGINE=ON")
- open OMEdit (using QT_PLUGIN_PATH)
  - SVG icons loading for toolbar (using qt5.full)
  - "Tools" -> "Open Terminal" is starting xterm
    - by linking x-terminal-emulator to xterm in the wrappig process
    - terminal emulator can also be set manually by "Tools -> Options -> General -> Terminal Command"
  - creating Modelica Classes
  - simulation compilation
    - library lgfortran found (using LD_LIBRARY_PATH + gfortran.cc.lib)
    - libraries llapack and lblas found (using LIBRARY_PATH + openblas + lapack)
  - export FMU (using cmake + clang + zip)
  - open mo files created on Windows version of OpenModelica OMEdit (it just works)
  - simulate and plot mo files created on Winsows version of OpenModelica OMEdit (it just works)

## disabled / not working
- OM_OMC_ENABLE_FORTRAN + OM_OMC_ENABLE_IPOPT because of fortran linking errors at openmodelica-core
- Ctrl + right click into xterm (using "Tools" -> "Open Terminal" in OMEdit) crashes xterm

## unknown workarounds
- Replace -isystem with -I in NIX_CFLAGS_COMPILE and I don't know why this has to be done or how to correct it correctly
- ccache maybe doesn't make sense here since the compilation will only run once on the same codebase and ccache doesn't have access to outside global cache locations