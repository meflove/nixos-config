{config, ...}: let
  c = config.lib.stylix.colors.withHashtag;

  # Fonts from system
  fontName = config.stylix.fonts.monospace.name;
  fontSize = 16;

  rounding = "14px";
in
  # css
  ''
    * {
      font-family: "${fontName}", "Material Design Icons Desktop";
      font-size: ${toString fontSize}px;
      font-weight: bold;
    }

    window#waybar {
      background-color: ${c.base00};

      color: ${c.base05};
    }

    window#waybar > box {
      margin: 5px 0px 0px 0px;
      background-color: ${c.base00};
      border-right: 3px solid ${c.base01};
    }

    tooltip {
      background: ${c.base00};
      border: 1px solid ${c.base01};
      border-radius: 16px;
    }

    tooltip label {
      color: ${c.base05};
    }

    /* workspaces */
    #workspaces button {
      background-color: ${c.base02};
      border-radius: ${rounding};
      margin: 4px;
      padding: 2px;
      color: ${c.base05};
      min-height: 32px;
      transition: all 0.4s ease-in-out;
    }

    #workspaces button label {
      color: ${c.base05};
      font-weight: bolder;
    }

    #workspaces button.empty {
      background: ${c.base01};
    }

    #workspaces button.active {
      background: radial-gradient(circle,
        ${c.base0C} 0%,
        ${c.base0E} 50%,
        ${c.base0D} 100%
      );
      background-size: 400% 400%;
      animation: gradient 5s linear infinite;
      transition: all 0.3s ease-in-out;
      border-color: ${c.base00};
    }

    #workspaces button.active label {
      color: ${c.base02};
      font-weight: bolder;
    }

    @keyframes gradient {
      0% { background-position: 0px 50px; }
      50% { background-position: 100px 30px; }
      100% { background-position: 0px 50px; }
    }

    /* modules */
    #backlight,
    #bluetooth,
    #battery,
    #cava,
    #clock,
    #custom-date,
    #custom-launcher,
    #custom-power,
    #custom-separator,
    #disk,
    #language,
    #network,
    #pulseaudio,
    #tray {
      color: ${c.base05};
      background-color: ${c.base00};
      padding: 0 0.4em;
      padding-top: 0px;
      padding-bottom: 2px;
      border-style: solid;
      min-height: 30px;
    }

    #workspaces {
      margin: 3 0 3 0px;
      border-radius: 14 14 14 14px;
    }

    /* module specific styles */
    #pulseaudio {
      color: ${c.base0D};
    }

    #network {
      color: ${c.base0A};
    }

    #bluetooth {
      color: ${c.base0E};
    }

    #clock {
      color: ${c.base05};
    }

    #disk {
      color: ${c.base0C};
    }

    /* groups */
    .soundGrp,
    .musicGrp,
    .blueGrp,
    .dateGrp,
    .trayGrp {
      margin: 4px;
      border-radius: ${rounding};
    }

    /* tray */
    #tray {
      padding: 0 5px;
    }

    #tray menu {
      padding: 2px;
      border-radius: 0;
    }
  ''
