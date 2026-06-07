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
    };
  };

  # Inject Neovide-specific keymappings and settings into nixvim config
  programs.nixvim.extraConfigLua = lib.mkIf config.programs.nixvim.enable (builtins.readFile ./neovim-config.lua);
}
