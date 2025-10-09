{ pkgs, inputs, ... }:
{
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
    ../../modules/home-manager/development/nvim.nix

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
      neovim
      xdg-user-dirs
      inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
      kitty
      obsidian

      stylua
      nixfmt
      prettier
      luajitPackages.lua-lsp

      imv

      smile
      # calcure
    ];

  };
}
