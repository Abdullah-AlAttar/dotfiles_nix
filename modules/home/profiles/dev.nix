{ ... }: {
  flake.modules.homeManager.dev.imports = [
    ../../../home/programs/helix
    ../../../home/programs/go
    ../../../home/programs/neovim
    ../../../home/programs/k9s

    ../../../home/programs/kubernetes.nix
    ../../../home/programs/direnv
  ];
}
