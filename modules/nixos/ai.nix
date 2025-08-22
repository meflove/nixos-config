{ ... }:
{
  services.ollama = {
    enable = false;
    acceleration = "cuda";

    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "30";
    };

    loadModels = [
      "llama3.2:latest"
      "gpt-oss:20b"
    ];
  };

  services.open-webui.enable = false;
}
