{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.cli.fishShell;
in {
  options.home.${namespace}.cli.fishShell = {
    enable =
      lib.mkEnableOption "enable Fish shell configuration"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    programs = {
      fish = {
        enable = true;

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
              eval (zellij setup --generate-auto-start fish | string collect)

              fastfetch
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

        shellAliases = {
          # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Системные утилиты ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
          ls = "eza";
          ll = "eza -l";
          tree = "eza --tree";
          less = "less -R";
          du = "dust";
          df = "duf";
          ip = "ip -color=auto";
          grep = "grep --color=auto";
          cat = "bat";
          x = "wl-copy";
          xv = "wl-paste";
          catt = "command cat";
          Holes = "sudo netstat -tupln";
          err = "journalctl -b -p err";
          syslog_emerg = "sudo dmesg --level=emerg,alert,crit";
          watch = "viddy";
          nrs = "nh os switch";
          hms = "nh home switch";
          fml = "poweroff";

          # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Редакторы и разработка ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
          n = "nixCats";
          py = "python";
          dif = "delta";
          ssh = "ggh";

          # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Git и инструменты ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
          g = "git";
          gitignore = "curl -sL https://www.gitignore.io/api/$argv";
          icat = "kitten icat";

          # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Сеть и интернет ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
          ipv4 = "ip addr show | grep 'inet ' | grep -v '127.0.0.1' | cut -d' ' -f6 | cut -d/ -f1";
          ipv6 = "ip addr show | grep 'inet6 ' | cut -d ' ' -f6 | sed -n '2p'";
          PublicIP = "curl ifconfig.me && echo ''";

          # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Управление терминалом ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
          cls = "clear && fastfetch";
          c = "clear && fastfetch";

          # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Sudo и безопасность ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
          visudo = "EDITOR=nvim command sudo visudo";
          se = "sudoedit";
        };

        shellAbbrs = {
          mkdir = "mkdir -p";
          rm = "rm -rf";
          cp = "cp -r";
          bd = "blobdrop";
          "--help" = {
            position = "anywhere";
            expansion = "--help | bat -plhelp";
          };
        };

        # Функции
        functions =
          (import ./magic-enter.nix)
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
          source ${./tokyo-night-moon.fish}
          ${lib.getExe pkgs.any-nix-shell} fish --info-right | source
          __magic-enter

          if test -z "$DISPLAY" && test "$XDG_VTNR" = 1
            exec ${config.wayland.windowManager.hyprland.package}/bin/start-hyprland
          end
        '';
      };
    };

    # Переменные окружения
    home = {
      packages = with pkgs; [
        grc # Generic Colouriser for command output
        unixtools.net-tools # Network tools
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
}
