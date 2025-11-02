# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Environment

This is a NixOS configuration using flakes and snowfall-lib for modular configuration management. The development shell is managed by devenv.

### Setting up the development environment

```bash
# Enter development shell
nix develop

# Or use devenv directly
devenv shell
```

The development shell includes git-hooks for code quality:
- **nix formatting**: alejandra (nix formatter)
- **nix linting**: deadnix (detect dead code), statix (static analysis)
- **general**: shellcheck, end-of-file-fixer, trim-trailing-whitespace
- **secret management**: transcrypt hooks for encrypted secrets

### Common Commands

**Build and apply system configuration:**
```bash
# Build system configuration
sudo nixos-rebuild build --flake .#nixos-pc

# Apply system configuration (switch)
sudo nixos-rebuild switch --flake .#nixos-pc

# Build home configuration only
home-manager switch --flake .#angeldust@nixos-pc
```

**Development and formatting:**
```bash
# Format all nix files
nix fmt .

# Update flake inputs
nix flake update
```

**Secret management:**
```bash
# Initialize transcrypt (for encrypted secrets)
nix shell nixpkgs#transcrypt
transcrypt
```

## Architecture

This configuration uses **snowfall-lib** for a modular, hierarchical architecture:

### Directory Structure

- **`flake.nix`**: Main entry point with inputs and output definitions
- **`systems/x86_64-linux/nixos-pc/`**: Host-specific system configurations
  - `default.nix`: Host configuration with module imports and system settings
  - `nixos-pc-disk.nix`: Disko partitioning configuration
- **`homes/x86_64-linux/angeldust@nixos-pc/`**: User-specific Home Manager configurations
- **`modules/`**: Reusable configuration modules
  - `nixos/`: System-level modules (hardware, services, core system)
  - `home/`: User environment modules (desktop, cli, development)
- **`secrets/`**: Encrypted secrets managed with transcrypt
- **`overlays/`**: Custom package modifications
- **`devenv.nix`**: Development environment configuration

### Module Organization

**System modules (modules/nixos/):**
- `core/`: Essential system settings (firewall, ssh, vpn, security)
- `boot/`: Kernel, secure boot, and boot configuration
- `hardware/`: Hardware support (nvidia, sound, bluetooth, networking)
- `desktop/`: GUI services (gaming, flatpak, obs, torrent)
- `development/`: Development services (podman, virt-manager, ollama)

**Home modules (modules/home/):**
- `cli/`: Command-line tools and shell configuration
- `desktop/`: GUI applications and desktop environment (Hyprland, kitty, etc.)
- `development/`: Development tools and editors (nvim, git, ai tools)

### Key Architectural Patterns

1. **Snowfall-lib Integration**: Uses `lib.snowfall.fs.get-non-default-nix-files` for automatic module discovery
2. **Namespace**: All modules use the `angl` namespace (defined in flake.nix)
3. **Modular Options**: Each module provides configurable options (e.g., `angl.nixos.desktop.gaming.enable`)
4. **Secrets Management**: Encrypted secrets in `secrets/secrets.nix` passed via `specialArgs`

### Important Features

- **Lix instead of Nix**: Uses Lix as the Nix implementation (see `nix.package = pkgs.lix`)
- **Custom Kernel**: Uses CachyOS kernel with LTO optimizations for gaming performance
- **Secure Boot**: Lanzaboote integration for secure boot support
- **Gaming Focus**: Includes gaming optimizations and tools
- **Hyprland Desktop**: Wayland compositor with extensive configuration
- **Development Tools**: Includes AI development tools (Claude Code configured)

### Custom Packages and Overlays

The configuration includes several custom inputs and packages:
- `zen-browser`: Custom Zen browser build
- `ayugram-desktop`: Custom Telegram client
- `angeldust-nixCats`: Custom Neovim configuration
- Various gaming-specific packages from nix-gaming

### Git Workflow

The repository uses git hooks that run automatically:
- Formatting with alejandra
- Linting with deadnix and statix
- Secret validation with transcrypt

If hooks need to be bypassed (not recommended):
```bash
git commit --no-verify
```
