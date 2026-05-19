{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.t580Hardware = {
    config,
    pkgs,
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "sd_mod"
    ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    # NOTE: These UUIDs are from the source machine — replace them after
    # running `nixos-generate-config` on this machine.
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/1227c054-d6c2-48a0-b4cc-e75091dd7b0b";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/8A22-C0E6";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/7855be24-9997-44af-9454-3b82b4f56167";}
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
