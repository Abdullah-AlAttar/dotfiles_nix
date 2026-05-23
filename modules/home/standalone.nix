{
  config,
  inputs,
  ...
}: {
  # Standalone Home Manager configuration.
  # Usage: home-manager switch --flake '.#ab_dullah'
  flake.homeConfigurations.ab_dullah = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules =
      (with config.flake.modules.homeManager; [
        base
        shell
        dev
        gui
      ])
      ++ [
        {
          nixpkgs.config.allowUnfree = true;
          home.username = "ab_dullah";
          home.homeDirectory = "/home/ab_dullah";
          programs.home-manager.enable = true;
          targets.genericLinux.enable = true;
        }
      ];
    extraSpecialArgs = {
      inherit inputs;
      isNixOS = false;
      username = "ab_dullah";
    };
  };
}
