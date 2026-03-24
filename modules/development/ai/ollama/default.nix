{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      services = {
        ollama = {
          enable = true;
          package = pkgs.ollama-cuda;

          environmentVariables = {
            OLLAMA_KEEP_ALIVE = "30";
          };

          loadModels = [
            "llava:13b"
          ];
        };

        open-webui.enable = true;
      };
    };
  };
}
