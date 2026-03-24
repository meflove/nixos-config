{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
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
          };
        };
      };
    };
  };
}
