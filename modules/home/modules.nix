# Exposes Home Manager modules as flake.homeModules for per-host selection.
# Each host imports the categories it needs via self.homeModules.<name>.
{lib, ...}: {
  flake.homeModules = {
    common = import ../../home/common.nix;
    cli = import ../../home/cli/default.nix;
    dev = import ../../home/dev/default.nix;
    apps = import ../../home/apps/default.nix;
    system = import ../../home/system/default.nix;

    # OPT-IN: hosts that need user-level secrets import this explicitly.
    # It is NOT in defaultHomeManager — each host opts in via its home-manager.nix.
    sops = import ../../home/system/sops.nix;
  };
}
