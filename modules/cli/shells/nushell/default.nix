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
            enableNushellIntegration = false;
          };
          starship = {
            enable = true;
            enableNushellIntegration = true;
          };
          nushell = let
            clearAndFastfetch =
              pkgs.writeShellScriptBin
              "clear-and-fastfetch"
              ''
                clear
                fastfetch
              ''
              |> lib.getExe;
          in {
            enable = true;

            shellAliases = {
              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Системные утилиты ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              ls = "ls -as";
              tree = "eza --tree";
              less = "less -R";
              df = lib.getExe pkgs.duf;
              cat = lib.getExe config.hm.programs.bat.package;
              x = "wl-copy";
              xv = "wl-paste";
              catt = "^cat";
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
              icat = "${lib.getExe' pkgs.kitty "kitten"} icat";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Сеть и интернет ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              PublicIP = "${lib.getExe pkgs.curl} ifconfig.me";

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Управление терминалом ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              cls = clearAndFastfetch;
              c = clearAndFastfetch;

              # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Sudo и безопасность ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
              visudo = "EDITOR=${lib.getExe pkgs.editor} sudo visudo";
              se = "sudoedit";
            };

            settings = {
              buffer_editor = lib.getExe pkgs.editor;
              use_kitty_protocol = true;
              show_banner = false;
              history = {
                file_format = "sqlite";
                max_size = 5000000;
                isolation = true;
                ignore_space_prefixed = true;
              };
              completions = {
                case_sensitive = false; # case-sensitive completions
                quick = true; # set to false to prevent auto-selecting completions
                partial = true; # set to false to prevent partial filling of the prompt
                algorithm = "prefix"; # prefix or fuzzy
                external = {
                  # set to false to prevent nushell looking into $env.PATH to find more suggestions
                  enable = true;
                  # set to lower can improve completion performance at the cost of omitting some options
                  max_results = 100;
                };
              };
            };

            extraConfig =
              # nu
              ''
                if $nu.is-interactive {
                  $env.ZELLIJ_CONFIG_DIR = ($nu.home-dir | path join .config zellij)

                  if $env.TERM == xterm-ghostty or $env.TERM == xterm-kitty {
                    if (start-zellij) {
                      exit
                    }
                    ${clearAndFastfetch}
                  } else {
                    ${clearAndFastfetch}
                  }

                  if (id -u) == 0 {
                    load-env {
                      XDG_RUNTIME_DIR: /run/user/1000,
                      WAYLAND_DISPLAY: wayland-1
                    }
                  }
                }

                # envs
                use std/util "path add"
                path add /usr/bin/env

                # abbrs
                $env.config.abbreviations = {
                  rm: "rm -r"
                  cp: "cp -r"
                  bd: ^${lib.getExe pkgs.blobdrop}
                  g: git
                  j: jj
                  nrs: "nixos switch --fallback --option access-tokens=$env.GITHUB_TOKEN"
                  nbs: "nixos boot --fallback --option access-tokens=$env.GITHUB_TOKEN"
                  nfu: "nix flake update --option access-tokens $env.GITHUB_TOKEN"
                  oc: opencode2
                  cl: claude
                }

                #functions
                ## run with fish
                def fish-run [cmd: string] {
                  ^${lib.getExe config.hm.programs.fish.package} -c $cmd
                }

                ## zellij
                def start-zellij []: nothing -> bool {
                  if ($env | columns) not-has ZELLIJ {
                    if ($env | columns) has ZELLIJ_AUTO_ATTACH and $env.ZELLIJ_AUTO_ATTACH == 'true' {
                      zellij attach -c
                    } else {
                      zellij
                    }

                    if ($env | columns) has ZELLIJ_AUTO_EXIT and $env.ZELLIJ_AUTO_EXIT == 'true' {
                      return true
                    }
                  }

                  return false
                }

                # aniwatch
                use std/log
                def aniwatch [url: string] {
                  if $url == "" {
                    log warning "usage: aniwatch URL"
                    return 2
                  }

                  let output = (mktemp --suffix=.mp4 -t aniwatch.XXXXXX)
                  let result = (ffmpeg -y -i $url -c copy $output | complete)

                  if $result.exit_code != 0 {
                    rm $output
                    log error ($"ffmpeg failed with exit code ($result.exit_code)\nError: ($result.stderr)")
                    return 1
                  }

                  mpv $output
                  rm $output
                  return 0
                }

                ## ll
                def ll [path: path = ".", --full-paths(-f)] {
                  let files = if $full_paths {
                    ls --all --long --full-paths $path
                  } else {
                    ls --all --long $path
                  }

                  let has_symlinks = ($files | where type == symlink | length) > 0

                  if $has_symlinks {
                    $files | select name type target mode user size modified
                  } else {
                    $files | select name type mode user size modified
                  }
                }

                ## magic-enter
                def magic-enter-cmd []: nothing -> string {
                  let git_root = (
                    try {
                      git rev-parse --show-toplevel e> /dev/null | str trim
                    } catch {
                      ""
                    }
                  )

                  if ($git_root | is-not-empty) {
                    if ($git_root | path join .jj | path type) == dir {
                      let jj_status = (
                        try {
                          jj status --no-pager | str trim
                        } catch {
                          ""
                        }
                      )

                      if ($jj_status | is-not-empty) {
                        return "ll | print; jj status --no-pager"
                      }
                    } else {
                      let git_status = (
                        try {
                          git status --porcelain -s | str trim
                        } catch {
                          ""
                        }
                      )

                      if ($git_status | is-not-empty) {
                        return "ll | print; git status"
                      }
                    }
                  }

                  "ll"
                }

                def magic-enter []: nothing -> nothing {
                  if (commandline | is-empty) {
                    commandline edit (magic-enter-cmd)
                  }
                }

                # completers setup
                let fish_completer = {|spans|
                  fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
                  | from tsv --flexible --noheaders --no-infer
                  | rename value description
                  | update value {|row|
                      let value = $row.value
                      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
                      if ($need_quote and ($value | path exists)) {
                        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
                        $'"($expanded_path | str replace --all "\"" "\\\"")"'
                      } else {$value}
                    }
                }

                let carapace_completer = {|spans: list<string>|
                  $env.CARAPACE_LENIENT = 1
                  carapace $spans.0 nushell ...$spans | from json
                }

                let external_completer = {|spans|
                  let expanded_alias = scope aliases
                  | where name == $spans.0
                  | get -o 0.expansion

                  let spans = if $expanded_alias != null {
                    $spans
                    | skip 1
                    | prepend ($expanded_alias | split row ' ' | take 1)
                  } else {
                    $spans
                  }

                  match $spans.0? {
                    nu => $fish_completer
                    git => $fish_completer
                    jj => $fish_completer
                    _ => $carapace_completer
                  } | do $in $spans
                }

                $env.config.completions.external.enable = true
                $env.config.completions.external.completer = $external_completer

                # binds
                $env.config.keybindings ++= [
                  # magic enter
                  {
                    name: magic_enter
                    modifier: alt
                    keycode: enter
                    mode: [emacs vi_insert vi_normal]
                    event: {
                      send: executehostcommand
                      cmd: magic-enter
                    }
                  }
                  # toggle sudo
                  {
                    name: toggle_sudo
                    modifier: alt
                    keycode: char_s
                    mode: [emacs vi_insert vi_normal]
                    event: {
                      send: executehostcommand
                      cmd: "let cmd = (commandline); commandline edit (if $cmd starts-with sudo { $cmd | str replace -r \'^sudo \' \'\' } else { \'sudo \' ++ $cmd });"
                    }
                  }
                  # alias expand
                  {
                    name: abbr
                    modifier: control
                    keycode: space
                    mode: [emacs vi_normal vi_insert]
                    event: [
                      {send: menu, name: abbr_menu}
                      {edit: insertchar, value: ' '}
                    ]
                  }
                ]

                # menus
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
                    style: {text: green, selected_text: green_reverse, description_text: yellow}
                    source: {|buffer, position|
                      scope aliases
                      | where name == $buffer
                      | each {|elt| {value: $elt.expansion} }
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
