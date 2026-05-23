{
  config,
  pkgs,
  lib,
  ...
}: let
  hasZedEditor = builtins.hasAttr "zed-editor" pkgs;
in {
  config = lib.mkMerge [
    (lib.mkIf (config.programs.system-specific.enableGuiApps && hasZedEditor) {
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
    })
    {
      warnings =
        lib.optional (config.programs.system-specific.enableGuiApps && !hasZedEditor)
        "programs.system-specific.zed: zed-editor is not available for this platform; skipping installation.";
    }
  ];
}
