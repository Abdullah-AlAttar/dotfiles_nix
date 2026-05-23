{config, ...}: {
  flake.modules.homeManager.t580 = {
    imports = with config.flake.modules.homeManager; [
      base
      nixosExtras
      shell
      dev
      # Uncomment to enable GUI apps on this host:
      # gui
    ];
  };
}
