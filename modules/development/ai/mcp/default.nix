{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      config,
      ...
    }: {
      hm = {
        sops.secrets = lib.flattenSecrets {
          github = {
            github_pat = {};
          };
          mcp = {
            context7_api_key = {};
            huggingface_api_key = {};
          };
        };

        programs.mcp = {
          enable = true;
          servers = {
            context7 = {
              type = "http";
              url = "https://mcp.context7.com/mcp";
              headers = {
                CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
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
                GITHUB_PERSONAL_ACCESS_TOKEN.file = config.hm.sops.secrets."github/github_pat".path;
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

            mcp-read-website-fast = {
              command = "${lib.getExe' pkgs.bun "bunx"}";
              args = [
                "-y"
                "@just-every/mcp-read-website-fast"
              ];
            };
          };
        };
      };
    };
  };
}
