{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.system-specific.enableNativeLinux {
    home.file.".config/alacritty/alacritty.toml" = {
      source = ./alacritty.toml;
    };
  };
}
