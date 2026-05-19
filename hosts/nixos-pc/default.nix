{
  flake = {
    extendedLib,
    config,
    ...
  }: {
    nixosConfigurations = extendedLib.buildConfiguration (baseNameOf ./.) rec {
      hostName = "nixos-pc";
      userName = "angeldust";
      hostPlatform = "x86_64-linux";
      stateVersion = "26.05";
      hostId = "78172da6";
      flakeDir = "/home/${userName}/.config/nixos-config";

      extraModules = extendedLib.nxosLib.attrValues {
        inherit
          (config.nixosModules)
          # Boot modules
          kernel-optimizations
          secureboot
          # Hardware modules
          bluetooth
          btrfs
          zfs
          iphone
          nvidia
          sound
          # Networking modules
          firewall
          network-core
          vpn
          zapret
          network-tools
          # Cli modules
          atuin
          cli-basic-stuff
          nix-cli
          fastfetch
          fish
          nushell
          otter-launcher
          yazi
          zellij
          gopass
          # Core modules
          easyeffects
          security
          ssh-gpg
          system-optimizations
          oom-killer
          time-locale
          users
          nix-config
          debloat
          # Desktop modules
          flatpak
          gaming
          ghostty
          kitty
          media-tools
          theming
          torrent
          xdg
          zen-browser
          music
          productivity
          communication
          nixcord
          pipewire-soundpad
          ## Wm modules
          hyprlock
          niri
          waybar
          dunst
          # Development modules
          direnv
          editor
          git
          jujutsu
          podman
          virt-manager
          database
          ## AI modules
          claude
          mcp
          ;
      };
    };

    diskoConfigurations.${baseNameOf ./.} = import ./disko.nix {
      devices = {
        main-disk = "/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_S649NL0W301613B";
        zfs-disk = "/dev/disk/by-id/nvme-INTEL_SSDPEKKW128G8_BTHH82310Z37128A";
      };
    };
  };
}
