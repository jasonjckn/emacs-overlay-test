#
#   __ _       _                _
#  / _| | __ _| | _____   _ __ (_)_  __
# | |_| |/ _` | |/ / _ \ | '_ \| \ \/ /
# |  _| | (_| |   <  __/_| | | | |>  <
# |_| |_|\__,_|_|\_\___(_)_| |_|_/_/\_\
#
{
  inputs = {
    # emacs-src.flake = false;
    # emacs-src.url = "git+https://github.com/emacs-mirror/emacs";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # emacs-overlay.url = "github:jasonjckn/emacs-overlay";
    emacs-overlay.url = "path:emacs-overlay";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      lib = import ./lib { inherit inputs; };
      # inherit (lib._) mapModules eachDefaultSystem;
      inherit (inputs.flake-utils.lib) eachDefaultSystem;

    in
      (eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {};
            overlays = [inputs.emacs-overlay.overlays.default];
          };

        in
          {
            packages.default = pkgs.emacsGitTreeSitter.override {
              nativeComp = false;
            };
          }
      ));
}
