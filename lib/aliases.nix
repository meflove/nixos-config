lib: {
  imports = let
    userHm = [
      "home-manager"
      "users"
      lib.userName
    ];
  in [
    # INFO: hm aliases
    (
      lib.mkAliasOptionModule
      ["hm"]
      userHm
    )
    (
      lib.mkAliasOptionModule
      ["nix-secrets"]
      [
        "security"
        "nix-secrets"
      ]
    )
  ];
}
