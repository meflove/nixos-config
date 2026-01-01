{
  lib,
  appimageTools,
  fetchurl,
}: let
  version = "1.1.5";
  pname = "iloader";

  src = fetchurl {
    url = "https://github.com/nab138/iloader/releases/download/v${version}/iloader-linux-amd64.AppImage";
    hash = "sha256-Ll2F2ncW6/8OBf/egOohhiHeu830EohLBU5LCuprLHc=";
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
