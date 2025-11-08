{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "claude-code-statusline";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "sotayamashita";
    repo = "claude-code-statusline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CtwZOT8YG0sg5vFJKQKYNptmJUYr6XaAwroD33KNOOo=";
  };

  cargoHash = "sha256-z6HjW+ywykEg2WmsmqSFB2cxc9PIBRxA8EHC+q2Wf3U=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  hardeningDisable = [
    "zerocallusedregs"
  ];

  meta = {
    description = "claude-code-statusline is a lightweight, high-performance status line generator written in Rust, designed for AI-powered development environments. It provides a starship-like configuration experience.";

    homepage = "https://github.com/sotayamashita/claude-code-statusline";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    badPlatforms = ["aarch64-linux"];
    maintainers = with lib.maintainers; [
      angeldust
    ];
  };
})
