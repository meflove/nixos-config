{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "slit";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "tigrawap";
    repo = "slit";
    rev = "master";
    hash = "sha256-Gjw1dRrgM8D3G7v6WIM2+50r4HmTXvx0Xxme2fH9TlQ=";
  };

  vendorHash = "sha256-6hCgv2/8UIRHw1kCe3nLkxF23zE/7t5RDwEjSzX3pBQ=";

  meta = with lib; {
    description = "A modern PAGER for viewing logs, get more than most in less time. Written in Go";
    homepage = "https://github.com/tigrawap/slit";
    license = licenses.mit;
    maintainers = with maintainers; [angeldust];
  };
}
