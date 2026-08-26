# AGENTS.md

Personal NixOS config: NixOS unstable + Lix, flake-parts, single host `nixos-pc`
(user `angeldust`, x86_64-linux, stateVersion 26.05). Detailed architecture doc
lives in `CLAUDE.md` — this file is the short version for agents.

## Commands

```bash
nix fmt                  # format everything (REQUIRED before commit): alejandra, deadnix, statix, prettier
nixos dry-build          # cheap verification that the config evaluates/builds
nixos build              # full build into ./result
nix build .#nixos-pc-toplevel   # alternative build check via flake package
nixos switch             # apply (build + activate + set boot default)
nixos dry-activate       # preview what a switch would do

devenv shell             # dev shell (auto-loaded by direnv): sops, glow, prek hooks
```

Use `nixos` CLI (nixos-cli), NOT `nixos-rebuild`. Home Manager is bundled into
the system build — there are no standalone `home-manager`/`darwin` rebuilds.

## Workflow for changes

1. Edit modules / host config.
2. `nix fmt` (hooks also run alejandra, deadnix, statix, shellcheck on commit;
   statix checks the whole repo, not just staged files).
3. `nixos dry-build` to verify.
4. Never commit unless the user asks. The repo is colocated git + jj
   (jujutsu); the user commits with jj. Commit style: `emoji type(scope): subject`.

## Architecture essentials

- `flake.nix` → `lib/` = flake generator (`lib/generator.nix` builds hosts,
  injects per-host `lib.hostName`, `lib.userName`, etc.).
- **import-tree** auto-imports every `default.nix` under `modules/` and
  `hosts/` — there is no manual import list. A module directory's name =
  `flake.nixosModules.<name>`.
- **Enabling a module**: it must be added to the `inherit (config.nixosModules)`
  list in `hosts/nixos-pc/default.nix`. Discovery is automatic; enabling is not.
- **`hm` alias**: every NixOS module writes Home Manager config as
  `hm = { ... }` instead of the full `home-manager.users.<user>` path.
- **No local `pkgs/` tree.** Custom/external packages come through
  `self.overlays.default` (persystem/overlays.nix): `pkgs.master`,
  `pkgs.llm-agents`, `pkgs.nix-gaming`, `pkgs.firefox-addons`,
  `pkgs.ayugram-desktop`, etc. Fixes for `nix`, `nixos-cli`, `nix-update`,
  `niri-unstable`, `fastfetch`, `ananicy-cpp` also live there.
- Extra module args available everywhere: `self`, `inputs`, `extendedLib`,
  `_config`.

## Secrets (sops-nix + age)

- Never write plaintext secrets; they live in `secrets/*.yaml` (encrypted).
- Define new secrets with `lib.flattenSecrets { group = { name = { mode = ...; }; }; }`
  → produces `sops.secrets."group/name"`. Leaf = attrset whose keys are all
  sops options (`mode`, `path`, `sopsFile`, `restartUnits`, ...); `{}` = no config.
- Runtime path: `config.sops.secrets."group/name".path` (or `config.hm.sops...`).
- Edit with `sops secrets/secrets.yaml`; after changing `.sops.yaml` recipients
  run `sops-update-keys`.
- Verify decryption: `sops -d secrets/secrets.yaml >/dev/null`.

## Conventions & gotchas

- alejandra indents with **2 spaces** (alejandra.toml); deadnix runs with
  `--no-underscore` (prefix unused args with `_`).
- `modules/development/ai/opencode/AGENTS.md` is NOT repo docs — it is the
  user's global opencode context file deployed by the opencode module. Don't
  reformat or "clean" it.
- `ignore/` holds logs/coredumps — irrelevant to config.
- Comments in nix files use `# INFO:` / `# WARN:` markers for important notes.
