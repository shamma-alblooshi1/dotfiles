# SPDX-License-Identifier: Apache-2.0
{
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      treefmt = config.treefmt.build.wrapper;
      packages = with pkgs; [
        git
        nix
        nixos-rebuild
        #TODO Reenable
        #sops-nix
        sops
        ssh-to-age
        nix
        nix-eval-jobs
      ];
    };
  };
}
