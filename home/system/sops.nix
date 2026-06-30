# Home Manager sops-nix module — user-level secrets (API keys, tokens, etc.)
#
# HOW IT WORKS:
# ─────────────
# At build time (nixos-rebuild switch), sops-nix:
#   1. Reads the encrypted secrets/<file>.yaml
#   2. Decrypts it using your age private key (~/.config/sops/age/keys.txt)
#   3. Places each secret as a file in $XDG_RUNTIME_DIR/secrets.d/
#   4. Symlinks them to ~/.config/sops-nix/secrets/<key-name>
#
# You can reference secrets in your config via:
#   config.sops.secrets.<key>.path
#
# Example secret access:
#   The secret "deepseek_api_key" in secrets/secrets.yaml becomes a file at
#   ~/.config/sops-nix/secrets/deepseek_api_key containing the API key.
#
# This module is OPT-IN — hosts import it explicitly via self.homeModules.sops.
# It is NOT in the defaultHomeManager list, so only hosts that need it get it.
{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # Your age private key location. This key MUST exist and have no password.
    # It was generated with: nix-shell -p ssh-to-age --run \
    #   "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # The encrypted secrets file (relative to this module file).
    # This path resolves to <repo_root>/secrets/secrets.yaml at build time.
    defaultSopsFile = ../../secrets/secrets.yaml;

    # Secrets are defined per-host (in home-manager.nix), not here.
    # This keeps the module reusable — each host declares its own secrets.
  };
}
