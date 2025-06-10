# NixOS2505BuildOpenModelicaFromSource

## to all the nerds
Feel free to optimize this build and push it to [https://github.com/NixOS/nixpkgs.git](https://github.com/NixOS/nixpkgs.git) or something.

## example instructions
Tested for NixOS 25.05 on 2025-06-10.
```bash
nix-shell -p '(import ./default.nix).openmodelica'
```
Inside the nix shell the most interesting available program is
```bash
OMEdit
```