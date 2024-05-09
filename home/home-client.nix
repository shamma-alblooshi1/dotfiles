{...}: {
  imports = [
    ./apps
    ./browsers
    ./development
    ./security
    ./shell
  ];

  home = {
    #TODO ask Brian about config
    username = "shamma"; #config.users.users.brian.name;
    homeDirectory = "/home/shamma"; #config.users.users.brian.home;
    stateVersion = "23.11";
  };

  ### A tidy $HOME is a tidy mind
  xdg.enable = true;

  programs = {
    home-manager.enable = true;
  };
}
