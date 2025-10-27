{
  pkgs,
  stdenv,
  ...
}:
#TODO
# check script
stdenv.mkDerivation {
  pname = "install-nixos";
  version = "1.0.0";
  src = ./.;
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cat << 'EOF' > $out/bin/install-nixos
    #!${pkgs.bash}/bin/bash
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#pcDisk

    read -p "Enter pass for transcrypt: " pass
    ${pkgs.transcrypt}/bin/transcrypt -c aes-256-cbc -p "''${pass}"

    sudo nixos-install --flake .#nixos-pc
    EOF

    chmod +x $out/bin/install-nixos
  '';
}
