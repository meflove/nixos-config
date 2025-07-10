{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Отключает приветствие Fish [15, 16]
      # Дополнительные команды, выполняемые при запуске интерактивной оболочки
    '';
    # plugins = [
    #   # Пример плагина из nixpkgs
    #   {
    #     name = "grc";
    #     src = pkgs.fishPlugins.grc.src; # Для цветного вывода команд [15]
    #   }
    #   # Пример плагина, упакованного вручную
    #   # {
    #   #   name = "z";
    #   #   src = pkgs.fetchFromGitHub {
    #   #     owner = "jethrokuan";
    #   #     repo = "z";
    #   #     rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
    #   #     sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
    #   #   };
    #   # }
    # ];
    # Добавление функций Fish
    # functions = {
    #   # Пример функции для отображения, что вы находитесь в nix-shell [15]
    #   fish_prompt = ''
    #     set -l nix_shell_info (
    #       if test -n "$IN_NIX_SHELL"
    #         echo -n "<nix-shell> "
    #       end
    #     )
    #     echo -n -s "$nix_shell_info ~>"
    #   '';
    # Другие пользовательские функции, например, для окружений
    # pythonEnv = {
    #   description = "start a nix-shell with the given python packages";
    #   body = ''
    #     if set -q argv
    #       set argv $argv[2.. -1]
    #     end
    #     for el in $argv
    #       set ppkgs $ppkgs "python"$pythonVersion"Packages. $el"
    #     end
    #     nix-shell -p $ppkgs
    #   '';
    # };
    # };
  };

  # Чтобы fish completions из Nixpkgs работали, также включите fish на системном уровне,
  # но не делайте его login shell, чтобы избежать проблем с POSIX-несовместимостью.[15]
  # Это делается в hosts/pc/default.nix или hosts/vm/default.nix:
  # programs.fish.enable = true;
}
