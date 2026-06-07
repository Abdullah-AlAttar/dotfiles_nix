{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.mainPCHomeManager = {
    pkgs,
    username,
    ...
  }: {
    # Per-host Home Manager module selection (dendritic pattern).
    # Each host chooses which home modules to include.
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
      # mainPC-specific packages not in shared home modules
      home.packages = with pkgs;
        [
          scrcpy
          libreoffice-qt6-fresh

          # nixard # explore NixOS packages
        ]
        ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
          opencode
          copilot-cli
          spec-kit
          pi
          omp
        ]);
    };
  };
}
