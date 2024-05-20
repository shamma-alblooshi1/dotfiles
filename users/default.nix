# SPDX-License-Identifier: Apache-2.0
{
  flake.nixosModules = {
    user-shamma = import ./shamma.nix;
    user-groups = import ./groups.nix;
    user-root = import ./root.nix;
  };
}
