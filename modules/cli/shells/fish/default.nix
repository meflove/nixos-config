{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      config,
      inputs,
      ...
    }: {
      users.users.${lib.userName}.shell = config.programs.fish.package;
      programs.fish = {
        enable = true;
        package = pkgs.fish;
      };

      hm = {
        programs = {
          fish = {
            inherit (config.programs.fish) enable package;

            generateCompletions = true;

            interactiveShellInit = ''
              set fish_greeting

              # Atuin
              set -x ATUIN_NOBIND true
              bind ctrl-r _atuin_search
              bind up _atuin_bind_up
              bind \eOA _atuin_bind_up
              bind \e\[A _atuin_bind_up
              if bind -M insert >/dev/null 2>&1
                  bind -M insert ctrl-r _atuin_search
                  bind -M insert up _atuin_bind_up
                  bind -M insert \eOA _atuin_bind_up
                  bind -M insert \e\[A _atuin_bind_up
              end

              # Zellij
              set -x ZELLIJ_CONFIG_DIR "$HOME/.config/zellij"
              if test "$TERM" = "xterm-ghostty"
                  set ZELLIJ_AUTO_ATTACH true
                  eval (${lib.getExe config.hm.programs.zellij.package} setup --generate-auto-start fish | string collect)

                  ${lib.getExe config.hm.programs.fastfetch.package}
              end

              # Wayland vars for root
              if test (id -u) -eq 0
                  set -gx XDG_RUNTIME_DIR /run/user/1000
                  set -gx WAYLAND_DISPLAY wayland-1
              end
            '';

            plugins = with pkgs.fishPlugins; [
              {
                name = "done";
                inherit (done) src;
              }
              {
                name = "spark";
                inherit (spark) src;
              }
              {
                name = "autopair";
                inherit (autopair) src;
              }
              {
                name = "puffer";
                inherit (puffer) src;
              }
              {
                name = "grc";
                inherit (grc) src;
              }
              {
                name = "nvm";
                inherit (nvm) src;
              }
              {
                name = "fishtape";
                inherit (fishtape) src;
              }
              {
                name = "forgit";
                inherit (forgit) src;
              }
              {
                name = "colored-man-pages";
                inherit (colored-man-pages) src;
              }
            ];

            shellAliases = let
              ip = lib.getExe' pkgs.iproute2 "ip";
            in {
              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Системные утилиты ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              ls = "eza";
              ll = "eza -l";
              tree = "eza --tree";
              less = "less -R";
              du = lib.getExe pkgs.dust;
              df = lib.getExe pkgs.duf;
              ip = "${ip} -color=auto";
              grep = "grep --color=auto";
              cat = lib.getExe config.hm.programs.bat.package;
              x = "wl-copy";
              xv = "wl-paste";
              catt = "command cat";
              Holes = "sudo ${lib.getExe pkgs.unixtools.netstat} -tupln";
              err = "journalctl -b -p err";
              syslog_emerg = "sudo dmesg --level=emerg,alert,crit";
              watch = lib.getExe pkgs.viddy;
              nrs = "${lib.getExe config.hm.programs.nh.package} os switch";
              hms = "${lib.getExe config.hm.programs.nh.package} home switch";
              fml = "poweroff";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Редакторы и разработка ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              n = lib.getExe inputs.angeldust-nixCats.packages.${lib.hostPlatform}.default;
              py = "python";
              dif = lib.getExe config.hm.programs.delta.package;
              ssh = lib.getExe pkgs.ggh;

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Git и инструменты ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              g = lib.getExe config.hm.programs.git.package;
              gitignore = "${lib.getExe pkgs.curlFull} -sL https://www.gitignore.io/api/$argv";
              icat = "${lib.getExe' pkgs.kitty "kitten"} icat";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Сеть и интернет ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              ipv4 = "${ip} addr show | grep 'inet ' | grep -v '127.0.0.1' | cut -d' ' -f6 | cut -d/ -f1";
              ipv6 = "${ip} addr show | grep 'inet6 ' | cut -d ' ' -f6 | sed -n '2p'";
              PublicIP = "${lib.getExe pkgs.curlFull} ifconfig.me && echo ''";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Управление терминалом ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              cls = "clear && ${lib.getExe config.hm.programs.fastfetch.package}";
              c = "clear && ${lib.getExe config.hm.programs.fastfetch.package}";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Sudo и безопасность ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              visudo = "EDITOR=${lib.getExe inputs.angeldust-nixCats.packages.${lib.hostPlatform}.default} command sudo visudo";
              se = "sudoedit";
            };

            shellAbbrs = {
              mkdir = "mkdir -p";
              rm = "rm -rf";
              cp = "cp -r";
              bd = lib.getExe pkgs.blobdrop;
              "--help" = {
                position = "anywhere";
                expansion = "--help | ${lib.getExe config.hm.programs.bat.package} -plhelp";
              };
            };

            # Функции
            functions =
              (import ./magic-enter.nix {inherit config lib;})
              // {
                sudo = {
                  body = ''
                    if functions -q -- $argv[1]
                        set -l new_args (string join ' ' -- (string escape -- $argv))
                        set argv fish -c "$new_args"
                    end

                    command sudo $argv
                  '';
                };
              };

            # Код, который выполняется при запуске оболочки
            shellInit = ''
              source ${./catppuccin-machiato.fish}
              ${lib.getExe pkgs.any-nix-shell} fish --info-right | source
              __magic-enter

              if test -z "$DISPLAY" && test "$XDG_VTNR" = 1
                exec ${lib.getExe' config.programs.niri.package "niri-session"} -l
              end
            '';
          };
        };

        # Переменные окружения
        home = {
          packages = with pkgs; [
            grc # Generic Colouriser for command output
          ];

          sessionVariables = {
            SUDO_PROMPT = "$(tput setaf 1 bold)Password:$(tput sgr0) ";
            LIBVIRT_DEFAULT_URI = "qemu:///system";
            RIP_GRAVEYARD = "~/.local/share/Trash";
            no_proxy = "127.0.0.1";
            SPACEFISH_USER_SHOW = "always";
            GDK_BACKEND = "wayland";
            npm_config_prefix = "$HOME/.local";
          };

          # Пути
          sessionPath = [
            "/home/angeldust/.cargo/bin"
            "$HOME/.ZAP_D/webdriver/linux/64"
            "/home/angeldust/.local/bin"
          ];
        };
      };
    };
  };
}
