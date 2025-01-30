# Declarative configurations for firefox addons

This flake provides you the options required to declaratively configure addons for firefox through home-manager.

Usage:
```nix
# flake.nix
{
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        firefox-extensions = {
            url = "github:HPsaucii/firefox-extensions";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    # ...
}
```

```nix
# firefox.nix

    imports = [
        inputs.firefox-extensions.homeManagerModules.firefox-extensions
    ];

    programs.firefox = {
        enable = true;
        profiles.default.extensions = {
            packages = [
                # a list of addons to install
            ];
            settings."extension@author" = { # might need "{some_id_numbers}" for certain extensions
                settings = {
                    # settings to enable
                };
            };
        };
    };

```
