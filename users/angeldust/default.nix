{ pkgs, inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.default
    inputs.otter-launcher.homeModules.default
    inputs.hyprland.homeManagerModules.default

    # CLI
    ../../modules/home-manager/cli/atuin.nix
    ../../modules/home-manager/cli/cli.nix
    ../../modules/home-manager/cli/fastfetch.nix
    ../../modules/home-manager/cli/fish/fish.nix
    ../../modules/home-manager/cli/otter-launcher.nix
    ../../modules/home-manager/cli/yazi.nix

    # Desktop
    ../../modules/home-manager/desktop/ghostty.nix
    ../../modules/home-manager/desktop/hyprland.nix
    ../../modules/home-manager/desktop/theming.nix
    ../../modules/home-manager/desktop/zen.nix

    # Development
    ../../modules/home-manager/development/ai.nix
    ../../modules/home-manager/development/direnv.nix

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
