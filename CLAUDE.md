# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular NixOS configuration using [snowfall-lib](https://github.com/snowfallorg/lib) for automatic module discovery and organization. The configuration targets `x86_64-linux` systems with a focus on gaming, development, and Hyprland Wayland desktop.

**Key architectural decisions:**
- Uses Lix as Nix replacement
- Namespace: All modules use `angl` namespace
- Module discovery is automatic via snowfall-lib - no manual imports needed
- Secrets managed via sops-nix with age encryption

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

The repository uses git hooks via devenv (pre-commit). Hooks run automatically on commit:

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

The flake uses `meflove-lib` wrapper around snowfall-lib:
- **channels-config**: `allowUnfree = true` for all systems
- **snowfall.namespace**: `angl` (e.g., `angl.nixos.category.module.enable`)
- **supportedSystems**: `["x86_64-linux"]` only

### Module Organization

Modules are auto-discovered by snowfall-lib from these directories:

```
modules/nixos/     # System modules (available in nixosConfigurations)
modules/home/      # Home Manager modules (available in homeConfigurations)
```

**Module categories:**
- `modules/nixos/core/` - Essential system services (firewall, ssh, sops, autologin)
- `modules/nixos/boot/` - Kernel, secure boot (lanzaboote), bootloader
- `modules/nixos/hardware/` - Hardware support (nvidia, sound, bluetooth)
- `modules/nixos/desktop/` - GUI services (gaming, flatpak, obs)
- `modules/home/cli/` - CLI tools and shell config
- `modules/home/desktop/` - GUI apps (hyprland, ghostty, zen)
- `modules/home/development/` - Dev tools (nvim, git, ai tools)

### System and Home Configurations

```
systems/x86_64-linux/<hostname>/     # Per-host system configs
  ├─ default.nix          # System configuration (module imports)
  └─ <hostname>-disk.nix  # Disko partitioning scheme

homes/x86_64-linux/<user>@<hostname>/  # Per-user home configs
  └─ default.nix          # User environment configuration
```

### Custom Packages

Local package definitions in `packages/`:
- `hyprscope/` - Hyprland plugin
- `install/` - Installation helper scripts
- `iloader/`, `soundcloud-desktop/` - Other custom packages

### Overlays

Package overlays in `overlays/`:
- `master/` - Overlay for nixpkgs-master channel
- `unstable/` - Overlay for nixpkgs-unstable channel

## Important Patterns

### Secret Management with sops-nix

Secrets are defined using `lib.angl.flattenSecrets` helper:

```nix
sops = {
  secrets = lib.angl.flattenSecrets {
    github = {
      github_pat_devenv = {};
    };
    pass = {};
  };
};
```

This flattens nested attrs into sops-compatible format:
- `github/github_pat_devenv`
- `pass`

### Module Exports via snowfall-lib

Modules are automatically discovered. To export options, use the `namespace` attr:

```nix
{lib, namespace, ...}: {
  options.${namespace}.nixos.category.module.enable = lib.mkEnableOption "Description";
  config = lib.mkIf config.${namespace}.nixos.category.module.enable {
    # Module configuration
  };
}
```

The namespace is `angl` globally.

### Inputs Usage

External flake inputs are available everywhere as `inputs`. For modules or packages:

```nix
{inputs, ...}: {
  # Use inputs.hyprland.homeManagerModules.default
  # Use inputs.zen-browser.homeModules.default
}
```

## Testing Configuration

Before committing changes:

1. **Check syntax**: Run linters manually or let git hooks do it
2. **Dry-run build**: `nixos-rebuild build --flake .#<host>` or `home-manager build --flake .#<user>@<host>`
3. **Test secrets**: Ensure `sops` files are valid YAML and can be decrypted

## Adding New Modules

1. Create directory under `modules/nixos/<category>/` or `modules/home/<category>/`
2. Add `default.nix` with module configuration
3. Use namespace-based options: `angl.nixos.category.module-name.enable` (system) or `angl.home.category.module-name.enable` (home)
4. Enable in system/home config via snowfall-lib's auto-discovery

No manual imports needed - snowfall-lib handles discovery automatically.
