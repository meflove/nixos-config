{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      config,
      ...
    }: {
      users.users.${lib.userName}.shell = config.programs.fish.package;
      programs.fish = {
        enable = true;
        package = pkgs.master.fish;
      };

      hm = {
        programs = {
          nix-your-shell = {
            enable = true;
            enableFishIntegration = true;
            enableNushellIntegration = true;
            nix-output-monitor.enable = true;
          };

          fish = {
            inherit (config.programs.fish) enable package;
            generateCompletions = true;

            shellInit =
              # fish
              ''
              '';
            loginShellInit =
              # fish
              ''
                if test -z "$DISPLAY" && test "$XDG_VTNR" = 1
                  exec ${lib.getExe' config.programs.niri.package "niri-session"} -l
                end

              '';
            interactiveShellInit =
              # fish
              ''
                set fish_greeting
                set NUSHELL_EXEC true

                if not $NUSHELL_EXEC
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

                  magic-enter-bindings

                  # Zellij
                  set -x ZELLIJ_CONFIG_DIR "$HOME/.config/zellij"
                  # set -x ZELLIJ_AUTO_ATTACH true

                  if test "$TERM" = xterm-ghostty; or test "$TERM" = xterm-kitty
                    eval (${lib.getExe config.hm.programs.zellij.package} setup --generate-auto-start fish | string collect)

                    ${lib.getExe config.hm.programs.fastfetch.package}
                  else
                    ${lib.getExe config.hm.programs.fastfetch.package}
                  end

                  # Wayland vars for root
                  if test (id -u) -eq 0
                    set -gx XDG_RUNTIME_DIR /run/user/1000
                    set -gx WAYLAND_DISPLAY wayland-1
                  end
                else
                  exec nu
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
              cat = lib.getExe config.hm.programs.bat.package;
              x = "wl-copy";
              xv = "wl-paste";
              catt = "command cat";
              Holes = "sudo ${lib.getExe pkgs.unixtools.netstat} -tupln";
              err = "journalctl -b -p err";
              syslog_emerg = "sudo dmesg --level=emerg,alert,crit";
              watch = lib.getExe pkgs.viddy;
              fml = "poweroff";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Редакторы и разработка ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              n = lib.getExe pkgs.editor;
              py = "python";
              dif = lib.getExe config.hm.programs.delta.package;
              ssh = lib.getExe pkgs.ggh;

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Git и инструменты ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              icat = "${lib.getExe' config.hm.programs.kitty.package "kitten"} icat";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Сеть и интернет ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              ipv4 = "${ip} addr show | grep 'inet ' | grep -v '127.0.0.1' | cut -d' ' -f6 | cut -d/ -f1";
              ipv6 = "${ip} addr show | grep 'inet6 ' | cut -d ' ' -f6 | sed -n '2p'";
              PublicIP = "${lib.getExe pkgs.curl} ifconfig.me";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Управление терминалом ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              cls = "clear && ${lib.getExe config.hm.programs.fastfetch.package}";
              c = "clear && ${lib.getExe config.hm.programs.fastfetch.package}";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Sudo и безопасность ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              visudo = "EDITOR=${lib.getExe pkgs.editor} command sudo visudo";
              se = "sudoedit";
            };

            shellAbbrs = {
              mkdir = "mkdir -p";
              rm = "rm -rf";
              cp = "cp -r";
              bd = lib.getExe pkgs.blobdrop;
              g = "git";
              j = "jj";
              nrs = "nixos switch --fallback --option access-tokens=(cat ${config.hm.sops.secrets."github/github_pat".path})";
              nbs = "nixos boot --fallback --option access-tokens=(cat ${config.hm.sops.secrets."github/github_pat".path})";
              nfu = "nix flake update --option access-tokens (cat ${config.hm.sops.secrets."github/github_pat".path})";
              oc = "opencode2";
              cl = "claude";

              "--help" = {
                position = "anywhere";
                expansion = "--help | ${lib.getExe config.hm.programs.bat.package} -plhelp";
              };
            };

            functions =
              {
                aniwatch = {
                  description = "Download and play an HLS stream from kodik";
                  body =
                    # fish
                    ''
                      if test (count $argv) -ne 1
                        echo "usage: aniwatch URL" >&2
                        return 2
                      end

                      set -l output (mktemp --suffix=.mp4 /tmp/aniwatch.XXXXXX)

                      if not ffmpeg -y -i "$argv[1]" -c copy "$output"
                        rm -f "$output"
                        return 1
                      end

                      mpv "$output"
                      set -l status_code $status
                      rm -f "$output"
                      return $status_code
                    '';
                };
              }
              // (import ./magic-enter.nix {});
          };
        };

        # Переменные окружения
        home = {
          packages = lib.attrValues {
            inherit
              (pkgs)
              grc # Generic Colouriser for command output
              ;
          };
        };
      };
    };
  };
}
