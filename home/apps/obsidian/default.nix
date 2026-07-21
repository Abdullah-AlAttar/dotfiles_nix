{
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.obsidian.override { electron = pkgs.electron_42; })
  ];
}
