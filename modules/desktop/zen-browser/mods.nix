{lib, ...}: let
  inherit (lib) flattenAttrsDot;
in {
  mods = [
    "03a8e7ef-cf00-4f41-bf24-a90deeafc9db"
    "3ff55ba7-4690-4f74-96a8-9e4416685e4e"
    "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8"
    "4c2bec61-7f6c-4e5c-bdc6-c9ad1aba1827"
    "5bb07b6e-c89f-4f4a-a0ed-e483cc535594"
    "79dde383-4fe7-404a-a8e6-9be440022542"
    "81fcd6b3-f014-4796-988f-6c3cb3874db8"
    "378ba8b9-cd36-45f5-88df-595df5288795"
    "599a1599-e6ab-4749-ab22-de533860de2c"
    "906c6915-5677-48ff-9bfc-096a02a72379"
    "87196c08-8ca1-4848-b13b-7ea41ee830e7"
    "58649066-2b6f-4a5b-af6d-c3d21d16fc00"
    "a5f6a231-e3c8-4ce8-8a8e-3e93efd6adec"
    "a6335949-4465-4b71-926c-4a52d34bc9c0"
    "ad97bb70-0066-4e42-9b5f-173a5e42c6fc"
    "bc25808c-a012-4c0d-ad9a-aa86be616019"
    "c8d9e6e6-e702-4e15-8972-3596e57cf398"
    "cb15abdb-0514-4e09-8ce5-722cf1f4a20f"
    "d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe"
    "fd24f832-a2e6-4ce9-8b19-7aa888eb7f8e"
  ];

  mods-settings = flattenAttrsDot {
    # Zen Colored Picker
    nova.color = {
      picker-gradient-new = true;
      picker-grid = true;
      picker-frame = true;
    };

    # Better Find Bar
    theme.better_find_bar.vertical_position = "top";

    uc = {
      # SuperPins
      pins.stay-at-top = true;
      tabs = {
        show-separator = "essentials-shown";
        dim-type = "both";
      };
      favicon.size = "normal";
      workspace.current.icon.size = "large";

      # Zen Context Menu
      hidecontext = {
        separators = true;
        copylink = true;
        bookmark = true;
        sendtodevice = true;
        closetab = true;
        askchatbot = true;
        searchinpriv = true;
        printselection = true;
        image = true;
        selectalltext = true;
        selectalltabs = true;
        reloadtab = true;
        duplicatetab = true;
        savelink = true;
        screenshot = true;
        navigation = true;
      };
      fixcontext = {
        restoreicons = true;
        applyzengradient = true;
        applyzenaccent = true;
      };
    };
  };
}
