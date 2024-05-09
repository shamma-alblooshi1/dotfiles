# SPDX-License-Identifier: Apache-2.0
{
  self,
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.setup.device;
in {
  imports = lib.flatten [
    (with self.nixosModules;
      [
        hardening
        system-packages
        user-bmg
        user-groups
        xdg
        scripts
      ]
      ++ [inputs.nix-index-database.nixosModules.nix-index])
    [
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit inputs;};
        home-manager.users.shamma = {
          imports =
            lib.optionals cfg.isClient [(import ../home/home-client.nix)]
            ++ lib.optionals cfg.isServer [(import ../home/home-server.nix)]
            ++ [inputs.nix-index-database.hmModules.nix-index];
        };
      }
    ]
  ];

  options = {
    setup.device.isClient = lib.mkEnableOption "System is a client device";
    setup.device.isServer = lib.mkEnableOption "System is a server (headless device)";
  };

  config = {
    nixpkgs.config.allowUnfree = true;
    # Enable developer documentation (man 3) pages
    documentation = {
      dev.enable = true;
      # This is slow for the first build
      # man.generateCaches = true;
    };

    nix = {
      # This will add each flake input as a registry
      # To make nix3 commands consistent with your flake
      registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        system-features = ["nixos-test" "benchmark" "big-parallel" "kvm"];

        # Avoid copying unecessary stuff over SSH
        builders-use-substitutes = true;
        trusted-users = ["root" "shamma"];
        auto-optimise-store = true; # Optimise syslinks
        keep-outputs = true; # Keep outputs of derivations
        keep-derivations = true; # Keep derivations
      };

      # Garbage collection
      optimise.automatic = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = pkgs.lib.mkDefault "--delete-older-than 7d";
      };

      # extraOptions = ''
      #   plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.so
      # '';

      #https://nixos.wiki/wiki/Distributed_build#NixOS
      buildMachines = [
        {
          hostName = "awsarm";
          system = "aarch64-linux";
          maxJobs = 8;
          speedFactor = 1;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          mandatoryFeatures = [];
          #TODO Fix this
          sshUser = "shamma";
          sshKey = "/home/shamma/.ssh/builder-key";
        }
        {
          hostName = "vedenemo-builder";
          system = "x86_64-linux";
          maxJobs = 8;
          speedFactor = 1;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          mandatoryFeatures = [];
          #TODO Fix this
          sshUser = "bmg";
          sshKey = "/home/shamma/.ssh/builder-key";
        }
      ];

      distributedBuilds = true;
    };

    # Sometimes it fails if a store path is still in use.
    # This should fix intermediate issues.
    systemd.services.nix-gc.serviceConfig = {
      Restart = "on-failure";
    };

    # Common network configuration
    # The global useDHCP flag is deprecated, therefore explicitly set to false
    # here. Per-interface useDHCP will be mandatory in the future, so this
    # generated config replicates the default behaviour.
    networking = {
      useDHCP = false;
      enableIPv6 = false;
      #Open ports in the firewall?
      firewall = {
        enable = true;
      };
      nftables.enable = true;
    };

    ## Local config
    programs = {
      ssh = {
        startAgent = true;
        extraConfig = ''
          Host awsarm
               HostName awsarm.vedenemo.dev
               Port 20220
          Host nephele
               Hostname 65.109.25.143
               Port 22
          host ghaf-net
               user ghaf
               hostname 192.168.10.108
          host ghaf-host
               user ghaf
               hostname 192.168.101.2
               proxyjump ghaf-net
          host vedenemo-builder
               user bmg
               hostname builder.vedenemo.dev
          host caelus
               hostname 95.217.167.39
        '';
        knownHosts = {
          awsarm-ed25519 = {
            hostNames = ["awsarm.vedenemo.dev"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3f7tAAO3Fc+8BqemsBQc/Yl/NmRfyhzr5SFOSKqrv0";
          };
          awsarm-rsa = {
            hostNames = ["awsarm.vedenemo.dev"];
            publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtP5yuGAaMGK4GPsViPCIZvaPXN2tPoZH59i6CtPA1Vg8JzRX9g2PgFmUbNtQ9nxQhtUlVbNddCxoEKPJt+VgL/23o1DXM+EauuGOp9PijfcNqDq2jvwW1yoCnxMyA53vC7gR6CYGdu9BhQJYK9S4SaHtf4RcfUa39uWPfUCIKUyG9vB+T9p7E86O+pLBMRpAvppitFLdkxgAYZeedFUvhIQQZlTTJ7ELT3bJry5S+aBck83uZuU1guklyvCR9cZLMiAG2N4Goo/mH11kS4ytMV0AvpY2x4qY40wQvb3gGDYj53WArTkTf52yHELDbtCnjlwFW+5hJBog6CQaxy0S8eSN4MBbM2czmXh3sofwW7iB3iXr6q7IpTzcpeaiawau/OucTBnjVF+wm8C8MV3ekmEyTD+xEGQxESgJgqTLnHD3EKWm4qCTZBhq+XuazVP60eKvK5OVcIxsKHP4WO0YvP8oyjT62ur60wVKtJ2FJ3f0SAtSM2igV2KuDgdi3lek=";
          };
          awsarm-eddsa = {
            hostNames = ["awsarm.vedenemo.dev"];
            publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNH+bPKgI9X7G1/MYq8fUSIkOyL2TmhH0quYlbX8fb9Z0AG6qRcNHaoFFIJaKxWEcAafo+hZNI1A9LKsY9MYXtE=";
          };
          vedenemo-builder = {
            hostNames = ["builder.vedenemo.dev"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSI8s/wefXiD2h3I3mIRdK+d9yDGMn0qS5fpKDnSGqj";
          };
          nephele = {
            hostNames = ["65.109.25.143"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFwoWKmFa6B9SBci63YG0gaP2kxhXNn1vlMgbky6LjKr";
          };
          caelus = {
            hostNames = ["95.217.167.39"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHrlodsjLMgGSEM0+NP+0FN7MD6gkySxo7ydKWxP44w";
          };
        };
      };
      # Disable in favor of nix-index-database
      command-not-found = {
        enable = false;
      };
    };

    # Contents of the user and group files will be replaced on system activation
    # Ref: https://search.nixos.org/options?channel=unstable&show=users.mutableUsers
    users.mutableUsers = false;

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;

    boot = {
      # use the bleeding edge kernel
      # should this be changed for the nvidia issues
      kernelPackages = pkgs.linuxPackages_latest;
      binfmt.emulatedSystems = [
        "riscv64-linux"
        "aarch64-linux"
      ];
    };
  };
  #TODO Enable and/or move
  #sops.defaultSopsFile = ./secrets/common.yaml;
}
