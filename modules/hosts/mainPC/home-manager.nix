{ inputs, ... }: {
  flake.nixosModules.mainPCHomeManager =
    {
      pkgs,
      username,
      ...
    }:
    {
      # Host-specific Home Manager overrides.
      # The shared home module import list lives in
      # flake.nixosModules.defaultHomeManager (modules/home/default-hm-imports.nix).
      home-manager.users.${username} = {
        imports = [ ];
        home.sessionVariables = {
          SSH_ASKPASS = "";
          SSH_ASKPASS_REQUIRE = "never";
        };
        # mainPC-specific packages not in shared home modules
        home.packages =
          with pkgs;
          [
            scrcpy
            libreoffice-qt6-fresh
            yt-dlp
            freetube
            pear-desktop
            showmethekey
            snx-rs
            code-cursor
            postman
          ]
          ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
            opencode
            copilot-cli
            spec-kit
            pi
            omp
            reasonix
          ]);
      };
    };
}
