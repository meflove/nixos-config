{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  rules = import ./rules.nix;
  env = import ./env.nix;
  execs = import ./execs.nix;
  binds = import ./binds.nix;
  envConfig = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: value: "env = ${name},${value}") env
  );
  execOnceConfig = lib.concatStringsSep "\n" (map (command: "exec-once = ${command}") execs);
in
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpanel.nix
  ];

  home = {
    packages = with pkgs; [
      grim
      grimblast
      slurp
      hyprpicker
      libnotify
      tesseract
    ];

    pointerCursor = {
      gtk.enable = true;
      hyprcursor.enable = true;
      x11 = {
        enable = true;
        defaultCursor = "Bibata-Modern-Classic";
      };

      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.catppuccin-gtk;
      name = "catppuccin-frappe-blue-standard";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    systemd.enable = true;

    settings = (import ./settings.nix { inherit pkgs; }) // {
      bind = binds;
      bindm = [
        "Super, mouse:272, movewindow"
        "Super, mouse:273, resizewindow"
      ];

      windowrule = rules.windowRules;
      layerrule = rules.layerRules;
    };

    extraConfig = ''
      ${envConfig}
      ${execOnceConfig}
    '';
  };

  xdg = {
    enable = true;
    autostart.enable = true;
    mime.enable = true;

    userDirs = {
      enable = true;

      createDirectories = true;
    };

    terminal-exec = {
      enable = true;
      package = config.programs.ghostty.package;
      settings.default = [
        "com.mitchellh.ghostty.desktop"
      ];
    };

    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      xdgOpenUsePortal = true;
    };

    # mimeApps = {
    #   enable = true;
    #
    #   associations.added = {
    #     "inode/directory" = [ "yazi.desktop" ];
    #   };
    #   defaultApplications = {
    #     "inode/directory" = [ "yazi.desktop" ];
    #   };
    # };
  };
}
