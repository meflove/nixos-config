{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  webkitgtk_4_1,
  openssl,
  libsoup_3,
  libayatana-appindicator,
  libappindicator-gtk3,
  glib,
  gst_all_1,
}: let
  pname = "soundcloud-desktop";
  version = "5.3.1";

  src = fetchurl {
    url = "https://github.com/zxcloli666/SoundCloud-Desktop/releases/download/${version}/soundcloud-desktop_${version}_amd64.deb";
    hash = "sha256-xQIWP8e3IXu+y5rU/MhXNtAPY/57dquEblkos+eK5vU=";
  };
in
  stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [
      webkitgtk_4_1
      openssl
      libsoup_3
      libayatana-appindicator
      libappindicator-gtk3
      glib
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
    ];

    unpackPhase = ''
      # Распаковываем deb архив
      dpkg-deb -x $src source
    '';

    installPhase = ''
      runHook preInstall

      # Копируем файлы из распакованного deb
      cp -r source/* $out/

      # Создаём обёртку с переменными окружения
      wrapProgram $out/bin/soundcloud-desktop \
        --prefix WEBKIT_DISABLE_DMABUF_RENDERER : "1" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${gst_all_1.gst-plugins-base}/lib/gstreamer-1.0" \
        --prefix LD_LIBRARY_PATH : "${libayatana-appindicator}/lib:${libappindicator-gtk3}/lib"

      runHook postInstall
    '';

    meta = {
      description = "SoundCloud Desktop is the best unofficial desktop client for SoundCloud with advanced features not available in the official web player. The app is specifically designed for comfortable music listening on your computer with complete ad blocking and bypassing all restrictions.";
      homepage = "https://github.com/zxcloli666/SoundCloud-Desktop";
      license = lib.licenses.mit;
      mainProgram = "soundcloud-desktop";
      platforms = lib.platforms.linux;
    };
  }
