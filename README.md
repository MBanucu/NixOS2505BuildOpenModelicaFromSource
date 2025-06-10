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
