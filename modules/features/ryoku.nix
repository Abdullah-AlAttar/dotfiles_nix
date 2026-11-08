{inputs, ...}: {
  # Ryoku desktop (NixOS port). Full desktop, alternative to the niri/kde/gnome
  # modules. Do NOT import together with self.nixosModules.niri.
  flake.nixosModules.ryoku = {username, ...}: {
    imports = [inputs.ryoku.nixosModules.default];

    programs.ryoku = {
      enable = true;
      defaultCompositor = "niri";
      shell = "zsh";
      # `ryoku update` advances the `ryoku` input in this flake and rebuilds.
      updateFlake = "/home/${username}/Workspace/dotfiles_nix";
    };

    # Conflicts with programs.ssh.startAgent (common.nix); same fix as the niri module.
    services.gnome.gcr-ssh-agent.enable = false;
  };
}
