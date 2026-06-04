{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.t580HomeManager = {
    config,
    pkgs,
    username,
    ...
  }: {
    # Per-host Home Manager module selection (dendritic pattern).
    home-manager.users.${username} = {
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
