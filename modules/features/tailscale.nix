{...}: {
  flake.nixosModules.tailscale = { ... }: {
    services.tailscale = {
      enable = true;
      authKeyFile = null; # Use `sudo tailscale up` manually to authenticate
    };
  };
}