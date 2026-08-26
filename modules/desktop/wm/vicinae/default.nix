{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      hm = {
        programs.vicinae = {
          enable = true;
          systemd = {
            enable = true;
          };

          settings = {
            font = {
              rendering = "native";
              normal = {
              };
            };
            launcher_window = {
              client_side_decorations = {
                enabled = true;
              };
              material = "blur";
            };
            providers = {
              clipboard = {
                entrypoints = {
                  clear = {
                    enabled = false;
                  };
                  clear-history = {
                    enabled = false;
                  };
                };
              };
              core = {
                entrypoints = {
                  about = {
                    enabled = false;
                  };
                  documentation = {
                    enabled = false;
                  };
                  inspect-local-storage = {
                    enabled = true;
                  };
                  open-config-file = {
                    enabled = false;
                  };
                  open-default-config = {
                    enabled = false;
                  };
                  refresh-apps = {
                    enabled = false;
                  };
                  report-bug = {
                    enabled = false;
                  };
                  sponsor = {
                    enabled = false;
                  };
                };
              };
              power = {
                entrypoints = {
                  hibernate = {
                    enabled = false;
                  };
                  logout = {
                    enabled = false;
                  };
                  sleep = {
                    enabled = false;
                  };
                  soft-reboot = {
                    enabled = false;
                  };
                  suspend = {
                    enabled = false;
                  };
                };
              };
              raycast-compat = {
                entrypoints = {
                  store = {
                    enabled = true;
                  };
                };
              };
              system = {
                entrypoints = {
                  browse-apps = {
                    enabled = true;
                  };
                  toggle-mute = {
                    enabled = false;
                  };
                  volume-0 = {
                    enabled = false;
                  };
                  volume-100 = {
                    enabled = false;
                  };
                  volume-25 = {
                    enabled = false;
                  };
                  volume-50 = {
                    enabled = false;
                  };
                  volume-75 = {
                    enabled = false;
                  };
                  volume-down = {
                    enabled = false;
                  };
                  volume-up = {
                    enabled = false;
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
