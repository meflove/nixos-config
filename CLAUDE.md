# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular NixOS configuration using [flake-parts](https://flake.parts) for modular architecture with automatic module discovery via [import-tree](https://github.com/vic/import-tree). The configuration targets `x86_64-linux` systems with a focus on gaming, development, and Niri/Hyprland Wayland desktop.

**Key architectural decisions:**
- Uses Lix as Nix replacement
- Module discovery via import-tree - no manual imports needed
- Unified modules (can configure both system and home-manager in one module)
- Secrets managed via sops-nix with age encryption
- Custom library functions in `lib/` for common patterns

## Common Commands

### Building and Applying Configuration

```bash
# Apply system configuration for nixos-pc host
sudo nixos-rebuild switch --flake .#nixos-pc

# Apply home-manager configuration for angeldust@nixos-pc
home-manager switch --flake .#angeldust@nixos-pc

# Build without applying (dry-run)
sudo nixos-rebuild build --flake .#nixos-pc
home-manager build --flake .#angeldust@nixos-pc

# Using nh wrapper (faster rebuilds)
nh os switch . (nrs alias)
nh home switch . (hms alias)
```

### Linting and Formatting

The repository uses git hooks via devenv (pre-commit). Hooks run automatically on commit.

### Secret Management

```bash
# Edit a secret file (automatically encrypts on save)
sops secrets/secrets.yaml

# Edit SSH secrets
sops secrets/ssh/angeldust.yaml
sops secrets/ssh/nixos-pc.yaml

# Update sops keys if needed (custom script)
sops-update-keys
```

### Development Environment

```bash
# Enter development shell (includes glow, sops)
devenv shell

# Or use direnv (automatically loads on cd)
direnv allow
```

## Architecture

### Flake Structure

The flake uses flake-parts with custom library extensions:
- **lib/generator.nix**: Builds system configurations with `buildConfiguration` function
- **lib/functions.nix**: Custom utility functions (`flattenSecrets`, `flattenAttrsDot`, etc.)
- **import-tree**: Auto-discovers all `default.nix` files in `modules/` and `hosts/`
- **Global config**: `allowUnfree = true`, `cudaSupport = true` for all systems

### Module Organization

Modules are auto-discovered by import-tree from `modules/`:

```
modules/
├── boot/              # Kernel, secure boot (lanzaboote)
├── core/              # Essential services (nix-config, security, ssh-gpg, users)
├── hardware/          # Hardware support (nvidia, sound, bluetooth, btrfs)
├── networking/        # Networking (firewall, vpn, zapret, network-core)
├── cli/               # CLI tools and shell config (fish, nushell, yazi, etc.)
├── desktop/           # GUI apps and services (gaming, flatpak, theming, etc.)
│   └── wm/            # Window managers (niri, hyprland, waybar, hyprlock)
├── development/       # Dev tools (editor, git, podman, database)
│   └── ai/            # AI tools (claude, mcp, ollama, gemini)
└── flake/             # Flake-specific configuration
```

**Module pattern:**
- Each module exports `flake.nixosModules.${baseNameOf ./.}`
- Can configure both NixOS and home-manager in one module via `hm` attr
- No namespace prefix - modules use directory name (e.g., `nix-config`, `fish`)
- Special args available: `lib.userName`, `lib.hostName`, `lib.hostPlatform`, etc.

### System Configurations

Hosts in `hosts/` use `extendedLib.buildConfiguration`:

```nix
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

      extraModules = with config.nixosModules; [
        # List of modules to enable
        nix-config
        fish
        niri
        # ...
      ];
    };

    diskoConfigurations.${baseNameOf ./.} = import ./disko.nix {
      devices.main-disk = "/dev/disk/by-id/...";
    };
  };
}
```

### Custom Packages

Local package definitions in `pkgs/`:
- `clipse.nix` - Clipboard manager
- `iloader.nix` - Image loader
- `soundcloud-desktop.nix` - Soundcloud desktop client
- `yot.nix` - YouTube viewer

## Important Patterns

### Secret Management with sops-nix

Secrets are defined using `lib.flattenSecrets` helper:

```nix
sops = {
  secrets = lib.flattenSecrets {
    github = {
      github_auth_token = {
        mode = "0444";
      };
    };
    pass = {};
  };
};
```

This flattens nested attrs into sops-compatible format:
- `github/github_auth_token`
- `pass`

**Available in lib:**
- `lib.flattenSecrets` - Flatten with "/" separator (for sops)
- `lib.flattenAttrsDot` - Flatten with "." separator (for browser settings)
- `lib.flattenAttrsWithSep` - Universal flatten with custom separator

### Module Structure

Modules export `flake.nixosModules.${baseNameOf ./.}`:

```nix
{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      inputs,
      pkgs,
      ...
    }: {
      # NixOS configuration
      programs.fish.enable = true;

      # Home Manager configuration (via `hm`)
      hm = {
        programs.fish = {
          shellAliases = {
            ll = "eza -l";
          };
        };
      };
    };
  };
}
```

### Special Arguments Available in Modules

Extended lib provides these from `buildConfiguration`:
- `lib.configurationName` - Name of the configuration
- `lib.hostName` - System hostname
- `lib.userName` - Username
- `lib.hostPlatform` - Platform (e.g., "x86_64-linux")
- `lib.secretsFile` - SOPS secrets file reference
- `lib.flakeDir` - Path to flake directory
- `lib.stylix` - Stylix theme configuration
- `lib.hostId` - Network host ID

### Inputs Usage

External flake inputs are available everywhere as `inputs`:

```nix
{inputs, ...}: {
  # Use inputs.hyprland.packages
  # Use inputs.zen-browser.homeModules.default
}
```

## Testing Configuration

Before committing changes:

1. **Check syntax**: Run linters manually or let git hooks do it
2. **Dry-run build**: `nixos-rebuild build --flake .#<host>` or `home-manager build --flake .#<user>@<host>`
3. **Test secrets**: Ensure `sops` files are valid YAML and can be decrypted

## Adding New Modules

1. Create directory under `modules/<category>/`
2. Add `default.nix` with module configuration
3. Export as `flake.nixosModules.${baseNameOf ./.}`
4. Add to host's `extraModules` list
5. import-tree will auto-discover - no manual imports needed

## Gaming & Performance Stack

This configuration includes extensive gaming optimizations:
- **CachyOS Kernel** with LTO and tuned for gaming
- **SCX lavd scheduler** for low-latency
- **ZRAM compression** (100% RAM) with 2 devices
- **NVIDIA beta drivers** with open kernel modules
- **Full Vulkan stack** with validation layers
- **Wine/Proton** via nix-gaming overlays
- **TCP BBR** congestion control

See `modules/boot/kernel-optimizations/` and `modules/hardware/nvidia/` for details.
