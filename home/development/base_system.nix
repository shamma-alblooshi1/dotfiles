{pkgs, ...}: {
  # A selection of packages that are used in most standard environments
  # Building plugins
  # providing plugins (nodejs)
  #
  home.packages = with pkgs; [
    # Generic code
    cmake
    coreutils
    gnumake
    nodejs
    bibtool
    llvm
    gcc
    nixos-generators
    clang-tools
    bear
    vscode

    #python
    # python312
    # python312Packages.virtualenv
    # python312Packages.pip
    # python312Packages.mcp
    # python312Packages.mcp
    # python312Packages.pydantic

    #ollama
    ollama
    uv
    teams-for-linux

    #open-webui
    open-webui

    #jan
    jan
  ];
}
