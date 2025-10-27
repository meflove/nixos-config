{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.cli.zellij;
in {
  options.${namespace}.home.cli.zellij = {
    enable =
      lib.mkEnableOption "enable zellij configuration"
      // {
        default = config.${namespace}.home.cli.fishShell.enable;
      };
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        # Appearance
        session_name = "angeldust";
        attach_to_session = true;
        theme = "catppuccin-mocha";
        pane_frames = false;
        simplified_ui = false;
        styled_underlines = true;
        ui.pane_frames.rounded_corners = true;

        # Behavior
        auto_layout = true;
        default_cwd = "~";
        default_layout = "default";
        default_shell = "fish";
        mouse_mode = true;
        show_release_notes = true;
        show_startup_tips = false;
        support_kitty_keyboard_protocol = true;

        # Clipboard & Scrolling
        copy_on_select = true;
        scroll_buffer_size = 10000;
        scrollback_editor = "nvim";
        scrollback_lines_to_serialize = 10000;

        # Session Management
        mirror_session = true;
        serialize_pane_viewport = true;
        session_serialization = true;
      };

      themes = import ./themes.nix;

      layouts = import ./layouts.nix;

      extraConfig = builtins.readFile ./bindsAndPlugins.kdl;
    };
  };
}
