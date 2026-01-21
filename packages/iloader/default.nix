{
  lib,
  appimageTools,
  fetchurl,
}: let
  version = "1.1.6";
  pname = "iloader";

  src = fetchurl {
    url = "https://github.com/nab138/iloader/releases/download/v${version}/iloader-linux-amd64.AppImage";
    hash = "sha256-L1fFwFjdIrrhviBlwORhSDXsNYgrT1NcVKAKlss6h4o=";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    meta = {
      description = "Viewer for electronic invoices";
      homepage = "https://github.com/ZUGFeRD/quba-viewer";
      downloadPage = "https://github.com/ZUGFeRD/quba-viewer/releases";
      license = lib.licenses.asl20;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      maintainers = with lib.maintainers; [onny];
      platforms = ["x86_64-linux"];
    };
  }
