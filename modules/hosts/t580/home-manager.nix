{ ... }: {
  flake.nixosModules.t580HomeManager = {
    pkgs,
    username,
    ...
  }: {
    # Host-specific Home Manager overrides.
    # The shared home module import list lives in
    # flake.nixosModules.defaultHomeManager (modules/home/default-hm-imports.nix).
    home-manager.users.${username} = {
      imports = [];
      home.sessionVariables = {
        SSH_ASKPASS = "";
        SSH_ASKPASS_REQUIRE = "never";
      };
      home.packages = with pkgs; [
        google-chrome
        thunar
        thunar-volman
        tumbler # Thunar thumbnail service
        gvfs    # GVFS for mounting/trash support
      ];
    };
  };
}
