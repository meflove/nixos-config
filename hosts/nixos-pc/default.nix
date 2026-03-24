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
      flakeDir = "/home/${userName}/.config/nixox-config";

      stylix = {
        theme = "paradise";
        image = ../../pics/lock_screen.png;
      };

      extraModules = with config.nixosModules; [
        # Boot modules
        kernel-optimizations
        secureboot

        # Hardware modules
        bluetooth
        btrfs-maintenance
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
        fastfetch
        fish
        nushell
        otter-launcher
        yazi
        zellij

        # Core modules
        easyeffects
        security
        ssh-gpg
        system-optimizations
        time-locale
        users
        nix-config

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
        ## Wm modules
        hyprlock
        niri
        waybar

        # Development modules
        direnv
        editor
        git
        podman
        virt-manager
        database
        ## AI modules
        claude
        mcp
      ];
    };

    diskoConfigurations.${baseNameOf ./.} = import ./disko.nix {
      devices = {
        main-disk = "/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_S649NL0W301613B";
        zfs-disk = "/dev/disk/by-id/nvme-INTEL_SSDPEKKW128G8_BTHH82310Z37128A";
      };
    };
  };
}
