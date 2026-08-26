{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      hm.services.mako = {
        enable = true;
        settings = {
          anchor = "top-right";
          width = 350;
          height = 300;
          max-visible = 5;
          margin = 12;
          outer-margin = 23;
          padding = "12,20";
          border-size = 1;
          sort = "+time";
          output = ''""'';

          markup = 1;
          format = "<small>%a</small>\\n<b>%s</b>\\n%b";
          text-alignment = "left";

          icon-location = "left";
          max-icon-size = 80;
          icon-border-radius = 4;

          border-radius = 10;

          on-button-left = "dismiss";
          on-button-middle = "invoke-default-action";
          on-button-right = "dismiss-all";

          "app-name=kitty summary~=^4;" = {
            invisible = 1;
          };
        };
      };
    };
  };
}
