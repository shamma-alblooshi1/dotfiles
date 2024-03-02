{pkgs, ...}: {
  home.packages = with pkgs; [
    #Modern Linux tools
    cheat
    delta # TODO configure in .gitconfig https://dandavison.github.io/delta/configuration.html   (DELTA_PAGER)
    dog
    fd # faster projectile indexing
    (ripgrep.override {withPCRE2 = true;})
    tree
    psmisc
    shfmt
    shellcheck
  ];

  programs = {
    pandoc.enable = true;

    bat = {
      enable = true; # BAT_PAGER
      config = {
        theme = "Dracula";
      };
    };

    htop.enable = true; # TODO enable the correct layout

    starship.enable = true;

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      enableAliases = true;
    };

    bash = {
      enable = true;
      initExtra = ''
        eval "$(ssh-agent -s)"
      '';
    };

    nix-index.enable = true;
  };
  home.shellAliases = {
    cat = "bat";
  };
}
