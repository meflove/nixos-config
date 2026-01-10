{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [./ssh-secrets.nix];

  sops = {
    secrets = lib.angl.flattenSecrets {
      github = {
        github_pat_devenv = {};
        github_auth_token = {};
      };
      pass = {};
    };

    templates = {
      "nix-access-tokens.nix".content = ''
        access-tokens = "github.com=${config.sops.placeholder."github/github_auth_token"}";
      '';
    };
  };

  nix = {
    inherit (inputs.self.nixosConfigurations.nixos-pc.config.nix) package;

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    settings = {
      use-xdg-base-directories = true;

      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
      ];

      auto-allocate-uids = true;
      use-cgroups = true;

      auto-optimise-store = true;

      # With Lix, i cant use this option
      # download-buffer-size = 2097152000;
    };

    extraOptions = ''
      !include ${config.sops.templates."nix-access-tokens.nix".path}
    '';
  };

  home.angl = {
    cli = {
      yazi.enable = true;
    };

    desktop = {
      hyprland = {
        enable = true;
        hyprlock.enable = false;
        autologin.enable = true;
      };

      ghostty.enable = true;

      niri.enable = false;

      gaming = {
        enable = true;
        hyprscope.enable = true;

        # wine.package = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-tkg;
        wine = {
          enable = true;
          package = pkgs.wineWowPackages.stagingFull;
        };

        lutris.enable = false;
        minecraft.enable = true;
        osu.enable = false;
      };
      kitty.enable = true;
      nixcord.enable = true;
    };

    development = {
      gemini.enable = true;
      claude.enable = true;
    };
  };

  home = {
    preferXdgDirectories = true;

    packages = with pkgs; [
      #---------------------------------------------------------------------
      # GUI Applications
      #---------------------------------------------------------------------
      # Communication
      inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.ayugram-desktop
      session-desktop

      # Productivity & Notes
      obsidian
      libreoffice
      papers # PDF viewer
      calcure # Modern TUI calendar and task manager

      # Media & Images
      imv # Image viewer for Wayland
      gimp
      vlc
      jmtpfs

      # Database
      dbeaver-bin

      # Music
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.soundcloud-desktop

      #---------------------------------------------------------------------
      # Development
      #---------------------------------------------------------------------
      # Languages & Runtimes

      #---------------------------------------------------------------------
      # CLI Tools
      #---------------------------------------------------------------------
      # Core Utilities
      xdg-user-dirs

      # Replacements for standard commands
      ripgrep # `grep` alternative
      ripgrep-all
      sd # `sed` alternative

      # System & Info
      btop # `top` alternative

      # Productivity & Helpers
      fzf # Fuzzy finder
      ggh # SSH connection manager
      tlrc # Simplified man pages
      chafa # Image to terminal converter
      tui-journal
    ];

    stateVersion = "25.05";
  };
}
