{...}: {
  flake.nixosModules.vr = {pkgs, ...}: {
    # ALVR — stream VR to Quest (supports wired USB via ADB since v20.12)
    programs.alvr = {
      enable = true;
      openFirewall = true;
    };

    # Monado — open source OpenXR runtime (required by ALVR/WiVRn)
    services.monado = {
      enable = true;
      defaultRuntime = true;
      forceDefaultRuntime = true;
    };

    # Environment variables for SteamVR + OpenXR runtime detection
    environment.sessionVariables = {
      STEAMVR_LH_ENABLE = "1";
      XR_RUNTIME_JSON = "/run/current-system/sw/share/openxr/1/openxr_monado.json";
    };

    environment.systemPackages = with pkgs; [
      # ADB — required for wired USB connection to Quest
      android-tools

      # OpenVR→OpenXR translation layer (lets SteamVR games use Monado)
      opencomposite

      # Vulkan layer that patches SteamVR for wired HMDs
      steamvr-linux-fixes

      # Test tool to verify OpenXR is working
      xrgears
    ];
  };
}