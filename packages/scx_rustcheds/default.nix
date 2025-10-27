{
  lib,
  rustPlatform,
  llvmPackages,
  pkg-config,
  elfutils,
  zlib,
  zstd,
  fetchFromGitHub,
  protobuf,
  libseccomp,
  nix-update-script,
  nixosTests,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scx_rustscheds";
  version = "1.0.17-lavd-patch";

  src = fetchFromGitHub {
    owner = "multics69";
    repo = "scx";
    rev = "f1190ed4bcd7d814e99cb1a1178d9abb233fd87f";
    # tag = "v${finalAttrs.version}";
    hash = "sha256-LLnEYYb8tBOeaqe8nktkyZBfvM+7mJOIup9yuTh+j7I=";
  };

  cargoHash = "sha256-7jjADfI3rRBRd3/XENtXUfXnNgw+W9TjCqcZ/eBBZtg=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    protobuf
  ];
  buildInputs = [
    elfutils
    zlib
    zstd
    libseccomp
  ];

  env = {
    BPF_CLANG = lib.getExe llvmPackages.clang;
    RUSTFLAGS = lib.concatStringsSep " " [
      "-C relocation-model=pic"
      "-C link-args=-lelf"
      "-C link-args=-lz"
      "-C link-args=-lzstd"
    ];
  };

  hardeningDisable = [
    "zerocallusedregs"
  ];

  doCheck = true;
  checkFlags = [
    "--skip=compat::tests::test_ksym_exists"
    "--skip=compat::tests::test_read_enum"
    "--skip=compat::tests::test_struct_has_field"
    "--skip=cpumask"
    "--skip=topology"
    "--skip=proc_data::tests::test_thread_operations"
  ];

  passthru.tests.basic = nixosTests.scx;
  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Sched-ext Rust userspace schedulers";
    longDescription = ''
      This includes Rust based schedulers such as
      scx_rustland, scx_bpfland, scx_lavd, scx_layered, scx_rlfifo.

      ::: {.note}
      Sched-ext schedulers are only available on kernels version 6.12 or later.
      It is recommended to use the latest kernel for the best compatibility.
      :::
    '';

    homepage = "https://github.com/sched-ext/scx/tree/main/scheds/rust";
    changelog = "https://github.com/sched-ext/scx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    badPlatforms = ["aarch64-linux"];
    maintainers = with lib.maintainers; [
      johnrtitor
      Gliczy
    ];
  };
})
