{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.bottom = {
    enable = true;
    settings.processes.default_memory_value = true;
  };
}
