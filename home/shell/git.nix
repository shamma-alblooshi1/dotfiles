{pkgs, ...}: {
  # TODO add conf file and settings and secrets store
  #

  #TODO change this to use the keys from github .keys by default
  home.file.".ssh/allowed_signers".text = "* ${builtins.readFile ../../keys/ssh-keys.txt}";

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "shamma-alblooshi1";
    userEmail = "shamma.albooshi@tii.ae";
    delta.enable = true; # see diff in a new light
    delta.options = {
      line-numbers = true;
      side-by-side = true;
      syntax-theme = "Dracula";
    };
    ignores = ["*~" "*.swp"];
    extraConfig = {
      core.editor = "code --wait";
      color.ui = "auto";
      #credential.helper = "store --file ~/.git-credentials";
      format.signoff = true;
      commit.gpgsign = true;
      tag.gpgSign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      init.defaultBranch = "main";
      #protocol.keybase.allow = "always";
      pull.rebase = "true";
      push.default = "current";
      github.user = "shamma-alblooshi1";
    };
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [gh-poi gh-eco gh-dash gh-markdown-preview gh-copilot];
  };
}
