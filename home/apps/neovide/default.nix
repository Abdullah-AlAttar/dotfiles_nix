{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.neovide = {
    enable = true;
    settings = {
      maximized = true;
      font = {
        normal = [
          "Google Sans Code Monospaced"
          "CaskaydiaCove Nerd Font"
        ];
        size = 14;
      };
    };
  };

  # Inject Neovide-specific keymappings and settings into nixvim config
  programs.nixvim.extraConfigLua = lib.mkIf config.programs.nixvim.enable (
    builtins.readFile ./neovim-config.lua
  );
}
