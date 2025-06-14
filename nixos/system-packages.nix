{pkgs,inputs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    cachix
    wget
    curl
    git
    htop
    nix-info
    wireguard-tools
    tree
    file
    binutils
    lsof
    dnsutils
    netcat
    usbutils
    pciutils
    #Documentation
    linux-manual
    man-pages
    man-pages-posix
    nix-doc
    nix-tree
    vscode
    nix-eval-jobs
    iptables
    openconnect
    globalprotect-openconnect
    wireshark
    #MCP
    github-mcp-server
    inputs.mcp-nixos.packages."${pkgs.system}".default
    alpaca
    aider-chat
    #Claude Desktop
    inputs.claude-desktop.packages."${system}".claude-desktop
    inputs.claude-desktop.packages."${system}".claude-desktop-with-fhs

    #devenv
     devenv
  ];
}
