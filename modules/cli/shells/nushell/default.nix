{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      lib,
      pkgs,
      config,
      ...
    }: {
      hm = {
        programs = {
          carapace = {
            enable = true;
            enableNushellIntegration = true;
          };
          nushell = {
            enable = true;

            shellAliases = let
              ip = lib.getExe' pkgs.iproute2 "ip";
            in {
              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Системные утилиты ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              tree = "eza --tree";
              less = "less -R";
              df = lib.getExe pkgs.duf;
              ip = "${ip} -color=auto";
              grep = "grep --color=auto";
              cat = lib.getExe config.hm.programs.bat.package;
              x = "wl-copy";
              xv = "wl-paste";
              catt = "^cat";
              Holes = "sudo ${lib.getExe pkgs.unixtools.netstat} -tupln";
              err = "journalctl -b -p err";
              syslog_emerg = "sudo dmesg --level=emerg,alert,crit";
              watch = lib.getExe pkgs.viddy;
              nrs = "${lib.getExe config.programs.nixos-cli.package} apply";
              fml = "poweroff";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Редакторы и разработка ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              n = lib.getExe pkgs.nixCats;
              py = "python";
              dif = lib.getExe config.hm.programs.delta.package;
              ssh = lib.getExe pkgs.ggh;

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Git и инструменты ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              icat = "${lib.getExe' pkgs.kitty "kitten"} icat";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Сеть и интернет ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              ipv4 = "${ip} addr show | grep 'inet ' | grep -v '127.0.0.1' | cut -d' ' -f6 | cut -d/ -f1";
              ipv6 = "${ip} addr show | grep 'inet6 ' | cut -d ' ' -f6 | sed -n '2p'";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Управление терминалом ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              cls = "clear; fastfetch";
              c = "clear; fastfetch";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Sudo и безопасность ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              visudo = "^sudo visudo";
              se = "sudoedit";
            };

            settings = {
              show_banner = false;
              completions = {
                case_sensitive = false; # case-sensitive completions
                quick = true; # set to false to prevent auto-selecting completions
                partial = true; # set to false to prevent partial filling of the prompt
                algorithm = "fuzzy"; # prefix or fuzzy
                external = {
                  # set to false to prevent nushell looking into $env.PATH to find more suggestions
                  enable = true;
                  # set to lower can improve completion performance at the cost of omitting some options
                  max_results = 100;
                };
              };
            };

            envFile.text =
              #nu
              ''
                $env.PATH = ($env.PATH |
                 split row (char esep) |
                 append /usr/bin/env
                )
              '';

            extraConfig =
              #nu
              ''
                let carapace_completer = {|spans: list<string>|
                  carapace $spans.0 nushell ...$spans
                  | from json
                  | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
                }

                let zoxide_completer = {|spans|
                  $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
                }

                $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

                let multiple_completers = {|spans|
                  ## alias fixer start https://www.nushell.sh/cookbook/external_completers.html#alias-completions
                  let expanded_alias = scope aliases
                  | where name == $spans.0
                  | get --optional 0.expansion

                  let spans = if $expanded_alias != null {
                    $spans
                    | skip 1
                    | prepend ($expanded_alias | split row ' ' | take 1)
                  } else {
                    $spans
                  }
                  ## alias fixer end

                  match $spans.0 {
                    __zoxide_z | __zoxide_zi => $zoxide_completer
                    _ => $carapace_completer
                  } | do $in $spans
                }

                $env.config.completions.external.completer = $multiple_completers

                def fish-run [cmd: string] {
                    ^${lib.getExe config.hm.programs.fish.package} -c $cmd
                }

                $env.config.keybindings ++= [
                  {
                    name: abbr
                    modifier: control
                    keycode: space
                    mode: [emacs, vi_normal, vi_insert]
                    event: [
                      { send: menu name: abbr_menu }
                      { edit: insertchar, value: ' '}
                    ]
                  }
                  {
                    name: prepend_sudo
                    modifier: alt
                    keycode: char_s
                    mode: [emacs, vi_normal, vi_insert]
                    event: [
                      { edit: MoveToStart }
                      { edit: InsertString, value: "sudo " }
                      { edit: MoveToEnd }
                    ]
                  }
                ]

                $env.config.menus ++= [
                  {
                    name: abbr_menu
                    only_buffer_difference: false
                    marker: "👀 "
                    type: {
                      layout: columnar
                      columns: 1
                      col_width: 20
                      col_padding: 2
                    }
                    style: {
                      text: green
                      selected_text: green_reverse
                      description_text: yellow
                    }
                    source: { |buffer, position|
                      scope aliases
                      | where name == $buffer
                      | each { |elt| {value: $elt.expansion }}
                    }
                  }
                ]
              '';
          };
        };
      };
    };
  };
}
