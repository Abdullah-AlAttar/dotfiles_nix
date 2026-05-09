{ inputs, lib, ... }: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./autocommands.nix
    ./completion.nix
    ./keymappings.nix
    ./options.nix
    ./plugins
  ];

  home.shellAliases.v = "nvim";

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    nixpkgs.useGlobalPackages = true;

    performance = {
      combinePlugins = {
        enable = false; # Disable to avoid help tags issues
      };
      byteCompileLua.enable = true;
    };

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;

    extraConfigLua = builtins.readFile ./extraConfigLua.lua;
  };
}
