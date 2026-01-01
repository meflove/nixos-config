{
  lib,
  makeWrapper,
  stdenvNoCC,
  fetchFromGitHub,
  # runtime deps (depend on script)
  bash,
  gamescope,
  jq,
  gamemode,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hyprscope";
  version = "1.0.0";

  # Your external shell script.
  src = fetchFromGitHub {
    owner = "bajankristof";
    repo = "${finalAttrs.pname}";
    rev = "main";
    hash = "sha256-9p4hiX4595QeJ6gzHFjUbtzLqkb8gyydvAS4OP1yaWs=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    bash
    gamescope
    jq
    gamemode
  ];

  # makeFlags = [
  #   "PREFIX=$(out)"
  # ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm755 ${finalAttrs.src}/hyprscope $out/bin/hyprscope

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/hyprscope --prefix PATH ':' \
      "${
      lib.makeBinPath [
        bash
        gamescope
        jq
        gamemode
      ]
    }"
  '';

  meta = {
    description = "A Hyprland based wrapper for Gamescope to run apps and games in a nested Wayland compositor with various enhancements.";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "${finalAttrs.pname}";
  };
})
