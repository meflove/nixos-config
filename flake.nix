# DO-NOT-EDIT. This file was auto-generated using github:denful/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "My NixOS configuration managed with flake-parts";

  outputs = args: import ./lib args;

  inputs = {
    angeldust-nix-packages = {
      url = "git+https://tangled.org/did:plc:jv6arfakxixeyppnbxhf6blz";
      inputs = {
        bun2nix.inputs = {
          flake-parts.follows = "flake-parts";
          treefmt-nix.follows = "treefmt-nix";
        };
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
        pkgs-by-name.follows = "pkgs-by-name-for-flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    angeldust-nvimWrap = {
      url = "git+https://tangled.org/did:plc:tnajjjjypb4b57xv7tjpv3is";
      inputs = {
        neovim-nightly-overlay.inputs.flake-parts.follows = "flake-parts";
        nu-lint.inputs.git-hooks = {
          follows = "git-hooks";
          inputs.flake-compat.follows = "flake-compat";
        };
        pedantix.inputs = {
          flake-parts.follows = "flake-parts";
          git-hooks-nix.inputs = {
            flake-compat.follows = "flake-compat";
            nixpkgs.follows = "nixpkgs";
          };
        };
        rustowl.inputs = {
          flake-parts.follows = "flake-parts";
          git-hooks = {
            follows = "git-hooks";
            inputs.flake-compat.follows = "flake-compat";
          };
        };
        statix.inputs = {
          flake-parts.follows = "flake-parts";
          git-hooks.follows = "git-hooks";
          import-tree.follows = "import-tree";
        };
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    atuin = {
      url = "github:atuinsh/atuin";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    ayugram-desktop = {
      url = "github:ndfined-crp/ayugram-desktop";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    claude-agents = {
      url = "github:contains-studio/agents";
      flake = false;
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        ghostty.follows = "ghostty";
        git-hooks.follows = "git-hooks";
        nixd.inputs.treefmt-nix.follows = "treefmt-nix";
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    files = {
      url = "github:sini/files";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:NixOS/flake-compat";
    };
    flake-file = {
      url = "github:denful/flake-file";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fsel = {
      url = "github:Mjoyufull/fsel";
      inputs = {
        naersk.inputs.nixpkgs.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs";
      };
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs = {
        flake-compat.follows = "flake-compat";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };
    git-hooks-nix = {
      follows = "git-hooks";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
      };
    };
    iloader = {
      url = "github:nab138/iloader";
      inputs = {
        bun2nix.inputs.flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    import-tree = {
      url = "github:denful/import-tree";
    };
    iris = {
      url = "github:versenilvis/iris";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    jonhermansen-nur-packages = {
      url = "github:jonhermansen/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jujutsu = {
      url = "github:jj-vcs/jj";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.inputs.flake-compat.follows = "flake-compat";
        rust-overlay.follows = "rust-overlay";
      };
    };
    linuwowo = {
      url = "github:loystonpais/linuwowo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs = {
        lix.follows = "lix";
        nixpkgs.follows = "nixpkgs";
      };
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    mk-shell-bin = {
      url = "github:rrbutani/nix-mk-shell-bin";
    };
    ncro = {
      url = "github:feel-co/ncro";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-cursors = {
      url = "github:LilleAila/nix-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-index = {
      url = "github:nix-community/nix-index";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "github:unnamed-systems/nix-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-update = {
      url = "github:Mic92/nix-update";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-nixcord.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-master = {
      url = "github:NixOS/nixpkgs";
    };
    nnf = {
      url = "github:thelegy/nixos-nftables-firewall";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    otter-launcher = {
      url = "github:kuokuo123/otter-launcher";
      inputs = {
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    pedantix = {
      url = "github:swarsel/pedantix";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks-nix.follows = "git-hooks";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    pkgs-by-name = {
      follows = "pkgs-by-name-for-flake-parts";
    };
    pkgs-by-name-for-flake-parts = {
      url = "github:drupol/pkgs-by-name-for-flake-parts";
    };
    proxy-suite-flake = {
      url = "github:fufsob/proxy-suite-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        zapret.follows = "zapret-discord-youtube";
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    statix = {
      url = "github:molybdenumsoftware/statix";
      inputs = {
        files.follows = "files";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        import-tree.follows = "import-tree";
        nixpkgs.follows = "nixpkgs";
      };
    };
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        nur.follows = "nur";
      };
    };
    system24-theme = {
      url = "github:refact0r/system24";
      flake = false;
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    zapret-discord-youtube = {
      url = "github:kartavkun/zapret-discord-youtube";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zellij = {
      url = "github:a-kenji/zellij-nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
