{
  lib,
  appimageTools,
  fetchurl,
}: let
  pname = "soundcloud-desktop";
  version = "4.1.3";

  src = fetchurl {
    url = "https://github.com/zxcloli666/SoundCloud-Desktop/releases/download/${version}/SoundCloud-${version}-x64.AppImage";
    hash = "sha256-1b+625mXWfur8ZoQ0rry/sE/YOwS2zkQy6hS08UZCZo=";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;
    meta = {
      description = "SoundCloud Desktop is the best unofficial desktop client for SoundCloud with advanced features not available in the official web player. The app is specifically designed for comfortable music listening on your computer with complete ad blocking and bypassing all restrictions.";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
    };
  }
