{
  lib,
  stdenv,
  rustPlatform,
  fetchPnpmDeps,
  fetchFromGitHub,
  # nativeBuildInputs
  cargo-tauri,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  pkg-config,
  makeWrapper,
  autoconf,
  automake,
  libtool,
  wrapGAppsHook4,
  # buildInputs
  glib-networking,
  openssl,
  webkitgtk_4_1,
  alsa-lib,
  libopus,
  libayatana-appindicator,
  libappindicator-gtk3,
  libappindicator,
  pulseaudioFull,
}: let
  pname = "soundcloud-desktop";
  version = "6.3.0";
in
  rustPlatform.buildRustPackage (finalAttrs: {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "zxcloli666";
      repo = "SoundCloud-Desktop";
      rev = version;
      hash = "sha256-PcsvC8+8QZC7sXa3TdcVqgUS+OXFBO7MKCyLWKdPb10=";
    };

    cargoRoot = "desktop/src-tauri";
    cargoHash = "sha256-m1BybTy9+cHPcagO34dfmLTIjpx5QWodxcgKG+1lO6g=";

    buildAndTestSubdir = finalAttrs.cargoRoot;
    doCheck = false;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      fetcherVersion = 1;
      sourceRoot = "${finalAttrs.src.name}/desktop";
      hash = "sha256-V+W85Cd8tIuq2f9nK9QpxyNena49/uUAazc6ilXMJ9s=";
    };

    pnpmRoot = "desktop";

    nativeBuildInputs =
      [
        cargo-tauri.hook

        nodejs
        pnpmConfigHook
        pnpm_10

        pkg-config
        makeWrapper

        autoconf
        automake
        libtool
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [wrapGAppsHook4];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      openssl
      webkitgtk_4_1
      alsa-lib
      libopus
      libayatana-appindicator
      libappindicator-gtk3
      libappindicator
    ];

    propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      pulseaudioFull
    ];

    postPatch = ''
      if [ $cargoDepsCopy ]; then
        substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
          --replace-fail "libayatana-appindicator3.so.1" "${lib.getLib libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
      fi
    '';

    postInstall = ''
      wrapProgram $out/bin/soundcloud-desktop \
        --prefix PATH : ${lib.makeBinPath [pulseaudioFull]}
    '';
    meta.mainProgram = finalAttrs.pname;
  })
