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
  version = "6.6.0";
in
  rustPlatform.buildRustPackage (finalAttrs: {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "zxcloli666";
      repo = "SoundCloud-Desktop";
      rev = version;
      hash = "sha256-rwkVc/EyY5lfbtMQjXeIgJvT5G1wxxdSQNrp8zMK+ZA=";
    };

    cargoRoot = "desktop/src-tauri";
    cargoHash = "sha256-onoPGnt6S/I4BbtIC924ZYPrlX2dIs6SWYMlzpSPOzA=";

    buildAndTestSubdir = finalAttrs.cargoRoot;
    doCheck = false;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_10;
      fetcherVersion = 1;
      sourceRoot = "${finalAttrs.src.name}/desktop";
      hash = "sha256-ukT4Ccg32CxCEJ+RG4iLaFkujrUuLn2ED1VRHJtVHZk=";
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
        --argv0 soundcloud-desktop \
        --prefix PATH : ${lib.makeBinPath [pulseaudioFull]} \
    '';

    meta.mainProgram = finalAttrs.pname;
  })
