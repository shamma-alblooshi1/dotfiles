# SPDX-License-Identifier: Apache-2.0
{
  inputs,
  self,
  lib,
  ...
}: {
  flake.nixosModules = {
    # shared modules
    common-client = import ./common-client.nix;
    common-server = import ./common-server.nix;

    # host modules
    host-nephele = import ./nephele;
    host-caelus = import ./caelus;
    host-lenovo = import ./lenovo;
  };

  flake.nixosConfigurations = let
    # make self and inputs available in nixos modules
    specialArgs = {inherit self inputs;};
  in {

    nephele = lib.nixosSystem {
      inherit specialArgs;
      modules = [self.nixosModules.host-nephele];
    };

    caelus = lib.nixosSystem {
      inherit specialArgs;
      modules = [self.nixosModules.host-caelus];
    };

    lenovo = lib.nixosSystem {
      inherit specialArgs;
      modules = [self.nixosModules.host-lenovo];
    };
 
  };
}
