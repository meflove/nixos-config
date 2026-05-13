{
  appimageTools,
  fetchurl,
  makeDesktopItem,
}: let
  version = "2.2.6";
  pname = "iloader";

  src = fetchurl {
    url = "https://github.com/nab138/iloader/releases/download/v${version}/iloader-linux-amd64.AppImage";
    hash = "sha256-rLsDVXct9hFu3cyDv5i7NQX820WDxMfFEMfiUPGrOjU=";
  };

  desktopItem = makeDesktopItem {
    name = "iloader";
    desktopName = "Iloader";
    comment = "Image loader application";
    exec = "iloader";
    icon = "iloader";
    categories = ["Graphics" "Photography"];
    startupWMClass = "iloader";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;
    desktopItems = [desktopItem];
  }
