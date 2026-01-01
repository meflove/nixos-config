<h1 align="center"> My Nixos Configuration <img src="https://github.com/user-attachments/assets/5f064ed3-b558-426d-afef-d33940636c9d" width="32" alt="nixos"> </h1>

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&logo=NixOS)](https://nixos.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

My declarative NixOS configuration, managed with [Nix Flakes](https://nixos.wiki/wiki/Flakes).

---

## 🚀 Highlights

This configuration is built around a minimalist yet functional environment for development and daily use.

| Component          | Implementation                                                     |
| ------------------ | ------------------------------------------------------------------ |
| **System**         | [NixOS Unstable](https://nixos.org/channels/nixos-unstable)        |
| **Implementation** | [Lix](https://lix.systems/) (modern Nix replacement)              |
| **Architecture**   | [Snowfall Lib](https://github.com/snowfallorg/lib) for modularity   |
| **Window Manager** | [Hyprland](https://hyprland.org/) (Wayland with gaming optimizations) |
| **Bar**            | [Hyprpanel](https://github.com/hyprland-community/hyprpanel)       |
| **Terminal**       | [Ghostty](https://github.com/ghostty-org/ghostty)                  |
| **Shell**          | [Fish Shell](https://fishshell.com/) with plugins and starship      |
| **Code Editor**    | [Neovim](https://neovim.io/) with [angeldust-nixCats](https://github.com/meflove/angeldust-nixCats) configuration |
| **Security**       | [Secure Boot](https://github.com/nix-community/lanzaboote) + sops-nix     |
| **Gaming**         | Comprehensive gaming stack with optimizations                       |

### 🎮 Gaming & Performance Stack

**Kernel & Scheduler:**
- **CachyOS Kernel** with LTO optimizations for gaming performance
- **SCX lavd** scheduler with low-latency configuration
- **Aggressive CPU tuning** with performance governor

**Memory & Storage:**
- **ZRAM compression** (100% RAM) with 2 devices for load balancing
- **Optimized I/O schedulers**: BFQ for HDD/SSD, none for NVMe
- **Aggressive page cache** tuning for gaming workloads

**Graphics & Compatibility:**
- **NVIDIA beta drivers** with open kernel modules
- **Full Vulkan stack** with validation layers
- **Wine/Proton integration** via nix-gaming overlays
- **DirectX translation** through VKD3D-Proton and DXVK

**Network:**
- **TCP BBR** congestion control for better network connection

### 💻 Development Environment

**Neovim Configuration ([angeldust-nixCats](https://github.com/meflove/angeldust-nixCats)):**
A comprehensive Neovim setup using [nixCats](https://github.com/BirdeeHub/nixCats-nvim) for reproducible, declarative Neovim environments with:

- **Modern Features**: Catppuccin theme, Blink.cmp completion, Copilot integration
- **Multi-language Support**: LSP for Python, Lua, Nix, Bash with intelligent completion
- **Reproducible Configuration**: Nix-managed environment for consistent setup across systems
- **Rich Plugin Ecosystem**: Development tools, Git integration, file navigation, and syntax highlighting
- **Customizable**: Declarative configuration with modular design

## 📂 Repository Structure

The configuration uses **snowfall-lib** for modular architecture with automatic module discovery:

```
nixos-config/
├── flake.nix                     # Main entry point with snowfall-lib integration
├── devenv.nix                    # Development environment with git hooks
├── systems/                      # Host-specific configurations
│   └── x86_64-linux/
│       └── nixos-pc/
│           ├── default.nix       # System configuration with module imports
│           └── nixos-pc-disk.nix # Disko partitioning scheme
├── homes/                        # User-specific Home Manager configs
│   └── x86_64-linux/
│       └── angeldust@nixos-pc/
│           └── default.nix       # User environment configuration
├── modules/                      # Reusable modules (auto-discovered)
│   ├── nixos/                    # System-level modules
│   │   ├── core/                 # Essential system services (firewall, ssh, autologin)
│   │   ├── boot/                 # Kernel, secure boot, bootloader
│   │   ├── hardware/             # Hardware support (nvidia, sound, bluetooth)
│   │   └── desktop/              # GUI services (gaming, flatpak, obs)
│   └── home/                     # User environment modules
│       ├── cli/                  # Command-line tools and shell config
│       ├── desktop/              # GUI applications (hyprland, ghostty, zen)
│       └── development/          # Dev tools (angeldust-nixCats nvim, git, ai tools)
├── secrets/                      # Encrypted secrets (sops-nix managed)
└── overlays/                     # Custom package modifications
```

### 🏗️ Architecture Features

- **Namespace**: All modules use `angl` namespace for consistency
- **Modular Options**: Each module provides `angl.nixos.category.module.enable` options
- **Secret Management**: Encrypted secrets with sops-nix integration
- **Development Shell**: Pre-configured environment with quality tools

## 🛠️ Installation and Usage

> **Warning:** This configuration is tailored for my personal use. Feel free to use it as a reference, but you will need to make adjustments.

**1. Clone the repository:**

```bash
git clone https://github.com/meflove/nixos-config.git
cd nixos-config
```

**2. Adapt it to your system:**

- Change the hostname in `flake.nix` and under the `hosts/` directory.
- Change the username in the `users/` directory.
- Review and adapt the hardware configuration, especially in `hosts/nixos-pc/nixos-pc-disk.nix` and `modules/nixos/hardware`.
- Configure sops-nix.

**3. Build the configuration:**

```bash
# First build for a host named 'nixos-pc'
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./systems/x86_64-linux/nixos-pc/nixos-pc-disk.nix # or your disko config name

sudo nixos-install --flake .#nixos-pc

# After rebooting to system

git clone https://github.com/meflove/nixos-config.git # to your location
cd nixos-config

home-manager switch --flake .#angeldust@nixos-pc # or your username from homes
```

For subsequent updates, simply run the same command.

## 🙏 Inspiration and Credits

This configuration was inspired by the work of many members of the NixOS community. Special thanks to:

- [Misterio77/nix-config](https://github.com/Misterio77/nix-config)
- [NotAShelf/nyx](https://github.com/NotAShelf/nyx)
- The entire NixOS community for their incredible work and documentation.

## 📜 License

This project is licensed under the [MIT License](LICENSE).
