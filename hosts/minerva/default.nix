# SPDX-License-Identifier: MIT
{
  self,
  lib,
  ...
}: {
  #Set the baseline with common.nix
  imports = [self.nixosModules.common-client self.nixosModules.sshd];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Origionally in hardware-configuration.nix
  boot = {
    initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    # Setup keyfile
    initrd.secrets = {"/crypto_keyfile.bin" = null;};
    initrd.luks.devices."luks-beb21201-376c-48a7-bd8f-d1fe91210548".device = "/dev/disk/by-uuid/beb21201-376c-48a7-bd8f-d1fe91210548";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f9a590f0-3553-4e57-a477-91d291999797";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/C0B0-A8A8";
    fsType = "vfat";
  };

  swapDevices = [];

  #  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "conservative";
  };

  hardware.cpu.intel.updateMicrocode = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.interfaces.wlp0s20f3.useDHCP = true;

  #TODO Replace this with the name of the nixosConfiguration so it can be common
  # Define your hostname
  networking.hostName = "minerva";

  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.7.0.7/24"];
      dns = ["172.26.0.2"];
      privateKeyFile = "/root/wireguard-keys/privatekey";

      peers = [
        {
          publicKey = "3xZ1Ug4n8XrjZqlrrrveiIPQq3uyMtxuJXII3vCwyww=";
          presharedKeyFile = "/root/wireguard-keys/preshared_from_bmg-ls_key";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "35.178.208.8:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    options = "ctrl:swapcaps";
    #gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swapcaps']"
    #gsettings reset org.gnome.desktop.input-sources xkb-options
    #gsettings reset org.gnome.desktop.input-sources sources
    #localectl
  };

  console.useXkbConfig = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
