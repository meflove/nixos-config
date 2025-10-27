{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.cli.fastfetch;
in {
  options.${namespace}.home.cli.fastfetch = {
    enable =
      lib.mkEnableOption "enable fastfetch configuration"
      // {
        default = config.${namespace}.home.cli.fishShell.enable;
      };
  };

  config = mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;

      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

        logo = {
          padding = {
            top = 0;
            left = 0;
          };
          source = "nixos";
          color = {
            "1" = "magenta";
          };
        };

        modules = [
          {
            type = "os";
            key = "╭─";
            keyColor = "blue";
          }
          {
            type = "kernel";
            key = "├─";
            keyColor = "blue";
          }
          {
            type = "uptime";
            key = "├─󰅐";
            keyColor = "blue";
          }
          {
            type = "media";
            key = "╰─󰝚";
            keyColor = "blue";
          }
          "break"
          {
            type = "packages";
            key = "╭─󰏖";
            keyColor = "red";
          }
          {
            type = "shell";
            key = "├─";
            keyColor = "red";
          }
          {
            type = "display";
            key = "├─󰍹";
            keyColor = "red";
          }
          "de"
          {
            type = "wm";
            key = "├─";
            keyColor = "red";
          }
          {
            type = "terminal";
            key = "╰─";
            keyColor = "red";
            format = "{pretty-name} {version} {#37}█{#97}█ {#36}█{#96}█ {#35}█{#95}█ {#34}█{#94}█ {#33}█{#93}█ {#32}█{#92}█ {#31}█{#91}█ {#30}█{#90}█";
          }
          "break"
          {
            type = "cpu";
            format = "{name}";
            showPeCoreCount = true;
            temp = true;
            key = "╭─󰻠";
            keyColor = "magenta";
          }
          {
            type = "gpu";
            format = "{name}";
            temp = true;
            key = "├─󰍛";
            keyColor = "magenta";
          }
          {
            type = "memory";
            key = "├─󰑭";
            keyColor = "magenta";
          }
          {
            type = "disk";
            key = "├─";
            keyColor = "magenta";
          }
          {
            type = "publicip";
            key = "├─󰩠";
            keyColor = "magenta";
            timeout = 500;
          }
          {
            type = "localip";
            key = "├─󰩟";
            compact = true;
            keyColor = "magenta";
          }
          {
            type = "wifi";
            key = "╰─";
            format = "{ssid}";
            keyColor = "magenta";
          }
        ];
      };
    };
  };
}
