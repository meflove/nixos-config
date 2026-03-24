{
  lib,
  config,
  ...
}: {
  mainBar = let
    mkIcon = col: icon: "<span color='${col}'>${icon}</span>";
    color = import ./colors.nix;

    ico = import ./icons.nix {};
  in
    lib.mkMerge [
      {
        start_hidden = false;
        layer = "top";
        position = "left";
        spacing = 16;
        height = 1;

        "custom/spacing" = {
          tooltip = false;
          rotate = 90;

          format = " ";
        };
      }
      {
        modules-left = [
          "custom/spacing"
          "group/soundGrp"
          "group/blueGrp"
        ];

        modules-center = ["niri/workspaces"];

        modules-right = [
          "group/trayGrp"
          "niri/language"
          "group/dateGrp"
          "custom/spacing"
        ];
      }
      {
        "pulseaudio#volume" = {
          tooltip = false;
          rotate = 90;

          format = "{volume}% ";
          format-muted = "muted ";

          format-bluetooth = "{volume}% ";
          format-bluetooth-muted = "muted ";
        };

        "pulseaudio" = {
          tooltip = false;
          rotate = 90;

          format = "{format_source} / {icon}";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
            headphone = [""];
            headset = [""];
            bluetooth = "";
            bluetooth-muted = mkIcon color.base04 "󰂲";
          };
          format-muted = "{format_source} / ${mkIcon color.base04 " "}";

          format-source = "󰍬";
          format-source-muted = mkIcon color.base04 "󰍭";

          scroll-step = 5;
          max-volume = 100;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        "network" = {
          tooltip = false;
          rotate = 90;

          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-wifi = "{icon} ";
          format-ethernet = "󰈀";
          format-disconnected = "";

          interval = 5;
        };

        "niri/workspaces" = {
          tooltip = false;
          rotate = 90;

          format = "{icon}";
          format-icons =
            ico.wm
            // {
              "active" = "";
            };

          all-outputs = false;
          disable-scroll = false;
          on-click = "activate";

          persistent-workspaces."*" = lib.range 1 10;
        };

        "custom/trayLogo" = {
          tooltip = false;
          rotate = 90;

          format = "󱂫 ";
        };

        "tray" = {
          tooltip = false;
          rotate = 90;

          icon-size = 18;
          show-passive-items = true;
          spacing = 8;
        };

        "bluetooth#name" = {
          tooltip = false;
          rotate = 90;

          format = "{status}";
          format-disabled = "";

          format-connected = "{device_alias}";
          format-connected-battery = "{device_alias} ({device_battery_percentage}%)";

          max-length = 12;

          on-click = "bluetui";
          on-click-right = "bluetoothctl disconnect";
        };

        bluetooth = {
          format-disabled = "";
          format-off = "";
          format-on = "󰂯";
          format-connected = "󰂯";
          format-connected-battery = "󰂯";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias} 󰂄{device_battery_percentage}% {device_address}";
          on-click = "${lib.getExe config.hm.programs.ghostty.package} --class='com.free.bluetui' -e bluetui";
          tooltip = true;
        };

        "niri/language" = {
          tooltip = false;
          rotate = 90;

          format = "{} 󰌌";
          format-en = "en";
          format-ru = "ru";

          on-click = "niri msg action switch-layout next";
        };

        "clock#time" = {
          tooltip = false;
          rotate = 90;

          format = " 󰥔 {:%H:%M}";
          format-alt = "  {:%d.%m.%Y}";

          interval = 30;
        };
      }
      (
        let
          mkGroup = drawer: modules: {
            orientation = "inherit";
            inherit
              drawer
              modules
              ;
          };
        in {
          "group/soundGrp" =
            mkGroup
            {
              transition-duration = 300;
              children-class = "soundGrp";
              transition-left-to-right = true;
            }
            [
              "pulseaudio"
              "pulseaudio#volume"
            ];

          "group/blueGrp" =
            mkGroup
            {
              transition-duration = 300;
              children-class = "blueGrp";
              transition-left-to-right = true;
            }
            [
              "bluetooth"
              "bluetooth#name"
            ];

          "group/dateGrp" =
            mkGroup
            {
              transition-duration = 300;
              children-class = "dateGrp";
              transition-left-to-right = false;
            }
            [
              "clock#time"
            ];

          "group/trayGrp" =
            mkGroup
            {
              transition-duration = 300;
              children-class = "trayGrp";
              transition-left-to-right = false;
            }
            [
              "custom/trayLogo"
              "tray"
            ];
        }
      )
    ];
}
