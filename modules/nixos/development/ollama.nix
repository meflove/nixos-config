{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.development.ollama;
in {
  options.${namespace}.nixos.development.ollama = {
    enable =
      lib.mkEnableOption "enable Ollama AI service and disable Open Web UI"
      // {
        default = false;
      };
    openWebui =
      lib.mkEnableOption "enable Open Web UI for Ollama"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = "cuda";

      environmentVariables = {
        OLLAMA_KEEP_ALIVE = "30";
      };

      loadModels = [
        "llama3.2:latest"
      ];
    };

    services.open-webui.enable = cfg.openWebui;
  };
}
