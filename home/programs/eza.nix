{ config, lib, pkgs, ... }:

{

  programs.eza = {
    enable = true;
    enableZshIntegration = true; # Enables default eza aliases for Zsh
    icons = "auto";
    colors = "auto"; # Configure eza to use colors automatically
    extraOptions = [ "--group-directories-first" "--classify" ]; # Common flags for eza
  };

  # Define or override eza-related Zsh aliases here.
  # These will merge with/override the defaults provided by enableZshIntegration.
  # The `eza` command in these aliases will automatically use `icons`, `colors`, and `extraOptions`.
  programs.zsh.shellAliases = {
    # Default 'ls' (eza) and 'la' (eza -a) from eza module are likely fine.
    # Default 'lt' (eza --tree) from eza module.

    # Custom 'll' alias
    ll = "eza -l -a --header --group"; # -l for long, -a for all, plus header and group

    # Custom 'lst' alias (similar to default 'lt')
    lst = "eza --tree";

    # Custom 'llt' alias (custom ll + tree)
    llt = "eza -l -a --header --group --tree";

    # Custom 'tree' alias (similar to default 'lt')
    tree = "eza --tree";
  };
}
