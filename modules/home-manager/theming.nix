{ pkgs, ... }: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "JetBrainsMono NF SemiBold" ];
      sansSerif = [ "JetBrainsMono NF SemiBold" ];
      monospace = [ "JetBrainsMono NF SemiBold" ];
    };
  };

  # catppuccin.gtk.icon = {
  #   enable = true;
  #   accent = "mauve";
  #   flavor = "mocha";
  # };
  #
  # qt.style = {
  #   catppuccin.accent = "mauve";
  #   catppuccin.enable = true;
  #   catppuccin.flavor = "mocha";
  # };
}
