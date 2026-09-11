# Gortex (github.com/zzet/gortex) daemon as a user-level systemd service.
# gortex itself is installed out-of-band (its own installer, not nixpkgs), so this
# unit is conditional on the binary existing: ConditionPathExists skips the unit
# (not a failure, no restart loop) when gortex hasn't been installed yet.
{config, ...}: {
  systemd.user.services.gortex-daemon = {
    Unit = {
      Description = "Gortex code-graph daemon";
      ConditionPathExists = "${config.home.homeDirectory}/.local/bin/gortex";
    };

    Service = {
      ExecStart = "${config.home.homeDirectory}/.local/bin/gortex daemon start";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
