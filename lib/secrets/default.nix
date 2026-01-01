{lib, ...}: let
  flattenSecrets = root: let
    go = path: set:
      if lib.isAttrs set && lib.length (lib.attrNames set) > 0
      then
        lib.concatLists (lib.mapAttrsToList
          (name: value: go (path ++ [name]) value)
          set)
      else [{"${lib.concatStringsSep "/" path}" = set;}];
  in
    lib.foldl' lib.mergeAttrs {} (go [] root);
in {
  inherit flattenSecrets;
}
