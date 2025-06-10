# default.nix
let
  pkgs = import <nixpkgs> {
    config.permittedInsecurePackages = [
      "python-2.7.18.8"
    ];
  };
in
rec {
  openmodelica-core = pkgs.callPackage ./openmodelica-core.nix { };
  openmodelica = pkgs.callPackage ./openmodelica.nix { inherit openmodelica-core; };
}
