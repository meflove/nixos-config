{
  inputs,
  pkgs,
  lib,
  config,
  namespace,
  system,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.development.nvim;
in {
  options.${namespace}.home.development.nvim = {
    enable =
      lib.mkEnableOption "enable Neovim configuration"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.angeldust-nixCats.packages.${system}.default
      neovim
      statix
    ];

    editorconfig = {
      enable = true;

      settings = {
        "*" = {
          charset = "utf-8";
          end_of_line = "lf";
          trim_trailing_whitespace = true;
          insert_final_newline = true;
          max_line_width = 100;
          indent_style = "space";
          indent_size = 2;
        };

        "*.rs" = {
          indent_size = 4;
        };
      };
    };

    xdg.configFile."nvim-og" = {
      recursive = true;
      source = ./nvim;
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      NVIM_APPNAME = "nvim-og";
    };
  };
}
