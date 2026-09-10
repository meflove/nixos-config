{
  lib,
  # INFO: only mkStylixImage needs pkgs; the flake-level instance
  # (extendedLib) imports this file without it
  pkgs ? null,
  ...
}: let
  # Flat per-secret options of sops-nix (sops.secrets.<name>)
  sopsSecretOptions = [
    "neededForUsers"
    "owner"
    "group"
    "mode"
    "path"
    "sopsFile"
    "format"
    "key"
    "restartUnits"
    "reloadUnits"
  ];

  # Flat per-secret options of nix-secrets (security.nix-secrets.secrets.<name>)
  # that are not shared with sops-nix. Read-only options (__toString,
  # templateKey) are never set in config, so they are not listed here.
  nixSecretsOptions = [
    "name"
    "generator"
    "placeholder"
    "recipients"
  ];

  # INFO: an attrset consisting only of these keys is a secret's settings
  # (leaf), not a group of nested secrets — works for both sops-nix
  # (sops.secrets) and nix-secrets (security.nix-secrets.secrets)
  secretLeafOptions = sopsSecretOptions ++ nixSecretsOptions;

  # Check if an attrset contains only secret options
  isSecretConfig = attrs:
    lib.all (name: builtins.elem name secretLeafOptions) (lib.attrNames attrs);

  # Generic nested-attrset flattener: separator joins the key path, isLeaf
  # decides whether a non-empty attrset is a value (not recursed into)
  flattenAttrsBy = isLeaf: separator: root: let
    joinPath = lib.concatStringsSep separator;

    flattenPath = path: group:
      if lib.isAttrs group && lib.length (lib.attrNames group) > 0 && !isLeaf group
      then
        # Recurse into nested attrs
        lib.foldlAttrs (
          result: groupName: nestedGroup:
            result // flattenPath (path ++ [groupName]) nestedGroup
        ) {}
        group
      else {"${joinPath path}" = group;};
  in
    flattenPath [] root;

  # INFO: flatten a nested secrets tree into slash-separated keys, usable for
  # both sops-nix and nix-secrets backends:
  #   { github = { pat = {}; }; } => { "github/pat" = {}; }
  flattenSecrets = flattenAttrsBy isSecretConfig "/";

  # Universal flatten with configurable separator (purely structural: any
  # non-attrset value is a leaf, attrsets are always recursed into)
  # Example: flattenAttrsWithSep "." { zen = { workspaces.continue-where-left-off = true; }; }
  #          => { "zen.workspaces.continue-where-left-off" = true; }
  flattenAttrsWithSep = flattenAttrsBy (_: false);

  # Alias for dot-notation (useful for Firefox/Zen browser settings)
  flattenAttrsDot = flattenAttrsWithSep ".";

  # Names that are always safe to deduplicate to the matching root input at
  # any depth: evaluation/dev tooling with a stable interface that never
  # affects build outputs. WARN: never add package sets (nixpkgs) or
  # toolchains (rust-overlay, fenix, naersk) here.
  baseFollowInputs = [
    "flake-compat"
    "flake-parts"
    "flake-utils"
    "git-hooks"
    "git-hooks-nix"
    "import-tree"
    "pkgs-by-name"
    "treefmt-nix"
  ];

  # Recursively mark every nested input of a flake input as autoFollow = false,
  # keeping the whole subtree on its own upstream-native inputs at any depth.
  # Names in `baseFollowInputs` plus the caller's `extra` stay automatically
  # deduplicated to the root input.
  # Example: mkNativeInputs ["import-tree"] self.inputs.foo.inputs
  mkNativeInputs = extra: lockedInputs: let
    excluded = baseFollowInputs ++ extra;
    native = name: input:
      if builtins.elem name excluded
      then {}
      else {
        autoFollow = false;
        # INFO: empty nested attrsets are dropped by flake-file's inputsExpr
        inputs = builtins.mapAttrs native (input.inputs or {});
      };
  in
    builtins.mapAttrs native lockedInputs;

  mkStylixImage = image: colors:
    pkgs.runCommand "stylix-image.png" {} (
      lib.concatStringsSep " " [
        (lib.getExe pkgs.lutgen)
        "apply"
        image
        "-o"
        "$out"
        "--"
        (builtins.concatStringsSep " " colors)
      ]
    );
in {
  inherit
    flattenSecrets
    flattenAttrsWithSep
    flattenAttrsDot
    mkNativeInputs
    mkStylixImage
    ;
}
