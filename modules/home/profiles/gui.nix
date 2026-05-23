{self, ...}: {
  # GUI apps. Each app is gated by programs.system-specific.enableGuiApps
  # internally, so this is safe to include on standalone — nothing installs.
  flake.modules.homeManager.gui.imports = [
    "${self}/home/programs/system-specific"
  ];
}
