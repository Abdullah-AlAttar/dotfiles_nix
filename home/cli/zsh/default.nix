{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;

    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    dotDir = "${config.xdg.configHome}/zsh";

    plugins = [
      # Vi keybindings
      /*
      {
           name = "zsh-vi-mode";
           file = "./share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
           src = pkgs.zsh-vi-mode;
          }
      */
    ];
    oh-my-zsh = {
      enable = true;
      # theme = "robbyrussell";
      plugins = [
        "git"
        # "docker"
        # "kubectl"
        # "npm"
        # "golang"
        "colored-man-pages"
        "extract"
        # "history-substring-search"
        "sudo"
        "web-search"
      ];
    };

    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      path = "${config.xdg.dataHome}/zsh/history";
      share = true;
      size = 100000;
      save = 100000;
    };

    sessionVariables = {
      COLORTERM = "truecolor";
      TERM = "xterm-256color";
      EDITOR = "nvim";
      ZVM_VI_ESCAPE_BINDKEY = "kl";
    };

    shellAliases = rec {
      ".." = "cd ..";
      cdtemp = "cd `mktemp -d`"; # Change to a temporary directory
      cp = "cp -iv"; # Copy files interactively
      ln = "ln -v"; # Create symbolic links with verbose output
      mkdir = "mkdir -vp"; # Create directories with verbose output
      mv = "mv -iv"; # Move files interactively
      rm =
        if pkgs.stdenv.targetPlatform.isDarwin
        then "rm -v"
        else "rm -Iv"; # Remove files interactively or with verbose output
      dh = "du -h"; # Disk usage in human-readable format
      df = "df -h"; # Disk free in human-readable format
      su = "sudo -E su -m"; # Switch user with environment preservation
      sysu = "systemctl --user"; # Systemctl for user services
      jnsu = "journalctl --user"; # Journalctl for user services
      svim = "sudoedit"; # Edit files with sudo
      t = "task"; # Taskfile command
      tg = "task -g"; # Global task command
      cd = "z"; # Change directory using zsh's z plugin
      k = "kubectl"; # Alias for kubectl
      kc = "kubecolor"; # Alias for kubecolor
      fastfetch = "fastfetch -c examples/10.jsonc"; # Use 10.jsonc example config
      # cat = "${pkgs.bat}/bin/bat --paging=never"; # Use bat as a replacement for cat
    };

    initContent = builtins.readFile ./zshInitContent.sh;
  };
}
