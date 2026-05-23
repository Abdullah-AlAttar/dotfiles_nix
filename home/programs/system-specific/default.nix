# System-specific configurations
{
  config,
  pkgs,
  lib,
  isNixOS ? false,
  ...
}: let
  # Check if running in WSL by looking for WSL-specific environment
  isWSL = builtins.pathExists /proc/sys/fs/binfmt_misc/WSLInterop || builtins.pathExists /run/WSL;

  # Enable native Linux configurations only on real Linux (not WSL)
  enableNativeLinux = pkgs.stdenv.isLinux && !isWSL;

  # GUI apps should be managed only in NixOS environments on native Linux.
  enableGuiApps = isNixOS && enableNativeLinux;
in {
  imports = [
    ./linux
  ];

  # Option to enable native Linux configurations
  options.programs.system-specific.enableNativeLinux = lib.mkOption {
    type = lib.types.bool;
    default = enableNativeLinux;
    description = "Enable native Linux configurations (excludes WSL/generic Linux)";
  };

  options.programs.system-specific.enableGuiApps = lib.mkOption {
    type = lib.types.bool;
    default = enableGuiApps;
    description = "Enable GUI application modules only on NixOS native Linux systems.";
  };
}
