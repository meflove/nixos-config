{ ... }:
{
  programs.ghostty = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      theme = "tokyo-night";

      font-family = "JetBrainsMono NF SemiBold";
      font-family-bold = "JetBrainsMono NF Bold";
      font-family-italic = "JetBrainsMono NF SemiBold Italic";
      font-family-bold-italic = "JetBrainsMono NF Bold Italic";
      font-size = 12;
      adjust-cell-height = "15%";

      window-theme = "ghostty";
      window-colorspace = "display-p3";

      gtk-titlebar = "false";

      confirm-close-surface = "false";

      cursor-style = "block";
      mouse-scroll-multiplier = "0.5";
      shell-integration-features = "no-cursor";

      link-url = "true";

      window-padding-x = 9;
      window-padding-y = 9;

    };

    themes = {
      tokyo-night = {
        background = "222436";
        foreground = "c8d3f5";

        palette = [
          "0=#1b1d2b"
          "8=#444a73"

          "1=#ff757f"
          "9=#ff757f"

          "2=#c3e88d"
          "10=#c3e88d"

          "3=#ffc777"
          "11=#ffc777"

          "4=#82aaff"
          "12=#82aaff"

          "5=#c099ff"
          "13=#c099ff"

          "6=#86e1fc"
          "14=#86e1fc"

          "7=#828bb8"
          "15=#c8d3f5"
        ];
      };
    };
  };
}
