{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.development.mcp;
in {
  options.home.${namespace}.development.mcp = {
    enable =
      lib.mkEnableOption ''
        enable mcp servers configuration
      ''
      // {default = config.home.${namespace}.development.claude.enable || config.home.${namespace}.development.gemini.enable;};
  };

  config = mkIf cfg.enable {
    sops.secrets = lib.angl.flattenSecrets {
      github = {
        github_pat = {};
      };
      mcp = {
        context7_api_key = {};
        huggingface_api_key = {};
        brightdata_api_key = {};
      };
    };

    programs.mcp = {
      enable = true;
      servers = {
        context7 = {
          type = "http";
          url = "https://mcp.context7.com/mcp";
          headers = {
            CONTEXT7_API_KEY = "\${CONTEXT7_API_KEY}";
          };
        };

        github = {
          command = "${lib.getExe pkgs.podman}";
          args = [
            "run"
            "-i"
            "--rm"
            "-e"
            "GITHUB_PERSONAL_ACCESS_TOKEN"
            "ghcr.io/github/github-mcp-server"
          ];
          env = {
            GITHUB_PERSONAL_ACCESS_TOKEN = "\${GITHUB_PERSONAL_ACCESS_TOKEN}";
          };
        };

        nixos = {
          command = "${lib.getExe pkgs.podman}";
          args = [
            "run"
            "--rm"
            "-i"
            "ghcr.io/utensils/mcp-nixos"
          ];
        };

        huggingface = {
          type = "http";
          url = "https://huggingface.co/mcp";
          headers = {
            Authorization = "Bearer \${HUGGINGFACE_API_KEY}";
          };
        };

        mcp-read-website-fast = {
          command = "${lib.getExe' pkgs.bun "bunx"}";
          args = ["-y" "@just-every/mcp-read-website-fast"];
        };

        BrightData = {
          command = "${lib.getExe' pkgs.bun "bunx"}";
          args = ["-y" "@brightdata/mcp"];
          env = {
            "API_TOKEN" = "\${BRIGHTDATA_API_KEY}";
          };
        };
      };
    };
  };
}
