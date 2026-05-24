{ inputs, ... }: {
  # Enables the flake.modules.* typed registry.
  # Allows each file under modules/ to expose named HM/NixOS modules via
  # flake.modules.homeManager.<name> or flake.modules.nixos.<name>,
  # which can then be composed by name instead of by path.
  imports = [inputs.flake-parts.flakeModules.modules];
}
