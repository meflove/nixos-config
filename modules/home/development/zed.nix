{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.development.zed;
in {
  options.home.${namespace}.development.zed = {
    enable =
      lib.mkEnableOption "enable Zed editor configuration"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;

      userSettings = {
        # Отключение Copilot, как в вашем шаблоне
        # features.copilot = false;
        # telemetry.metrics = false;
        # vim_mode = false;

        debugger = {
          dock = "bottom";
        };

        agent = {
          dock = "left";
        };

        edit_predictions = {
          mode = "subtle";
          copilot = {
            proxy = null;
            proxy_no_verify = null;
            enterprise_uri = null;
          };
          enabled_in_text_threads = false;
        };

        #  Aparência (temas, fonte, wrap)
        icon_theme = "Material Icon Theme";
        theme = "Catppuccin Espresso (Blur) [Light]";
        buffer_font_family = "JetBrainsMono Nerd Font";
        buffer_font_size = 16;
        wrap_guides = [
          80
          120
        ];
        soft_wrap = "editor_width";
        ui_font_size = 17; # Ваш JSON 17, в шаблоне 16

        #  Preferências gerais
        diagnostics_max_severity = "hint";

        inlay_hints = {
          # enabled = true; # Закомментированная строка
          show_type_hints = true;
          show_parameter_hints = true;
          show_other_hints = true;
          show_background = false;
          edit_debounce_ms = 700;
          scroll_debounce_ms = 50;
          toggle_on_modifiers_press = {
            control = true;
          };
          show_value_hints = true;
        };

        #  Barra de status (bottom bar)
        status_bar = {
          active_language_button = true; # mostra linguagem ativa (TS, JS, etc.)
          cursor_position_button = false; # mostra linha e coluna do cursor
        };

        # Tabs (abas dos arquivos)
        tab_bar = {
          show = true;
          show_nav_history_buttons = false;
          show_tab_bar_buttons = false;
        };

        tab_size = 2;

        tabs = {
          close_position = "right";
          file_icons = true;
          git_status = true;
          activate_on_close = "neighbour";
          show_close_button = "hover";
          show_diagnostics = "all";
        };

        #  Title Bar (top bar do Zed)
        title_bar = {
          show_branch_icon = true;
          show_branch_name = false;
          show_project_items = false;
          show_onboarding_banner = false;
          show_user_picture = false;
          show_sign_in = true;
          show_menus = false;
        };

        # Toolbar (equivalente Command Palette fixo)
        toolbar = {
          breadcrumbs = true;
          quick_actions = true;
          selections_menu = true;
          agent_review = true;
        };

        #  Minimap
        minimap = {
          show = "never"; # desliga minimap
          thumb = "always"; # mostra "thumb" (indicador do scroll)
          thumb_border = "left_open"; # estilo da borda do thumb
          current_line_highlight = null; # não destaca a linha atual no minimap
        };

        #  Git
        git = {
          git_gutter = "tracked_files";
          inline_blame = {
            enabled = true;
            show_commit_summary = true;
            padding = 7;
          };
          branch_picker = {
            show_author_name = true;
          };
          hunk_style = "unstaged_hollow";
        };

        #  Editor (cursor, indentação, whitespaces)
        cursor_blink = true;
        show_whitespaces = "none";

        indent_guides = {
          enabled = true;
          line_width = 1;
          active_line_width = 0;
          coloring = "indent_aware";
          background_coloring = "disabled";
        };

        # Explorer / Project Panel
        project_panel = {
          button = false;
          default_width = 240;
          folder_icons = false;
          # hide_root = true; # Закомментированная строка
          indent_size = 20;
          auto_fold_dirs = false;
          drag_and_drop = true;
          git_status = true;
          auto_reveal_entries = true;
          entry_spacing = "comfortable";
          starts_open = true;
          scrollbar = {
            show = null;
          };
          indent_guides = {
            show = "always";
          };
        };

        collaboration_panel = {
          button = false;
        };

        outline_panel = {
          button = false;
          default_width = 300;
          file_icons = true;
          folder_icons = true;
          git_status = true;
          indent_size = 20;
          auto_reveal_entries = true;
          auto_fold_dirs = true;
          indent_guides = {
            show = "always";
          };
          scrollbar = {
            show = null;
          };
        };

        terminal = {
          alternate_scroll = "off";
          blinking = "on";
          copy_on_select = false;
          keep_selection_on_copy = false;
          dock = "bottom";
          default_width = 640;
          default_height = 320;
          env = {
            FIG_NEW_SESSION = "1";
            Q_NEW_SESSION = "1";
          };
          detect_venv = {
            on = {
              directories = [
                ".env"
                "env"
                ".venv"
                "venv"
              ];
              activate_script = "default";
            };
          };
          font_size = 15;
          line_height = "comfortable";
          minimum_contrast = 45;
          button = false;
          shell = "system";
          toolbar = {
            breadcrumbs = false;
          };
          working_directory = "current_project_directory";
          scrollbar = {
            show = null;
          };
        };

        # cursor_shape = "underline"; # Закомментированная строка
        scrollbar = {
          show = "never";
          cursors = true;
        };

        #  Tipos de arquivo
        file_types = {
          css = ["*.css"];
          json = [".prettierrc"];
          dotenv = [".env.*"];
        };

        # Дополнительные поля из вашего шаблона, которые отсутствуют в JSON
        # vim_mode = false;
      };
    };
  };
}
