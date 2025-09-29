{ inputs, pkgs, ... }:
{
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    package = inputs.hyprpanel.packages.${pkgs.system}.default;

    settings = {
      tear = true;
      bar = {
        media = {
          truncation_size = 31;
        };
        network = {
          truncation_size = 11;
        };
        customModules = {
          updates = {
            pollingInterval = 1440000;
          };
          ram = {
            leftClick = "ghostty -e btop";
            labelType = "percentage";
            pollingInterval = 2000;
          };
          cpu = {
            leftClick = "ghostty -e btop";
            pollingInterval = 2000;
          };
          kbLayout = {
            labelType = "code";
            leftClick = "hyprctl switchxkblayout logitech-g102-lightsync-gaming-mouse-keyboard next";
          };
          weather = {
            unit = "metric";
          };
          storage = {
            paths = [ "/" ];
          };
          cava = {
            bars = 10;
          };
        };
        layouts = {
          "0" = {
            left = [
              "dashboard"
              "windowtitle"
            ];
            middle = [
              "ram"
              "cpu"
              "media"
              "workspaces"
              "clock"
            ];
            right = [
              "systray"
              "kbinput"
              "volume"
              "notifications"
            ];
          };
          "1" = {
            left = [
              "dashboard"
              "windowtitle"
            ];
            middle = [
              "ram"
              "cpu"
              "media"
              "workspaces"
              "clock"
            ];
            right = [
              "systray"
              "kbinput"
              "network"
              "bluetooth"
              "volume"
              "notifications"
            ];
          };
        };
        workspaces = {
          workspaceIconMap = {
            "1" = {
              icon = "";
              color = "#5865F2";
            };
            "2" = {
              icon = "";
              color = "#2EBCD8";
            };
            "3" = {
              icon = "";
              color = "#F7E0AD";
            };
          };
          show_icons = false;
          showWsIcons = true;
        };
        clock = {
          format = "%d/%m/%y  %H:%M:%S";
        };
      };
      menus = {
        dashboard = {
          controls.enabled = false;
          shortcuts = {
            enabled = false;
            left = {
              shortcut1 = {
                command = "zen-twilight";
                tooltip = "Zen Browser";
              };
              shortcut2 = {
                command = "spotify-launcher";
              };
              shortcut3 = {
                command = "discord";
              };
            };
          };
          powermenu = {
            avatar = {
              image = "/home/angeldust/Pictures/";
            };
          };
          stats = {
            enable_gpu = true;
          };
          directories = {
            enabled = false;
            right = {
              directory2 = {
                label = "󰉏 Images";
                command = ''bash -c "xdg-open $HOME/Pictures/"'';
              };
            };
          };
        };
        clock = {
          time = {
            military = true;
            hideSeconds = false;
          };
          weather = {
            location = "Barnaul";
            unit = "metric";
          };
        };
        media = {
          displayTimeTooltip = true;
          displayTime = true;
          hideAuthor = false;
          hideAlbum = true;
        };
        transition = "crossfade";
      };
      scalingPriority = "hyprland";
      notifications = {
        showActionsOnHover = true;
      };
      terminal = "ghostty";

      theme = {
        bar = {
          floating = true;
          menus = {
            opacity = 100;
            menu = {
              notifications = {
                scrollbar = {
                  color = "#bb9af7";
                };
                pager = {
                  label = "#565f89";
                  button = "#bb9af7";
                  background = "#1a1b26";
                };
                switch = {
                  puck = "#565f89";
                  disabled = "#565f89";
                  enabled = "#bb9af7";
                };
                clear = "#f7768e";
                switch_divider = "#414868";
                border = "#414868";
                card = "#24283b";
                background = "#1a1b26";
                no_notifications_label = "#414868";
                label = "#bb9af7";
              };
              power = {
                scaling = 100;
                buttons = {
                  sleep = {
                    icon = "#1a1b26";
                    text = "#7dcfff";
                    icon_background = "#7dcfff";
                    background = "#24283b";
                  };
                  logout = {
                    icon = "#1a1b26";
                    text = "#9ece6a";
                    icon_background = "#9ece6a";
                    background = "#24283b";
                  };
                  restart = {
                    icon = "#1a1b26";
                    text = "#e0af68";
                    icon_background = "#e0af68";
                    background = "#24283b";
                  };
                  shutdown = {
                    icon = "#1a1b26";
                    text = "#f7768e";
                    icon_background = "#f7768e";
                    background = "#24283b";
                  };
                };
                border = {
                  color = "#414868";
                };
                background = {
                  color = "#1a1b26";
                };
              };
              dashboard = {
                monitors = {
                  disk = {
                    label = "#f7768e";
                    bar = "#f7768e";
                    icon = "#f7768e";
                  };
                  gpu = {
                    label = "#9ece6a";
                    bar = "#9ece6a";
                    icon = "#9ece6a";
                  };
                  ram = {
                    label = "#e0af68";
                    bar = "#e0af68";
                    icon = "#e0af68";
                  };
                  cpu = {
                    label = "#f7768e";
                    bar = "#f7768e";
                    icon = "#f7768e";
                  };
                  bar_background = "#414868";
                };
                directories = {
                  right = {
                    bottom = {
                      color = "#bb9af7";
                    };
                    middle = {
                      color = "#bb9af7";
                    };
                    top = {
                      color = "#73daca";
                    };
                  };
                  left = {
                    bottom = {
                      color = "#f7768e";
                    };
                    middle = {
                      color = "#e0af68";
                    };
                    top = {
                      color = "#f7768e";
                    };
                  };
                };
                controls = {
                  input = {
                    text = "#1a1b26";
                    background = "#f7768e";
                  };
                  volume = {
                    text = "#1a1b26";
                    background = "#f7768e";
                  };
                  notifications = {
                    text = "#1a1b26";
                    background = "#e0af68";
                  };
                  bluetooth = {
                    text = "#1a1b26";
                    background = "#7dcfff";
                  };
                  wifi = {
                    text = "#1a1b26";
                    background = "#bb9af7";
                  };
                  disabled = "#414868";
                };
                shortcuts = {
                  recording = "#9ece6a";
                  text = "#1a1b26";
                  background = "#bb9af7";
                };
                powermenu = {
                  confirmation = {
                    button_text = "#1a1b26";
                    deny = "#f7768e";
                    confirm = "#9ece6a";
                    body = "#c0caf5";
                    label = "#bb9af7";
                    border = "#414868";
                    background = "#1a1b26";
                    card = "#24283b";
                  };
                  sleep = "#7dcfff";
                  logout = "#9ece6a";
                  restart = "#e0af68";
                  shutdown = "#f7768e";
                };
                profile = {
                  name = "#f7768e";
                };
                border = {
                  color = "#414868";
                };
                background = {
                  color = "#1a1b26";
                };
                card = {
                  color = "#24283b";
                };
              };
              clock = {
                weather = {
                  hourly = {
                    temperature = "#f7768e";
                    icon = "#f7768e";
                    time = "#f7768e";
                  };
                  thermometer = {
                    extremelycold = "#7dcfff";
                    cold = "#7aa2f7";
                    moderate = "#bb9af7";
                    hot = "#e0af68";
                    extremelyhot = "#f7768e";
                  };
                  stats = "#f7768e";
                  status = "#73daca";
                  temperature = "#c0caf5";
                  icon = "#f7768e";
                };
                calendar = {
                  contextdays = "#414868";
                  days = "#c0caf5";
                  currentday = "#f7768e";
                  paginator = "#f7768e";
                  weekdays = "#f7768e";
                  yearmonth = "#73daca";
                };
                time = {
                  timeperiod = "#73daca";
                  time = "#f7768e";
                };
                text = "#c0caf5";
                border = {
                  color = "#414868";
                };
                background = {
                  color = "#1a1b26";
                };
                card = {
                  color = "#24283b";
                };
              };
              battery = {
                slider = {
                  puck = "#565f89";
                  backgroundhover = "#414868";
                  background = "#565f89";
                  primary = "#e0af68";
                };
                icons = {
                  active = "#e0af68";
                  passive = "#565f89";
                };
                listitems = {
                  active = "#e0af68";
                  passive = "#c0caf5";
                };
                text = "#c0caf5";
                label = {
                  color = "#e0af68";
                };
                border = {
                  color = "#414868";
                };
                background = {
                  color = "#1a1b26";
                };
                card = {
                  color = "#24283b";
                };
              };
              systray = {
                dropdownmenu = {
                  divider = "#24283b";
                  text = "#c0caf5";
                  background = "#1a1b26";
                };
              };
              bluetooth = {
                iconbutton = {
                  active = "#7dcfff";
                  passive = "#c0caf5";
                };
                icons = {
                  active = "#7dcfff";
                  passive = "#565f89";
                };
                listitems = {
                  active = "#7dcfff";
                  passive = "#c0caf5";
                };
                switch = {
                  puck = "#565f89";
                  disabled = "#565f89";
                  enabled = "#7dcfff";
                };
                switch_divider = "#414868";
                status = "#565f89";
                text = "#c0caf5";
                label = {
                  color = "#7dcfff";
                };
                border = {
                  color = "#414868";
                };
                background = {
                  color = "#1a1b26";
                };
                card = {
                  color = "#24283b";
                };
                scroller = {
                  color = "#7dcfff";
                };
              };
              network = {
                iconbuttons = {
                  active = "#bb9af7";
                  passive = "#c0caf5";
                };
                icons = {
                  active = "#bb9af7";
                  passive = "#565f89";
                };
                listitems = {
                  active = "#bb9af7";
                  passive = "#c0caf5";
                };
                status = {
                  color = "#565f89";
                };
                text = "#c0caf5";
                label = {
                  color = "#bb9af7";
                };
                border = {
                  color = "#414868";
                };
                background = {
                  color = "#1a1b26";
                };
                card = {
                  color = "#24283b";
                };
                switch = {
                  enabled = "#bb9af7";
                  disabled = "#565f89";
                  puck = "#565f89";
                };
                scroller = {
                  color = "#bb9af7";
                };
              };
              volume = {
                input_slider = {
                  puck = "#414868";
                  backgroundhover = "#414868";
                  background = "#565f89";
                  primary = "#f7768e";
                };
                audio_slider = {
                  puck = "#414868";
                  backgroundhover = "#414868";
                  background = "#565f89";
                  primary = "#f7768e";
                };
                icons = {
                  active = "#f7768e";
                  passive = "#565f89";
                };
                iconbutton = {
                  active = "#f7768e";
                  passive = "#c0caf5";
                };
                listitems = {
                  active = "#f7768e";
                  passive = "#c0caf5";
                };
                text = "#c0caf5";
                label = {
                  color = "#f7768e";
                };
                border = {
                  color = "#414868";
                };
                background = {
                  color = "#1a1b26";
                };
                card = {
                  color = "#24283b";
                };
              };
              media = {
                slider = {
                  puck = "#565f89";
                  backgroundhover = "#414868";
                  background = "#565f89";
                  primary = "#f7768e";
                };
                buttons = {
                  text = "#1a1b26";
                  background = "#bb9af7";
                  enabled = "#73daca";
                  inactive = "#414868";
                };
                border = {
                  color = "#414868";
                };
                card = {
                  color = "#24283b";
                };
                background = {
                  color = "#1a1b26";
                };
                album = "#f7768e";
                artist = "#73daca";
                song = "#bb9af7";
                timestamp = "#c0caf5";
              };
            };
            card_radius = "0.4em";
            popover = {
              border = "#1a1b26";
              background = "#1a1b26";
              text = "#bb9af7";
            };
            tooltip = {
              text = "#c0caf5";
              background = "#1a1b26";
            };
            dropdownmenu = {
              divider = "#24283b";
              text = "#c0caf5";
              background = "#1a1b26";
            };
            slider = {
              puck = "#565f89";
              backgroundhover = "#414868";
              background = "#565f89";
              primary = "#bb9af7";
            };
            progressbar = {
              background = "#414868";
              foreground = "#bb9af7";
            };
            iconbuttons = {
              active = "#bb9af7";
              passive = "#c0caf5";
            };
            buttons = {
              text = "#1a1b26";
              disabled = "#565f89";
              active = "#f7768e";
              default = "#bb9af7";
            };
            check_radio_button = {
              active = "#bb9af7";
              background = "#3b4261";
            };
            switch = {
              puck = "#565f89";
              disabled = "#565f89";
              enabled = "#bb9af7";
            };
            icons = {
              active = "#bb9af7";
              passive = "#414868";
            };
            listitems = {
              active = "#bb9af7";
              passive = "#c0caf5";
            };
            label = "#bb9af7";
            feinttext = "#414868";
            dimtext = "#414868";
            text = "#c0caf5";
            border = {
              color = "#414868";
            };
            cards = "#24283b";
            background = "#222336";
            monochrome = false;
          };
          buttons = {
            style = "default";
            enableBorders = false;
            borderSize = "0.08em";
            borderColor = "#bb9af7";
            modules = {
              power = {
                border = "#f7768e";
                icon_background = "#f7768e";
                icon = "#f7768e";
                background = "#272a3d";
              };
              weather = {
                border = "#bb9af7";
                icon_background = "#bb9af7";
                icon = "#bb9af7";
                text = "#bb9af7";
                background = "#272a3d";
              };
              updates = {
                border = "#bb9af7";
                icon_background = "#bb9af7";
                icon = "#bb9af7";
                text = "#bb9af7";
                background = "#272a3d";
              };
              kbLayout = {
                border = "#7dcfff";
                icon_background = "#7dcfff";
                icon = "#7dcfff";
                text = "#7dcfff";
                background = "#272a3d";
              };
              netstat = {
                border = "#9ece6a";
                icon_background = "#9ece6a";
                icon = "#9ece6a";
                text = "#9ece6a";
                background = "#272a3d";
              };
              storage = {
                border = "#f7768e";
                icon_background = "#f7768e";
                icon = "#f7768e";
                text = "#f7768e";
                background = "#272a3d";
              };
              cpu = {
                border = "#f7768e";
                icon_background = "#f7768e";
                icon = "#f7768e";
                text = "#f7768e";
                background = "#272a3d";
              };
              ram = {
                border = "#e0af68";
                icon_background = "#e0af68";
                icon = "#e0af68";
                text = "#e0af68";
                background = "#272a3d";
              };
              notifications = {
                border = "#bb9af7";
                total = "#bb9af7";
                icon_background = "#bb9af7";
                icon = "#bb9af7";
                background = "#272a3d";
              };
              clock = {
                border = "#f7768e";
                icon_background = "#f7768e";
                icon = "#f7768e";
                text = "#f7768e";
                background = "#272a3d";
              };
              battery = {
                border = "#e0af68";
                icon_background = "#e0af68";
                icon = "#e0af68";
                text = "#e0af68";
                background = "#272a3d";
              };
              systray = {
                border = "#414868";
                background = "#272a3d";
                customIcon = "#c0caf5";
              };
              bluetooth = {
                border = "#7dcfff";
                icon_background = "#89dbeb";
                icon = "#7dcfff";
                text = "#7dcfff";
                background = "#272a3d";
              };
              network = {
                border = "#bb9af7";
                icon_background = "#caa6f7";
                icon = "#bb9af7";
                text = "#bb9af7";
                background = "#272a3d";
              };
              volume = {
                border = "#f7768e";
                icon_background = "#f7768e";
                icon = "#f7768e";
                text = "#f7768e";
                background = "#272a3d";
              };
              media = {
                border = "#bb9af7";
                icon_background = "#bb9af7";
                icon = "#bb9af7";
                text = "#bb9af7";
                background = "#272a3d";
              };
              windowtitle = {
                border = "#f7768e";
                icon_background = "#f7768e";
                icon = "#f7768e";
                text = "#f7768e";
                background = "#272a3d";
              };
              workspaces = {
                border = "#f7768e";
                numbered_active_underline_color = "#c678dd";
                numbered_active_highlighted_text_color = "#181825";
                active = "#f7768e";
                occupied = "#f7768e";
                available = "#7dcfff";
                hover = "#414868";
                background = "#272a3d";
              };
              dashboard = {
                border = "#e0af68";
                icon = "#e0af68";
                background = "#272a3d";
              };
              submap = {
                background = "#272a3d";
                text = "#73daca";
                border = "#73daca";
                icon = "#73daca";
                icon_background = "#272a3d";
              };
              hyprsunset = {
                icon = "#e0af68";
                background = "#272a3d";
                icon_background = "#e0af68";
                text = "#e0af68";
                border = "#e0af68";
              };
              hypridle = {
                icon = "#f7768e";
                background = "#272a3d";
                icon_background = "#f7768e";
                text = "#f7768e";
                border = "#f7768e";
              };
              cava = {
                text = "#73daca";
                background = "#272a3d";
                icon_background = "#272a3d";
                icon = "#73daca";
                border = "#73daca";
              };
            };
            icon = "#bb9af7";
            text = "#bb9af7";
            hover = "#414868";
            icon_background = "#272a3d";
            background = "#272a3d";
            monochrome = false;
          };
          opacity = 0;
          background = "#1a1b26";
          transparent = true;
          scaling = 95;
          border = {
            color = "#bb9af7";
          };
        };
        font = {
          weight = 600;
        };
        osd = {
          label = "#bb9af7";
          icon = "#1a1b26";
          bar_overflow_color = "#f7768e";
          bar_empty_color = "#414868";
          bar_color = "#bb9af7";
          icon_container = "#bb9af7";
          bar_container = "#1a1b26";
          margins = "7px 7px 7px 7px";
        };
        notification = {
          close_button = {
            label = "#1a1b26";
            background = "#f7768e";
          };
          labelicon = "#bb9af7";
          text = "#c0caf5";
          time = "#9aa5ce";
          border = "#565f89";
          label = "#bb9af7";
          actions = {
            text = "#24283b";
            background = "#bb9af7";
          };
          background = "#1a1b26";
        };
        matugen = false;
        matugen_settings = {
          mode = "dark";
          scheme_type = "expressive";
          variation = "standard_1";
          contrast = 0;
        };
      };

    };
  };
}
