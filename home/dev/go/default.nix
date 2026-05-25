{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.go = {
    enable = true;
    package = pkgs.go;
    env = {
      GOPATH = "${config.home.homeDirectory}/go";
      GOPRIVATE = "gitlab.mocca.yunextraffic.cloud";
    };
  };

  home.packages = with pkgs; [
    # Install these via Nix so they stay stable
    gopls # Language Server
    delve # Debugger
    golangci-lint # Linter

    # Your other tools
    go-task
    process-compose
    kaf
  ];

  # Just in case you manually 'go install' something else later
  home.sessionPath = ["$HOME/go/bin"];
}
