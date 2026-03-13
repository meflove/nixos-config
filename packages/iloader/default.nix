{
  lib,
  appimageTools,
  fetchurl,
}: let
  version = "2.0.6";
  pname = "iloader";

  src = fetchurl {
    url = "https://github.com/nab138/iloader/releases/download/v${version}/iloader-linux-amd64.AppImage";
    hash = "sha256-KS/ovrsjmeCmVW5oK/qQWT5rdTSLV6aOxipkBhqthYA=";
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
