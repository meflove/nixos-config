{
  pkgs,
  inputs,
  ...
}: {
  angl.home = {
    cli = {
      yazi.enable = true;
    };

    desktop = {
      gaming.enable = true;
      kitty.enable = true;
      nixcord.enable = false;
    };

    development = {
      gemini.enable = true;
      claude.enable = true;
    };
  };

  home = {
    packages = with pkgs; [
      #---------------------------------------------------------------------
      # GUI Applications
      #---------------------------------------------------------------------
      # Communication
      inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.ayugram-desktop

      # Productivity & Notes
      unstable.obsidian
      unstable.libreoffice
      papers # PDF viewer
      calcure # Modern TUI calendar and task manager

      # Media & Images
      imv # Image viewer for Wayland
      gimp
      vlc

      # Database
      dbeaver-bin

      #---------------------------------------------------------------------
      # Development
      #---------------------------------------------------------------------
      # Languages & Runtimes
      go
      zig

      #---------------------------------------------------------------------
      # CLI Tools
      #---------------------------------------------------------------------
      # Core Utilities
      xdg-user-dirs

      # Replacements for standard commands
      bat # `cat` alternative
      fd # `find` alternative
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
