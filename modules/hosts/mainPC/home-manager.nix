{
  self,
  inputs,
  ...
}: let
  # Resolve the opt-in sops HM module from the flake registry.
  # (Captured here because the inner NixOS module doesn't receive `self`.)
  inherit (self.homeModules) sops;
in {
  flake.nixosModules.mainPCHomeManager = {
    pkgs,
    username,
    ...
  }: {
    # Host-specific Home Manager overrides.
    # The shared home module import list lives in
    # flake.nixosModules.defaultHomeManager (modules/home/default-hm-imports.nix).
    home-manager.users.${username} = {
      imports = [
        sops
      ];

      # ── sops-nix secrets ─────────────────────────────────────────
      # Each key in sops.secrets below corresponds to a top-level key
      # in secrets/secrets.yaml.  The secret value is written to a file
      # at ~/.config/sops-nix/secrets/<key> at build time.
      #
      # To add a new secret:
      #   1. Run:  sops secrets/secrets.yaml
      #   2. Add a key like:  my_new_key: my-secret-value
      #   3. Declare it here: sops.secrets.my_new_key = {};
      #   4. Rebuild:  task mainpc:switch
      #
      # Access the decrypted path from any HM module:
      #   config.sops.secrets.deepseek_api_key.path
      # ─────────────────────────────────────────────────────────────
      sops.secrets = {
        "deepseek_api_key" = {};
      };

      # ── Export sops secrets as environment variables ──────────────
      # Secrets are decrypted by sops-nix at login time (before the
      # shell starts), so reading them with `cat` at shell init works.
      # Path convention: ~/.config/sops-nix/secrets/<key>
      # ─────────────────────────────────────────────────────────────
      programs.zsh.initContent = ''
        # sops-nix secrets → environment variables
        export DEEPSEEK_API_KEY="$(cat ~/.config/sops-nix/secrets/deepseek_api_key)"
      '';

      home.sessionVariables = {
        SSH_ASKPASS = "";
        SSH_ASKPASS_REQUIRE = "never";
      };
      # mainPC-specific packages not in shared home modules
      home.packages = with pkgs;
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
          awscli2
        ]
        ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
          opencode
          copilot-cli
          spec-kit
          pi
          omp
          reasonix
          crush
          claude-code
        ]);
    };
  };
}
