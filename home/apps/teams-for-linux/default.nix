# teams-for-linux — config to open links in Microsoft Edge instead of the default browser
{pkgs, ...}: {
  home.packages = [pkgs.teams-for-linux];

  home.file.".config/teams-for-linux/config.json".text = builtins.toJSON {
    defaultURLHandler = "microsoft-edge";
  };
}
