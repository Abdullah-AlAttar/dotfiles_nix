{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.t580HomeManager = {
    config,
    pkgs,
    ...
  }: {
    # Per-host Home Manager module selection (dendritic pattern).
    home-manager.users.ab_dullah = {
      imports = [
        self.homeModules.common
        self.homeModules.cli
        self.homeModules.dev
        self.homeModules.apps
        self.homeModules.system
      ];
      home.sessionVariables = {
        SSH_ASKPASS = "";
        SSH_ASKPASS_REQUIRE = "never";
      };
    };
  };
}
