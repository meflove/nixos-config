# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) and any other AI
agents working in this repository. It is also exposed as `AGENTS.md` (a
symlink to this file) for tooling that reads that filename.

**This repo uses JJ (jujutsu, colocated with git) as vcs backend!**

Personal NixOS config: NixOS unstable + Lix, flake-parts, single host
`nixos-pc` (user `angeldust`, x86_64-linux, stateVersion 26.05). Focused on
gaming, development, and a Niri Wayland desktop (a Hyprland module exists but
is not enabled on the host).

**Key architectural decisions:**

- **Lix** as the Nix implementation (via `lix` + `lix-module` inputs).
- **flake-parts** as the flake framework; per-system output lives in `persystem/`.
- **`flake.nix` is generated** (flake-file): inputs are declared as
  `flake-file.inputs` blocks co-located with the code that uses them
  (`lib/default.nix` for core inputs, each `persystem/*` file or module for
  its own deps) and are deduplicated into the single `flake.nix`. Regenerate
  with `write-all` (writes inputs **and** generated files) or
  `nix run .#write-flake` (flake only) — never edit `flake.nix` by hand.
- **import-tree** auto-discovers every `default.nix` under `modules/` and `hosts/` — no manual imports.
- **Unified modules**: a single module can configure both NixOS and Home Manager via the `hm` alias (see below).
- **Secrets** are managed primarily with **nix-secrets + age**
  (`security.nix-secrets`, one `.enc` file per secret under `nix-secrets/`);
  **sops-nix + age** stays fully wired as a ready second backend
  (`secrets/*.yaml`) — it stays until deliberately removed, not as a
  migration leftover.
- **Packages are external**: there is no local `pkgs/` tree. Custom packages come from external flake inputs and are exposed through overlays (see persystem/overlays.nix).

## Common Commands

```bash
# Apply system config via nixos-cli (the `nixos` binary).
# Run from the repo root; Home Manager is bundled into the system build, so these
# apply both NixOS and HM together. Use `nixos`, NOT `nixos-rebuild`.
nixos switch            # build + activate + set as boot default        (alias for `apply`)
nixos boot              # build + set as boot default, do NOT activate   (apply --no-activate)
nixos test              # build + activate now, do NOT change boot        (apply --no-boot)

# Inspect / build without applying
nixos build             # build the configuration to ./result            (apply --no-activate --no-boot --output ./result)
nixos dry-build         # cheap verification that the config evaluates/builds (no store writes)
nixos dry-activate      # show what a switch WOULD do to the running system (apply --dry)
nix build .#nixos-pc-toplevel   # alternative build check via the flake package

# Format everything (treefmt config in persystem/formatter.nix) — REQUIRED before commit
nix fmt                 # or: treefmt

# Enter the development shell (glow, sops, prek git-hooks, write-all) — also auto-loaded by direnv
devenv shell

# Regenerate flake.nix from the flake-file.inputs declarations
nix run .#write-flake  # flake.nix only
write-all              # in the devenv shell: flake.nix + generated files (.claude/settings.json)

# Secrets — nix-secrets is the primary backend (CLI is installed system-wide by
# the module; storagePath is set, so no --storage argument is needed)
nix-secrets edit ai/zai_api_key   # add/edit a secret by NAME → nix-secrets/ai/zai_api_key.enc
nix-secrets rekey                 # re-encrypt after changing recipients (all secrets, or list names)
nix-secrets keygen                # generate an age key
# sops-nix — the second secrets backend (secrets/*.yaml; .sops.yaml defines age recipients)
sops secrets/secrets.yaml
sops secrets/ssh-gpg/hosts/angeldust-ssh.yaml
sops secrets/ssh-gpg/hosts/nixos-pc-ssh.yaml
sops secrets/ssh-gpg/hosts/angeldust-gpg.yaml
sops-update-keys        # custom script: updates sops recipients across all secret files
```

### Formatting & git hooks

