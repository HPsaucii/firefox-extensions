{
  description = "A flake providing home-manager configuration options for firefox extensions.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs =
    inputs@{
      flake-parts,
      home-manager,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        withSystem,
        moduleWithSystem,
        flake-parts-lib,
        ...
      }:
      {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        perSystem =
          { pkgs, ... }:
          {
            formatter = pkgs.nixfmt-rfc-style;
          };

        flake.homeManagerModules.firefox-extensions = moduleWithSystem (
          perSystem@{ config }: flake-parts-lib.importApply ./homeManagerModules/firefox-extensions perSystem
        );
      }
    );
}
