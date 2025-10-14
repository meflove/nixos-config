{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.default
    inputs.otter-launcher.homeModules.default
    inputs.hyprland.homeManagerModules.default
    inputs.nixcord.homeModules.nixcord
    inputs.nix-colors.homeManagerModules.default

    # CLI
    ../../modules/home-manager/cli/cli.nix
    ../../modules/home-manager/cli/fastfetch.nix
    ../../modules/home-manager/cli/fish/fish.nix
    ../../modules/home-manager/cli/otter-launcher
    ../../modules/home-manager/cli/yazi.nix
    ../../modules/home-manager/cli/zellij
    ../../modules/home-manager/cli/fsel

    # Desktop
    ../../modules/home-manager/desktop/ghostty.nix
    ../../modules/home-manager/desktop/hyprland
    ../../modules/home-manager/desktop/theming.nix
    ../../modules/home-manager/desktop/zen.nix
    ../../modules/home-manager/desktop/nixcord.nix
    ../../modules/home-manager/desktop/easyeffects
    ../../modules/home-manager/desktop/mpv.nix
    ../../modules/home-manager/desktop/xdg.nix
    # ../../modules/home-manager/desktop/obs.nix

    # Development
    ../../modules/home-manager/development/ai.nix
    ../../modules/home-manager/development/direnv.nix
    ../../modules/home-manager/development/git.nix
    # ../../modules/home-manager/development/zed.nix
    ../../modules/home-manager/development/nvim

    # Gaming
    ../../modules/home-manager/gaming/gaming.nix

    # Misc
    ../../modules/home-manager/misc/programs.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Общие настройки Home Manager
  home = {
    stateVersion = "25.05";

    # Устанавливаем программы, у которых нет специальных модулей
    # или чьи модули мы не используем для конфигурации
    packages = with pkgs; [
      #---------------------------------------------------------------------
      # GUI Applications
      #---------------------------------------------------------------------
      # Terminals & Editors
      neovim
      kitty

      # Communication
      inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop

      # Productivity & Notes
      obsidian
      libreoffice
      papers # PDF viewer
      calcure # Modern TUI calendar and task manager

      # Media & Images
      imv # Image viewer for Wayland
      gimp

      # Database
      dbeaver-bin

      #---------------------------------------------------------------------
      # Development
      #---------------------------------------------------------------------
      # Languages & Runtimes
      go
      nodejs_24
      zig

      # Linters & Formatters
      stylua
      prettier

      # Language Servers
      luajitPackages.lua-lsp
      nil # Nix Language Server

      #---------------------------------------------------------------------
      # CLI Tools
      #---------------------------------------------------------------------
      # Core Utilities
      xdg-user-dirs

      # Replacements for standard commands
      bat # `cat` alternative
      fd # `find` alternative
      ripgrep # `grep` alternative
      sd # `sed` alternative

      # System & Info
      btop # `top` alternative

      # Productivity & Helpers
      fzf # Fuzzy finder
      ggh # SSH connection manager
      jq # JSON processor
      tlrc # Simplified man pages
      chafa # Image to terminal converter

      #---------------------------------------------------------------------
      # Fun & Games
      #---------------------------------------------------------------------
      smile
      krabby
    ];
  };
}
