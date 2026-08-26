# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

A modular NixOS configuration built on [flake-parts](https://flake.parts) with automatic module discovery via [import-tree](https://github.com/vic/import-tree). Targets `x86_64-linux`, focused on gaming, development, and a Niri/Hyprland Wayland desktop.

**Key architectural decisions:**

- **Lix** as the Nix implementation (via `lix` + `lix-module` inputs).
- **flake-parts** as the flake framework; per-system output lives in `persystem/`.
- **import-tree** auto-discovers every `default.nix` under `modules/` and `hosts/` — no manual imports.
- **Unified modules**: a single module can configure both NixOS and Home Manager via the `hm` alias (see below).
- **Secrets** managed with **sops-nix + age**.
- **Packages are external**: there is no local `pkgs/` tree. Custom packages come from external flake inputs and are exposed through `self.overlays.default` (see Packages).

## Common Commands

```bash
# Apply system config via nixos-cli (the `nixos` binary, provided by the `nixos-cli` input/module).
# Run from the repo root; Home Manager is bundled into the system config, so these apply both NixOS and HM together.
nixos switch            # build + activate + set as boot default        (alias for `apply`)
nixos boot              # build + set as boot default, do NOT activate   (apply --no-activate)
nixos test              # build + activate now, do NOT change boot        (apply --no-boot)

# Inspect / build without applying
nixos build             # build the configuration to ./result            (apply --no-activate --no-boot --output ./result)
nixos dry-build         # dry-build check (no store writes)              (apply --no-activate --no-boot --dry)
nixos dry-activate      # show what a switch WOULD do to the running system (apply --dry)

# Format / lint (treefmt config in persystem/formatter.nix: deadnix, alejandra, statix, prettier)
nix fmt                 # or: treefmt

# Enter the development shell (glow, sops, git-hooks via prek) — also auto-loaded by direnv
devenv shell

# Secrets (sops-nix + age; .sops.yaml defines age recipients)
sops secrets/secrets.yaml
sops secrets/ssh-gpg/hosts/angeldust-ssh.yaml
sops secrets/ssh-gpg/hosts/nixos-pc-ssh.yaml
sops secrets/ssh-gpg/hosts/angeldust-gpg.yaml
sops-update-keys        # custom script: updates sops recipients across all secret files
```

Git hooks (prek, configured in `persystem/shell.nix`) run `alejandra`, `deadnix`, `statix`, `shellcheck`, `end-of-file-fixer`, `trim-trailing-whitespace`, `detect-private-keys` on commit. Run `nix fmt` after non-trivial changes regardless.

## Architecture

### Flake entry & build pipeline

`flake.nix` → `outputs = args: import ./lib args`. The `lib/` directory is the output generator (inspired by [unazikx/flake](https://github.com/unazikx/flake)):

- **`lib/default.nix`** — the `mkFlake` entry point. Declares `systems = ["x86_64-linux"]`, wires up `overlays` (niri, hyprland, nix-cachyos-kernel, statix, `self.overlays.default`), and imports `import-tree` for `modules/` + `hosts/` and all of `persystem/`, plus the flake-parts modules (devenv, disko, bundlers, home-manager, pkgs-by-name, treefmt). Injects module args `extendedLib`, `self`, `inputs`, `_config`.
- **`lib/generator.nix`** — `buildConfiguration`: the system builder. Extends nixpkgs `lib` with helper functions and per-host scalars (`hostName`, `userName`, `hostPlatform`, `flakeDir`, `hostId`, `configurationName`), applies the global `nxosModules`/`homeModules` from flake inputs, and applies the `hm` alias module. **Also materializes the user's SSH key** — `angl_ssh_priv`/`angl_ssh_pub` from `secrets/ssh-gpg/hosts/${userName}-ssh.yaml` are written to `/home/${userName}/.ssh/id_ed25519(.pub)`.
- **`lib/functions.nix`** — `flattenSecrets`, `flattenAttrsWithSep`, `flattenAttrsDot`, `mkStylixImage`.
- **`lib/aliases.nix`** — `mkAliasOptionModule ["hm"] ["home-manager" "users" <userName>]`, which is what lets every module write `hm = { ... }` instead of the full Home Manager path.

### Hosts

`hosts/<name>/default.nix` calls `extendedLib.buildConfiguration`. `extraModules` is built with `nxosLib.attrValues` over an `inherit` block from `config.nixosModules`, so adding a module to the host means adding its name to that `inherit` list — import-tree already makes the module discoverable. Example shape (`hosts/nixos-pc`):

```nix
{
  flake = { extendedLib, config, ... }: {
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
            nix-config
            fish
            niri
            nvidia
            /* ... */
            ;
      };
    };

    diskoConfigurations.${baseNameOf ./.} = import ./disko.nix {
      devices = {
        main-disk = "/dev/disk/by-id/...";
        zfs-disk  = "/dev/disk/by-id/...";
      };
    };
  };
}
```

`disko.nix` takes a `devices` attrset (the host can pass several disks) and returns a `disko.devices` config.

### `persystem/` (per-system flake output)

flake-parts `perSystem` output, auto-imported:

- **`overlays.nix`** — defines `self.overlays.default`, which exposes external flake packages as package sets/attributes on `pkgs`: `pkgs.master` (nixpkgs-master), `pkgs.angeldust-pkgs`, `pkgs.unazikx-pkgs`, `pkgs.jonhermansen-nur-pkgs`, `pkgs.llm-agents`, `pkgs.nix-gaming`, `pkgs.firefox-addons`, and individual packages (`ayugram-desktop`, `freesmlauncher`, `iloader`, plus fixes for `nixos-cli`/`nix-update`/`fastfetch`). **This is how you reference custom packages — never look for a local `pkgs/` directory.**
- **`shell.nix`** — devenv shell (`name = "nixland"`), git-hooks, and `flake.nixConfig` (binary caches + trusted keys).
- **`formatter.nix`** — treefmt programs (see Commands).
- **`default.nix`** — exposes a `<host>-toplevel` package per nixosConfiguration.

### Modules

Auto-discovered by import-tree from `modules/`. Each module exports `flake.nixosModules.${baseNameOf ./.}` (directory name = module name, no namespace). Categories:

```
modules/
├── boot/            # kernel-optimizations (CachyOS LTO), secureboot (lanzaboote)
├── core/            # nix-config, security, ssh-gpg, users, system-optimizations, oom-killer,
│                    #   easyeffects, time-locale, usb, debloat
├── hardware/        # nvidia, sound, bluetooth, btrfs, zfs, iphone
├── networking/      # firewall, network-core, network-tools, vpn, zapret (proxy-suite)
├── cli/             # shells/ (fish, nushell), yazi, zellij, atuin, fastfetch, gopass,
│                    #   nix-cli, cli-basic-stuff, fsel, otter-launcher
├── desktop/         # wm/ (niri, hyprland, waybar, hyprlock, dunst), gaming, flatpak,
│                    #   theming, terms/ (ghostty, kitty), zen-browser, communication,
│                    #   media-tools, music, productivity, torrent, pipewire-soundpad, xdg, ...
└── development/     # editor (Neovim via angeldust-nixCats), git, jujutsu, direnv, podman,
                     #   virt-manager, database, ai/ (claude, mcp, gemini, ollama)
```

Standard module shape (NixOS + Home Manager in one):

```nix
{
  flake = _: {
    nixosModules.${baseNameOf ./.} = { config, lib, pkgs, ... }: {
      programs.foo.enable = true;          # NixOS side

      hm = {                                # Home Manager side (via the `hm` alias)
        programs.bar = { enable = true; };
      };
    };
  };
}
```

**Special arguments available everywhere** (injected by flake-parts and the extended lib): `self`, `inputs`, `extendedLib`, `_config`, and on the extended lib `lib.hostName`, `lib.userName`, `lib.hostPlatform`, `lib.flakeDir`, `lib.hostId`, `lib.configurationName`. Home Manager helpers are reachable as `lib.hm`.

### Secrets with sops-nix

`.sops.yaml` defines two age recipients (`angeldust`, `nixos-pc`) and encrypts everything matching `secrets/(ssh-gpg/.*|\w+\.yaml)$` to both. Files:

- `secrets/secrets.yaml` — the main secrets store.
- `secrets/ssh-gpg/hosts/<user|host>-{ssh,gpg}.yaml` — per-user SSH/GPG material.
- `secrets/ssh-gpg/servers/` — server-specific secrets.

Define secrets with `lib.flattenSecrets`, which walks a nested attrset and flattens it with `/`, auto-detecting sops config leaves (a leaf is any attrset whose keys are all valid sops options — `mode`, `owner`, `path`, `sopsFile`, `restartUnits`, etc.):

```nix
sops.secrets = lib.flattenSecrets {
  github = { github_pat = { mode = "0440"; }; };   # → github/github_pat
  ai     = { zai_api_key = {}; };                   # → ai/zai_api_key
  pass   = {};                                      # leaf (no config) → pass
};
```

Reference a secret at runtime via `config.sops.secrets."ai/zai_api_key".path` (or `config.hm.sops.secrets.…` on the Home Manager side). Related helpers: `flattenAttrsWithSep <sep>`, `flattenAttrsDot` (dot separator, useful for browser prefs), `mkStylixImage`.

## Testing & Workflow

1. Format: `nix fmt` before committing.
1. Dry-run build: `nixos dry-build` (or `nixos build` to materialize `./result`).
1. Verify secrets decrypt: `sops -d secrets/secrets.yaml >/dev/null`.

## Adding a New Module

1. Create `modules/<category>/<name>/default.nix` exporting `flake.nixosModules.${baseNameOf ./.}`.
1. Add the module's directory name to the host's `inherit (config.nixosModules) …` list in `hosts/<host>/default.nix`.
1. import-tree handles discovery automatically — no other wiring needed.
