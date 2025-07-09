{
  description = "Моя модульная конфигурация NixOS";

  inputs = {
    # Основной источник пакетов NixOS. Используем нестабильную ветку для доступа к свежим пакетам и функциям.
    # Если требуется большая стабильность, можно использовать "nixos-23.11" или "nixos-24.05".
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager для управления пользовательской конфигурацией.
    # Важно, чтобы home-manager использовал тот же nixpkgs, что и основной flake,
    # чтобы избежать проблем с несовместимостью пакетов.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko для декларативного управления разметкой дисков и файловыми системами.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland - Wayland композитор. Интегрируем его как отдельный input.
    hyprland.url = "github:hyprwm/Hyprland";
    # Убедимся, что Hyprland также следует за нашим nixpkgs
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # Модуль Home Manager для терминала Ghostty.
    # ghostty = {
    #   url = "github:clo4/ghostty-hm-module";
    #   inputs.nixpkgs.follows = "nixpkgs"; # Ghostty HM модуль также должен следовать nixpkgs
    # };

    # Lanzaboote для Secure Boot и UKI.
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Дополнительные инпуты могут быть добавлены по мере необходимости,
    # например, для sops-nix (управление секретами), impermanence (персистентность).
  };

  outputs = { self, nixpkgs, home-manager, disko, hyprland, lanzaboote, ... }@inputs: {
    # Здесь будут определены nixosConfigurations (системные конфигурации)
    # и homeConfigurations (пользовательские конфигурации Home Manager).
    modules = {
      nixos = {
        hyprland = import ./modules/nixos/hyprland.nix;
        nvidia = import ./modules/nixos/nvidia.nix;
        bluetooth = import ./modules/nixos/bluetooth.nix;
        wifi = import ./modules/nixos/wifi.nix;
        disko = import ./modules/nixos/disko.nix;
        secureboot = import ./modules/nixos/secureboot.nix;
      };
      home-manager = {
        fish = import ./modules/home-manager/fish.nix;
        ghostty = import ./modules/home-manager/ghostty.nix;
      };
    };

    diskoConfigurations = {
      # Конфигурация диска для ВМ.
      vmDisk = (nixpkgs.lib.evalModules {
        specialArgs = { inherit inputs; };
        modules = [
          self.modules.nixos.disko
          { myConfig.disk.targetDevice = "/dev/vda"; }
        ];
      }).config;

      # Конфигурация диска для физического ПК
      pcDisk = (nixpkgs.lib.evalModules {
        specialArgs = { inherit inputs; };
        modules = [
          self.modules.nixos.disko
          { myConfig.disk.targetDevice = "/dev/nvme0n1"; }
        ];
      }).config;
    };

    nixosConfigurations = {
      # Конфигурация для физического ПК
      nixos-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-pc/default.nix
          ./hosts/pc/hardware-configuration.nix
          # Импорт общих системных модулей
          self.modules.nixos.hyprland # Теперь это будет работать
          self.modules.nixos.nvidia
          self.modules.nixos.bluetooth
          self.modules.nixos.wifi
          self.modules.nixos.disko
          self.modules.nixos.secureboot
        ];
      };

      # Конфигурация для виртуальной машины
      vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { services.spice-vdagentd.enable = true; } # Для копирования/вставки в Virt-manager [9]
          self.modules.nixos.hyprland # Теперь это будет работать
          self.modules.nixos.disko
        ];
      };
    };

    homeConfigurations = {
      # Пользовательская конфигурация для ПК
      "angeldust@pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./users/common/default.nix
          # ./users/angeldust/default.nix # Если есть специфичные для пользователя настройки
        ];
      };

      # Пользовательская конфигурация для ВМ
      "angeldust@vm" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./users/common/default.nix
          # ./users/angeldust/default.nix # Если есть специфичные для пользователя настройки
        ];
      };
    };
  };
}
