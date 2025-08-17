{ ... }: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";

    loadModels = [ "llama3.2:latest" "deepseek-r1:latest" "gpt-oss:20b" ];
  };

  services.open-webui.enable = true;
}
