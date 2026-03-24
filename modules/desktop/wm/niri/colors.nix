_: let
  colors = import ../hyprland/colors.nix;
in {
  # Catppuccin Mocha colors
  base00 = "#${colors.base}"; # 1e1e2e
  base01 = "#${colors.mantle}"; # 181825
  base02 = "#${colors.crust}"; # 11111b
  base03 = "#${colors.surface0}"; # 313244
  base04 = "#${colors.surface1}"; # 45475a
  base05 = "#${colors.surface2}"; # 585b70

  base06 = "#${colors.overlay0}"; # 6c7086
  base07 = "#${colors.overlay1}"; # 7f849c
  base08 = "#${colors.overlay2}"; # 9399b2

  base09 = "#${colors.blue}"; # 89b4fa
  base0A = "#${colors.lavender}"; # b4befe
  base0B = "#${colors.sapphire}"; # 74c7ec
  base0C = "#${colors.sky}"; # 89dceb
  base0D = "#${colors.teal}"; # 94e2d5
  base0E = "#${colors.green}"; # a6e3a1
  base0F = "#${colors.yellow}"; # f9e2af

  # Semantic colors
  rosewater = "#${colors.rosewater}";
  flamingo = "#${colors.flamingo}";
  pink = "#${colors.pink}";
  mauve = "#${colors.mauve}";
  red = "#${colors.red}";
  maroon = "#${colors.maroon}";
  peach = "#${colors.peach}";
  yellow = "#${colors.yellow}";
  green = "#${colors.green}";
  teal = "#${colors.teal}";
  sky = "#${colors.sky}";
  sapphire = "#${colors.sapphire}";
  blue = "#${colors.blue}";
  lavender = "#${colors.lavender}";
  text = "#${colors.text}";
  subtext1 = "#${colors.subtext1}";
  subtext0 = "#${colors.subtext0}";
  overlay2 = "#${colors.overlay2}";
  overlay1 = "#${colors.overlay1}";
  overlay0 = "#${colors.overlay0}";
  surface2 = "#${colors.surface2}";
  surface1 = "#${colors.surface1}";
  surface0 = "#${colors.surface0}";
  base = "#${colors.base}";
  mantle = "#${colors.mantle}";
  crust = "#${colors.crust}";
}
