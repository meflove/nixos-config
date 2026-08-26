{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      services.libinput = {
        enable = true;
      };

      systemd.tmpfiles.settings = {
        "10-libinput-overrides" = {
          "/etc/libinput/local-overrides.quirks" = {
            "f" = let
              mouseName = "Logitech PRO X";
            in {
              argument = "[${mouseName}]\nMatchName=${mouseName}\nModelBouncingKeys=1";
            };
          };
        };
      };
    };
  };
}
