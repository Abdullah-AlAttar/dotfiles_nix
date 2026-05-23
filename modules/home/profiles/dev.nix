{self, ...}: {
  flake.modules.homeManager.dev = {pkgs, ...}: {
    imports = [
      "${self}/home/programs/helix"
      "${self}/home/programs/go"
      "${self}/home/programs/neovim"
      "${self}/home/programs/k9s"
      "${self}/home/programs/kubernetes.nix"
      "${self}/home/programs/direnv"
    ];

    home.packages = with pkgs; [
      strace
      sqlite

      ## cpp
      gcc
      gnumake
      cmake
      llvmPackages_20.clang-tools

      ## python
      python314
      uv
      meson
      ninja

      ## node
      nodejs_24
      bun

      ## dev services / tools
      glab
      postgresql
      buf
      jfrog-cli
      devenv
      dioxus-cli
      binaryen
    ];
  };
}
