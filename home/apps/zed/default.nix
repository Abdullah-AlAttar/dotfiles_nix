{ ... }: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "bluloco-theme"
      "catppuccin-icons"
      "comment"
      "dbml"
      "git-firefly"
      "golangci-lint"
      "gruvbox-material"
      "html"
      "jsonnet"
      "kanagawa-themes"
      "log"
      "proto"
      "sql"
      "typespec"
      "vscode-icons"
    ];
  };
}
