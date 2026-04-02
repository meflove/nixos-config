{lib, ...}: let
  # Valid sops-nix secret options (from sops-nix documentation)
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

  # Check if an attrset contains only sops-nix secret options
  isSecretConfig = attrs:
    lib.all (name: builtins.elem name sopsSecretOptions) (lib.attrNames attrs);

  flattenSecrets = root: let
    joinPath = lib.concatStringsSep "/";

    flattenSecretPath = secretPath: secretGroup:
      if lib.isAttrs secretGroup && lib.length (lib.attrNames secretGroup) > 0
      then
        # If this attrset only contains sops config options, treat it as a secret with config
        if isSecretConfig secretGroup
        then {"${joinPath secretPath}" = secretGroup;}
        # Otherwise, recurse into nested secrets
        else
          lib.foldlAttrs (
            result: groupName: nestedGroup:
              result // flattenSecretPath (secretPath ++ [groupName]) nestedGroup
          ) {}
          secretGroup
      else {"${joinPath secretPath}" = secretGroup;};
  in
    flattenSecretPath [] root;
  # Universal flatten with configurable separator (defaults to "/" for sops compatibility)
  # Example: flattenAttrsWithSep "." { zen = { workspaces.continue-where-left-off = true; }; }
  #          => { "zen.workspaces.continue-where-left-off" = true; }
  flattenAttrsWithSep = separator: root: let
    joinPath = lib.concatStringsSep separator;

    flattenPath = path: group:
      if lib.isAttrs group && lib.length (lib.attrNames group) > 0
      then
        # If this attrset only contains sops config options, treat it as a leaf with config
        if isSecretConfig group
        then {"${joinPath path}" = group;}
        # Otherwise, recurse into nested attrs
        else
          lib.foldlAttrs (
            result: name: nested:
              result // flattenPath (path ++ [name]) nested
          ) {}
          group
      else {"${joinPath path}" = group;};
  in
    flattenPath [] root;

  # Alias for dot-notation (useful for Firefox/Zen browser settings)
  flattenAttrsDot = flattenAttrsWithSep ".";
in {
  inherit flattenSecrets flattenAttrsWithSep flattenAttrsDot;
}
