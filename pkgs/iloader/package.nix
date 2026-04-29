{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
}: let
  version = "2.2.5";
  pname = "iloader";

  src = fetchurl {
    url = "https://github.com/nab138/iloader/releases/download/v${version}/iloader-linux-amd64.AppImage";
    hash = "sha256-19PzDGn/Sq10xzY1HDwyo02yFrfGRD+0w56OWL1vArg=";
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
