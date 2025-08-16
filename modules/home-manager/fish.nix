{ config, pkgs, ... }: {
  # Включаем и настраиваем Fish
  programs.starship.enable = true;

  programs.fish = {
    enable = true;

    generateCompletions = true;

    interactiveShellInit = ''
      set fish_greeting

      # Zellij
      export ZELLIJ_CONFIG_DIR=$HOME/.config/zellij
      if [ "$TERM" = xterm-ghostty ]
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

    # Декларативное управление плагинами
    plugins = with pkgs.fishPlugins; [
      # Плагины из вашего fish_plugins
      {
        name = "done";
        src = done.src;
      }
      {
        name = "spark";
        src = spark.src;
      }
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "puffer";
        src = puffer.src;
      } # Замените хеш на актуальный, если нужно
      {
        name = "grc";
        src = grc.src;
      } # Замените хеш
      # { name = "zellij"; src = zellij.src; }
      {
        name = "nvm";
        src = nvm.src;
      }
      {
        name = "fishtape";
        src = fishtape.src;
      }
      {
        name = "fifc";
        src = fifc.src;
      } # Замените хеш

    ];

    # Псевдонимы (aliases) и сокращения (abbr)
    shellAliases = {
      # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Системные утилиты ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
      p = "paru";
      ls = "eza --icons=always --color=always -a1 --level 1";
      ll = "eza --icons=always --color=always -alh --git";
      gp = "gtrash put";
      tree = "ls --tree --level 1000";
      less = "less -R";
      du = "dust";
      df = "duf";
      ip = "ip -color=auto";
      grep = "grep --color=auto";
      cat = "bat";
      catt = "command cat";
      Holes = "sudo netstat -tupln";
      err = "journalctl -b -p err";
      syslog_emerg = "sudo dmesg --level=emerg,alert,crit";
      watch = "viddy";
      # nrs =
      #   "sudo nixos-rebuild switch --log-format internal-json -v --flake .#nixos-pc &| nom --json";
      # hms =
      #   "home-manager switch --log-format internal-json -v --flake .#angeldust &| nom --json";
      nrs = "nh os switch .";
      hms = "nh home switch .";

      # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Редакторы и разработка ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
      n = "nvim";
      m = "micro";
      py = "python";
      dif = "delta";
      th = "ad";
      ssh = "ggh";
      nzo = "search_with_zoxide";
      zigup = "command sudo zigup --install-dir /home/meflove/.zig";

      # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Git и инструменты ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
      g = "git";
      icat = "kitten icat";
      fman = "compgen -c | fzf | xargs man";

      # ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ Сеть и интернет ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
      ipv4 =
        "ip addr show | grep 'inet ' | grep -v '127.0.0.1' | cut -d' ' -f6 | cut -d/ -f1";
      ipv6 = "ip addr show | grep 'inet6 ' | cut -d ' ' -f6 | sed -n '2p'";
      PublicIP = "curl ifconfig.me && echo ''";
      brn = "curl wttr.in/barnaul | head -n -1";

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
      makepkg = "makepkg -sric --skipinteg";
      bd = "blobdrop";
    };

    # Функции
    functions = {
      # Тема Tokyo Night Moon
      # fish_prompt = pkgs.lib.strings.fileContents ../../dotfiles/config/fish/themes/tokyo-night-moon.fish;

      # Ваши кастомные функции
      # magic-enter-cmd = pkgs.lib.strings.fileContents ../../dotfiles/config/fish/functions/magic-enter-cmd.fish;
      # search_with_zoxide = pkgs.lib.strings.fileContents ../../dotfiles/config/fish/functions/search_with_zoxide.fish;
    };

    # Код, который выполняется при запуске оболочки
    shellInit = ''
      source $__fish_config_dir/themes/tokyo-night-moon.fish

      # Atuin
      set -x ATUIN_NOBIND true
      atuin init fish | source
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

      # Zoxide
      zoxide init fish | source

      # Starship
      starship init fish | source # Раскомментируйте, если используете Starship вместо темы

    '';
  };

  # Переменные окружения
  home.sessionVariables = {
    EDITOR = "nvim";
    SUDO_PROMPT = "$(tput setaf 1 bold)Password:$(tput sgr0) ";
    LIBVIRT_DEFAULT_URI = "qemu:///system";
    RIP_GRAVEYARD = "~/.local/share/Trash";
    no_proxy = "127.0.0.1";
    SPACEFISH_USER_SHOW = "always";
    GDK_BACKEND = "wayland";
    npm_config_prefix = "$HOME/.local";
  };

  # Пути
  home.sessionPath = [
    "/home/angeldust/.cargo/bin"
    "$HOME/.ZAP_D/webdriver/linux/64"
    "/home/angeldust/.local/bin"
  ];
}
