{ pkgs, inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.default
    inputs.otter-launcher.homeModules.default
    inputs.hyprland.homeManagerModules.default
    ../../modules/home-manager/fish/fish.nix
    ../../modules/home-manager/ghostty.nix
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/programs.nix
    ../../modules/home-manager/atuin.nix
    ../../modules/home-manager/zen.nix
    ../../modules/home-manager/theming.nix
    ../../modules/home-manager/cli.nix
    ../../modules/home-manager/gaming.nix
    ../../modules/home-manager/fastfetch.nix
    ../../modules/home-manager/otter-launcher.nix
    ../../modules/home-manager/ai.nix
    ../../modules/home-manager/direnv.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Общие настройки Home Manager
  home = {
    username = "angeldust";
    # homeDirectory = "/home/angeldust";
    stateVersion = "25.05";

    # Устанавливаем программы, у которых нет специальных модулей
    # или чьи модули мы не используем для конфигурации
    packages = with pkgs; [
      neovim
      zellij
      easyeffects
      xdg-user-dirs
      ayugram-desktop
      kitty
      obsidian

      stylua
      nixfmt
      prettier
      luajitPackages.lua-lsp
    ];

  };
}