- `nix fmt` (treefmt, `persystem/formatter.nix`): for `*.nix` — alejandra →
  pedantix (arg sorting, preset `nixos-module`) → statix → deadnix
  (`--no-underscore`); plus prettier (`*.md`), jsonfmt, kdlfmt (behind the
  `kdlfmt-with-config` wrapper — indent 2, config generated via HM's `toKDL`),
  ruff-format, taplo, yamlfmt. `secrets/*`, `nix-secrets/*`, `pics/*`,
  `.sops.yaml`, `.gitignore`, `.envrc` are excluded from formatting.
- pedantix cannot parse the `|>` pipe operator (tree-sitter-nix limitation,
  Swarsel/pedantix#19) and exits 2, which would abort treefmt — so it is
  wrapped (`pedantix-forgiving` in `persystem/formatter.nix`) to downgrade
  exit 2 to a skip: files using `|>` are left to alejandra/statix/deadnix.
- Git hooks (prek, configured in `persystem/shell.nix`) run on commit:
  treefmt (via the treefmt-nix wrapper, so hooks share the `nix fmt` config
  from `persystem/formatter.nix` — alejandra, pedantix, statix, deadnix and
  the other formatters in one hook), shellcheck, end-of-file-fixer,
  detect-private-keys.

## Workflow for changes

1. Edit modules / host config.
2. `nix fmt` (hooks also run the formatters on commit).
3. `nixos dry-build` to verify the config still builds.
4. Touched secrets? After changing recipients, rekey: `nix-secrets rekey`
   (nix-secrets) or `sops-update-keys` (sops auto-rekey script from
   `modules/core/sops-nix`). Sops decryption still verifies with
   `sops -d secrets/secrets.yaml >/dev/null`.
5. **Keep this file in sync.** Any change to architecture, commands, workflows,
   conventions, or the module tree must be reflected in CLAUDE.md in the same
   change — docs must never drift from the config.
6. **Never commit unless the user asks.** The repo is colocated jj; the user
   runs fmt/add/commits themselves — agents must not run `git`/`jj` commands.
   Commit style, when asked to commit: `emoji type(scope): subject`.

## CI

**Primary forge is Tangled**
(`https://tangled.org/angeldust.tngl.sh/nixos-config`); GitHub and Codeberg
are mirrors:

- `.tangled/workflows/mirror.yml` — on push/PR/manual for `main` (engine
  `microvm`, `alpine` image, full clone `depth: 0`) force-pushes `main` to
  GitHub (`git@github.com:meflove/nixos-config.git`) and Codeberg
  (`ssh://git@codeberg.org/angeldust/nixos-config.git`). Requires Tangled
  repo secrets: `GIT_SSH_PRIVATE_KEY` (SSH key authorized on GitHub and
  Codeberg) and `GIT_SSH_KNOWN_HOSTS` (github.com + codeberg.org host keys).
- Legacy mirror hops, kept until the mirrors are archived:
  `.woodpecker/mirror.yml` (Woodpecker hooked to Codeberg; full clone via
  plugin-git `partial: false, depth: 0`; secrets `private_ssh_key` +
  `known_hosts`) force-pushes `main` to GitHub + Tangled, and
  `.github/workflows/mirror-to-codeberg-tangled.yml` mirrors
  GitHub → Codeberg + Tangled.

## Architecture

### Flake entry & build pipeline

`flake.nix` is generated from the `flake-file.inputs` declarations (see key
decisions above) and only carries them plus `outputs = args: import ./lib
args`. The `lib/` directory is the output generator (inspired by
[unazikx/flake](https://github.com/unazikx/flake)):

- **`lib/default.nix`** — the `mkFlake` entry point. Declares `systems = ["x86_64-linux"]`, wires up overlays (niri, hyprland, nix-cachyos-kernel, angeldust-nix-packages, nur, atuin, statix, `self.overlays.default`), and imports `import-tree` for `modules/` + `hosts/` and all of `persystem/`, plus the flake-parts modules (devenv, disko, bundlers, home-manager, pkgs-by-name, treefmt, pedantix, flake-file, files). Injects `extendedLib` into the outer eval (`_module.args`) so `flake-file.inputs` sites can use it, and module args `extendedLib`, `self`, `inputs`, `_config` into the `flake` eval.
- **`lib/generator.nix`** — `buildConfiguration`: the system builder. Extends nixpkgs `lib` with helper functions and per-host scalars (`hostName`, `userName`, `hostPlatform`, `flakeDir`, `hostId`, `configurationName`), applies the global `nxosModules`/`homeModules` from flake inputs (sops-nix **and** nix-secrets on both the NixOS and HM sides), and applies the `hm`/`nix-secrets` alias modules. Sops defaults and the user's SSH-key provisioning now live in `modules/core/sops-nix`.
- **`lib/functions.nix`** — `flattenSecrets`, `flattenAttrsWithSep`, `flattenAttrsDot`, `mkStylixImage`,
  `mkNativeInputs` (recursive `autoFollow = false` keeping an input's whole subtree on its own
  upstream inputs; exposed to flake-parts modules via the `extendedLib` module arg, used in
  `flake-file.inputs` configs).
- **`lib/aliases.nix`** — two `mkAliasOptionModule` aliases: `hm` → `["home-manager" "users" <userName>]` and `nix-secrets` → `["security" "nix-secrets"]`, which let every module write `hm = { ... }` and `nix-secrets.secrets = ...` instead of the full paths.

### Hosts

Single host: `hosts/nixos-pc`. `hosts/<name>/default.nix` calls
`extendedLib.buildConfiguration`. `extraModules` is built with
`nxosLib.attrValues` over an `inherit` block from `config.nixosModules`, so
adding a module to the host means adding its name to that `inherit` list —
import-tree already makes the module discoverable. Shape:

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

- **`overlays.nix`** — declares its own inputs via `flake-file.inputs` (`nixpkgs`, `chaotic`, `nur`, …; `angeldust-nix-packages` keeps its input subtree on upstream pins via `extendedLib.mkNativeInputs`) and defines `self.overlays.default`:
  - pkg sets on `pkgs`: `pkgs.master` (nixpkgs-master), `pkgs.jonhermansen-nur-pkgs`, `pkgs.llm-agents`, `pkgs.nix-gaming`, `pkgs.firefox-addons`;
  - individual packages: `ayugram-desktop`, `freesmlauncher`, `iloader`, `iris`;
  - fixes: `nix` → lix, plus overrides for `nixos-cli`, `nix-update`, and `fastfetch` (zfs support).
    Additional input overlays are wired in `lib/default.nix` and provide things like `pkgs.angeldust-pkgs` and `niri-unstable`. **This is how you reference custom packages — never look for a local `pkgs/` directory.**
- **`shell.nix`** — devenv shell (`name = "nixland"`), git-hooks, and the `write-all` helper (regenerates `flake.nix` + generated files). `flake.nixConfig` (binary caches, `pipe-operators`, IFD) now lives in `modules/core/nix-config`.
- **`files.nix`** — generated-file tree via the `files` input (sini/files): `.claude/settings.json`, a Claude Code PostToolUse hook that runs treefmt on every file Claude edits. `files.generateApp = true` exposes the `write-files` app used by `write-all`.
- **`formatter.nix`** — treefmt programs (see Commands).
- **`default.nix`** — exposes a `<host>-toplevel` package per nixosConfiguration.

### Modules

Auto-discovered by import-tree from `modules/`. Each module exports `flake.nixosModules.${baseNameOf ./.}` (directory name = module name, no namespace). **Discovery is automatic; enabling is not** — a module only takes effect once added to the host's `inherit (config.nixosModules)` list.

```
modules/
├── boot/            # kernel-optimizations (CachyOS LTO), secureboot (lanzaboote)
├── core/            # nix-config, security, nix-secrets (primary secrets), sops-nix,
│                    #   ssh-gpg, users, system-optimizations, oom-killer, easyeffects,
│                    #   time-locale, usb, debloat
├── hardware/        # nvidia, sound, bluetooth, btrfs, zfs, mouse, iphone, openrgb
├── networking/      # firewall, network-core, network-tools, vpn, zapret (proxy-suite)
├── cli/             # shells/ (fish, nushell), yazi, zellij, atuin, fastfetch, gopass,
│                    #   nix-cli, cli-basic-stuff, fsel, iris, otter-launcher
├── desktop/         # wm/ (niri, hyprland, hyprlock, waybar, vicinae, notifications/ (dunst, mako)),
│                    #   terms/ (ghostty, kitty), gaming, flatpak, theming, zen-browser,
│                    #   communication/ (nixcord), media-tools, music, productivity, torrent,
│                    #   pipewire-soundpad, xdg, hyprscope
└── development/     # editor (Neovim via angeldust-nvimWrap), vcs/ (git, jujutsu), direnv, podman,
                     #   virt-manager, database, ai/ (claude, opencode, mcp, gemini, ollama)
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

### Secrets (nix-secrets primary, sops-nix secondary)

**nix-secrets** ([unnamed-systems/nix-secrets](https://github.com/unnamed-systems/nix-secrets))
is the **primary** secrets provider: everything is declared in the module
system (no side files like `.sops.yaml`), each secret is its own age-encrypted
file, and the module auto-installs the `nix-secrets` CLI system-wide. It is
wired by `modules/core/nix-secrets`: storage `nix-secrets/` at the repo root
(`storagePath` = `<flakeDir>/nix-secrets`, so CLI calls need no `--storage`),
identity paths (`/var/lib/nix-secrets/key.txt`, the host's SSH ed25519 key,
the user's age and SSH keys), and age recipient aliases `angeldust` /
`nixos-pc` (both are default recipients). `modules/core/ssh-gpg` declares its
SSH/GPG material via nix-secrets.

- **Never write plaintext secrets**; each secret is one file under
  `nix-secrets/`, nested directories matching the secret name
  (`github/github_pat.enc`, `ssh-gpg/users/angeldust/ssh_priv.enc`, …).
- Declare with the `nix-secrets` alias (→ `security.nix-secrets`) and
  `lib.flattenSecrets`, which walks a nested attrset, flattens it with `/`
  and auto-detects config leaves (a leaf is any attrset whose keys are all
  valid per-secret options — nix-secrets' `name`, `generator`, `placeholder`,
  `recipients`, or the shared sops-style ones like `owner`, `mode`,
  `neededForUsers`). Nested names match the storage layout
  (`{ github.pat = {}; }` → key `github/pat`, file `github/pat.enc`):

```nix
nix-secrets.secrets = lib.flattenSecrets {
  ai   = { zai_api_key = { owner = lib.userName; }; };  # → ai/zai_api_key
  pass = { neededForUsers = true; };                    # → pass, usable for users.users
};
```

- Reference at runtime via `config.nix-secrets.secrets."ai/zai_api_key".path`
  (long form `config.security.nix-secrets.secrets.…`); secrets are mounted
  under `/run/nix-secrets/` by default.
- **Templates** render files that combine several secrets: interpolating a
  secret into `content` inserts its placeholder, and the rendered file is
  consumed via `config.nix-secrets.templates."<name>".path`:

```nix
nix-secrets.templates."wireless.conf" = {
  owner = "wpa_supplicant";
  content = ''
    psk_home=${config.nix-secrets.secrets."wifi/Keenetic_home"}
  '';
};
# consumer: networking.wireless.secretsFile = config.nix-secrets.templates."wireless.conf".path;
```

In use: `network-core` (wpa_supplicant `wireless.conf`), `jujutsu`
(`allowed_signers`), `nix-config` (`nix-access-tokens.nix`).

- Workflow: declare the secret in a module → `nix-secrets edit <name>` from
  the repo root (the CLI evaluates the flake itself — no rebuild needed;
  name, not file path) → commit the resulting `.enc` → rebuild to activate.
  After changing recipients: `nix-secrets rekey` (all secrets, or list
  names). Related helpers: `flattenAttrsWithSep <sep>` (purely structural —
  every attrset is recursed into), `flattenAttrsDot` (dot separator, useful
  for browser prefs), `mkStylixImage`.

**sops-nix + age** is the **second, fully working backend** — not scheduled
for removal, it stays until deliberately dropped. `modules/core/sops-nix`
holds the sops defaults, the `sops-update-keys` auto-rekey script and the
user's SSH-key materialization (`hm.sops.secrets."angl_ssh_priv"` /
`"angl_ssh_pub"` from `secrets/ssh-gpg/hosts/<user>-ssh.yaml`). `.sops.yaml`
defines the same two age recipients (`angeldust`, `nixos-pc`) and encrypts
everything matching `secrets/(ssh-gpg/.*|\w+\.yaml)$`:
`secrets/secrets.yaml` (the sops secrets store) and
`secrets/ssh-gpg/hosts/<user|host>-{ssh,gpg}.yaml` (per-user/host SSH/GPG
material), plus `secrets/ssh-gpg/servers/` for server-specific secrets.

`lib.flattenSecrets` works for both backends, so sops declarations look the
same: `sops.secrets = lib.flattenSecrets { … }` / `hm.sops.secrets = …`,
referenced via `config.sops.secrets."<key>".path` (or `config.hm.sops.secrets.…`
on the Home Manager side) and `config.sops.placeholder."<key>"` inside
`sops.templates`. Several modules (`users`, `nix-config`, `network-core`,
`zapret`, `claude`) declare the same secret in **both** backends — the
active consumers read the nix-secrets paths; flipping a consumer to the sops
path is all it takes to switch backends. After changing `.sops.yaml`
recipients, run `sops-update-keys`.

## Conventions & gotchas

- alejandra indents with **2 spaces** (alejandra.toml); deadnix runs with
  `--no-underscore` (prefix unused args with `_`).
- `flake.nix` and `.claude/settings.json` are **generated** (flake-file /
  `persystem/files.nix`) — never edit them by hand; change the
  `flake-file.inputs` declaration or the `files.file` tree and run
  `write-all`.
- `modules/development/ai/opencode/AGENTS.md` is NOT repo docs — it is the
  user's global opencode context file deployed by the opencode module. Don't
  reformat or "clean" it.
- `ignore/` holds logs/coredumps — irrelevant to config.
- Comments in nix files use `# INFO:` / `# WARN:` markers for important notes.

## Adding a New Module

1. Create `modules/<category>/<name>/default.nix` exporting `flake.nixosModules.${baseNameOf ./.}`.
2. Needs a new flake input? Declare it right in the module — `flake-file.inputs.<name>.url = "github:owner/repo";` — and regenerate with `write-all` (or `nix run .#write-flake`).
3. Add the module's directory name to the host's `inherit (config.nixosModules) …` list in `hosts/nixos-pc/default.nix`.
4. import-tree handles discovery automatically — no other wiring needed.
