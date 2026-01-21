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
in {
  inherit flattenSecrets;
}
