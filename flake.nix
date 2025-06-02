# SPDX-License-Identifier: MIT
{
  description = "First honest attempt to declare a system";

   nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Nix Packages, following unstable (rolling release)
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs

    # Make the system more modular
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
    flake-utils.url = "github:numtide/flake-utils";

    # Formatting
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For preserving compatibility with non-Flake systems
    # Useful for the first bootstrap from a clean nixos install
    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dotfiles style package management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Disko for disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # index of the nixpkgs
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixd lsp integration
    nixd = {
      url = "github:nix-community/nixd";
    };

    # for provisioning secrets that can be embedded in the configuration
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    mcp-nixos = {
      url = "github:utensils/mcp-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.devshell.follows = "devshell";
    };

    claude-desktop = {
      url =  "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };


    #TODO add the following for more managable configs
    #https://github.com/ehllie/ez-configs/tree/main
    # Part of flake-parts modules
    # See example usage
    # https://github.com/ehllie/dotfiles/tree/main
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake
    {
      inherit inputs;
      specialArgs = {
        inherit (nixpkgs) lib;
      };
    } {
      systems = [
        "x86_64-linux"
        #"aarch64-linux"
        #"aarch64-darwin"
      ];

      imports = [
        ./home
        ./hosts
        ./nix
        ./nixos
        ./users
        ./packages
      ];

      debug = true;
    };
}
