# SPDX-License-Identifier: MIT
 { self, config, lib, pkgs, ... }:
 
 {
  #Set the baseline with common.nix
  imports = [self.nixosModules.common-client self.nixosModules.sshd];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Origionally in hardware-configuration.nix
  boot = {
    initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1b039db6-9d5d-42cd-9997-2f3ec436e988";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8603-FAA8";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [];

 
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.interfaces.wlp0s20f3.useDHCP = true;

  #TODO Replace this with the name of the nixosConfiguration so it can be common
  # Define your hostname
  networking.hostName = "lenovo";

 

  # Configure keymap in X11
  services.xserver.xkb = {
    # services.xserver.xkb.layout = "us";
    # services.xserver.xkb.options = "eurosign:e,caps:escape";
  };

  console.useXkbConfig = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
