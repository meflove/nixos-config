{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      hm = {
        programs.waybar = {
          enable = true;
          systemd.enable = true;

          style = import ./style.nix {
            inherit config;
          };

          settings = import ./settings.nix {
            inherit pkgs lib config;
          };
        };

        # Add required packages for waybar modules
        home.packages = with pkgs; [
          playerctl # For MPRIS module
          waybar-mpris
        ];

        # Wayland window manager settings
        wayland.windowManager.hyprland = lib.mkIf config.programs.hyprland.enable {
          settings = {
            layerrule = [
              "match:title waybar, blur 0"
            ];
          };
        };
      };
    };
  };
}
