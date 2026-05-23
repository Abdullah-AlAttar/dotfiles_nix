{
  config,
  inputs,
  ...
}: {
  flake.modules.homeManager.mainPC = {pkgs, ...}: {
    imports = with config.flake.modules.homeManager; [
      base
      nixosExtras
      shell
      dev
      gui
    ];

    home.packages =
      (with pkgs; [scrcpy])
      ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
        opencode
        copilot-cli
        spec-kit
      ]);
  };
}
