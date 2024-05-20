{pkgs, ...}: let
  update-host = pkgs.writeScriptBin "update-host" ''
    pushd $HOME/.dotfiles
    nix flake update
    popd
  '';
  rebuild-host = pkgs.writeScriptBin "rebuild-host" ''
    pushd $HOME/.dotfiles
    sudo nixos-rebuild switch --flake .#$HOSTNAME
    popd
  '';
  rebuild-x1 = pkgs.writeScriptBin "rebuild-x1" ''
    nixos-rebuild --flake .#lenovo-x1-carbon-gen11-debug --target-host "root@ghaf-host" --fast switch
  '';
  #https://discourse.nixos.org/t/install-shell-script-on-nixos/6849/10
  #ownfile = pkgs.callPackage ./ownfile.nix {};
in {
  environment.systemPackages = with pkgs; [
    rebuild-host
    rebuild-x1
    update-host
    #ownfile
  ];
}
