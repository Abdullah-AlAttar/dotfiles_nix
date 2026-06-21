# Development tools aggregator — imports all dev program modules.
{pkgs, ...}: {
  imports = [
    ./go
    ./kubernetes.nix
    ./direnv
    ./k9s
  ];

  home.packages = with pkgs; [
    # Git tooling
    lazygit
    glab

    # Databases
    postgresql
    sqlite
    rainfrog

    # Protocol buffers
    buf

    # Dev environments
    process-compose
    dioxus-cli

    # WebAssembly
    binaryen

    # Artifactory / package registry
    jfrog-cli

    # Debugging
    strace

    # Languages (toolchains)
    gcc
    gnumake
    cmake
    llvmPackages_20.clang-tools

    python314
    uv
    meson
    ninja

    nodejs_24
    bun
  ];
}
