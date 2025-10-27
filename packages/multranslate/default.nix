{
  lib,
  nodejs,
  buildNpmPackage,
  makeWrapper,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "multranslate";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "Lifailon";
    repo = "multranslate";
    rev = "2efcfc5e39e48895a452daac239fd70682ad9337";
    sha256 = "0g5wgqb1gm34pd05dj2i8nj3qhsz0831p3m7bsgxpjcg9c00jpyw";
  };

  buildInputs = [
    nodejs
  ];

  nativeBuildInputs = [makeWrapper];

  npmDepsHash = "sha256-mPtv4c8GwEYj1h4guIsGfCfMKNxzkQc9CaBwcq8hC28=";

  inherit nodejs;

  makeCacheWritable = true;

  postPatch = ''
    if [ -f "${./package-lock.json}" ]; then
      echo "Using vendored package-lock.json"
      cp "${./package-lock.json}" ./package-lock.json
      cp "${./package.json}" ./package.json
    else
      echo "No vendored package-lock.json found, creating a minimal one"
      echo '{"lockfileVersion": 1}' > ./package-lock.json
    fi
  '';

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/lifailon/multranslate

    # Debug: List what we have in the source
    echo "=== Source contents ==="
    ls -la

    # Copy from package subdirectory (npm tarballs extract to package/)
    echo "=== Package directory contents ==="
    cp -r *.js $out/lib/node_modules/lifailon/multranslate
    cp mock/ $out/lib/node_modules/lifailon/multranslate/

    # Debug: Check what we installed
    echo "=== Installed contents ==="
    ls -la $out/lib/node_modules/lifailon/multranslate/

    # Find the actual CLI entry point
    CLI_FILE="multranslate.js"

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/multranslate \
      --add-flags "$out/lib/node_modules/lifailon/multranslate/$CLI_FILE"

    runHook postInstall
  '';
  # patches = [ ./fix-db-path.patch ];

  meta = with lib; {
    description = "A TUI for translating text in multiple translators simultaneously as well as OpenAI and local LLM, with support for translation history and automatic language detection.";
    homepage = "https://github.com/Lifailon/multranslate";
    license = licenses.mit;
    maintainers = with maintainers; [angeldust];
  };
}
