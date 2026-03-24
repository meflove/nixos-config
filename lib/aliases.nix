lib: {
  imports = [
    # INFO: hm aliases
    (
      lib.mkAliasOptionModule
      ["hm"]
      [
        "home-manager"
        "users"
        lib.userName
      ]
    )
  ];
}
