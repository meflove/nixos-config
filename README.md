# ❄️ My NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&logo=NixOS)](https://nixos.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

My declarative NixOS configuration, managed with [Nix Flakes](https://nixos.wiki/wiki/Flakes).

---

## 🚀 Highlights

This configuration is built around a minimalist yet functional environment for development and daily use.

| Component          | Implementation                                                     |
| ------------------ | ------------------------------------------------------------------ |
| **System**         | [NixOS Unstable](https://nixos.org/channels/nixos-unstable)        |
| **Window Manager** | [Hyprland](https://hyprland.org/) (with `hyprlock`, `hypridle`)    |
| **Bar**            | [Hyprpanel](https://github.com/hyprland-community/hyprpanel)       |
| **Terminal**       | [Ghostty](https://github.com/ghostty-org/ghostty)                  |
| **Shell**          | [Fish Shell](https://fishshell.com/) with plugins                  |
| **Security**       | [Secure Boot](https://nixos.wiki/wiki/Secure_Boot) support enabled |
| **Gaming**         | Gaming optimizations, including `gamemode`                         |

## 📂 Repository Structure

The configuration is organized as follows for easy management and scalability:

- `flake.nix`: The main entry point that defines dependencies and builds the entire configuration.
- `systems/`: Configurations for specific machines (hosts).
  - `x86_64-linux/nixos-pc`: My main PC.
- `modules/`: Shared modules that are reused across hosts.
  - `nixos/`: System-level NixOS modules (kernel, drivers, services).
  - `home/`: Modules for managing the user environment (dotfiles, programs).
- `homes/`: User definitions and import of their Home Manager configurations.
- `scripts/`: Utility scripts for setup and maintenance.
- `shells/`: Shell configuration.
- `pics/`: Images and wallpapers used in the configuration.
- `packages/`: Custom Nix packages. # TODO fix this packages
- `overlays/`: Custom packages and fixes for existing ones.
- `secrets/`: Encrypted secrets, managed with [transcrypt](https://github.com/elasticdog/transcrypt) (or a similar tool).

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
- Change variables in `secrets/` with sample files provided.

**3. Build the configuration:**

```bash
# First build for a host named 'nixos-pc'
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#pcDisk # or your disko config name in flake.nix

nix-shell -p transcrypt
transcrypt

sudo nixos-install --flake .#nixos-pc

# After rebooting to system

git clone https://github.com/meflove/nixos-config.git # to your location
cd nixos-config

nix-shell -p transcrypt pre-commit
transcrypt -c aes-256-cbc -p '<your password>'
pre-commit install

home-manager switch --flake .#angeldust # or your username from users
```

For subsequent updates, simply run the same command.

## 🙏 Inspiration and Credits

This configuration was inspired by the work of many members of the NixOS community. Special thanks to:

- [Misterio77/nix-config](https://github.com/Misterio77/nix-config)
- [NotAShelf/nyx](https://github.com/NotAShelf/nyx)
- The entire NixOS community for their incredible work and documentation.

## 📜 License

This project is licensed under the [MIT License](LICENSE).
