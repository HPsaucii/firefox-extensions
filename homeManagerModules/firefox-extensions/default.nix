perSystem: {
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  modulePath = ["programs" "firefox"];

  moduleName = concatStringsSep "." modulePath;

  mkFirefoxModule = import ./firefox/mkFirefoxModule.nix;
in {
  meta.maintainers = [maintainers.rycee hm.maintainers.bricked];

  disabledModules = ["programs/firefox.nix"];

  imports = [
    (mkFirefoxModule {
      inherit modulePath;
      name = "Firefox";
      wrappedPackageName = "firefox";
      unwrappedPackageName = "firefox-unwrapped";
      visible = true;

      platforms.linux = rec {
        vendorPath = ".mozilla";
        configPath = "${vendorPath}/firefox";
      };
      platforms.darwin = {
        vendorPath = "Library/Application Support/Mozilla";
        configPath = "Library/Application Support/Firefox";
      };
    })

    (mkRemovedOptionModule (modulePath ++ ["extensions"]) ''
      Extensions are now managed per-profile. That is, change from

        ${moduleName}.extensions = [ foo bar ];

      to

        ${moduleName}.profiles.myprofile.extensions.packages = [ foo bar ];'')
    (mkRemovedOptionModule (modulePath ++ ["enableAdobeFlash"])
      "Support for this option has been removed.")
    (mkRemovedOptionModule (modulePath ++ ["enableGoogleTalk"])
      "Support for this option has been removed.")
    (mkRemovedOptionModule (modulePath ++ ["enableIcedTea"])
      "Support for this option has been removed.")
  ];

  config = {
    assertions = [
      {
        assertion =
          all (profile: profile.extensions != [])
          (attrValues config.programs.firefox.profiles);
        message = ''
          Firefox extension configuration has changed.
          Please change from:
            ${moduleName}.profiles.<name>.extensions = [ ... ];
          to:
            ${moduleName}.profiles.<name>.extensions.packages = [ ... ];
        '';
      }
    ];
  };
}
