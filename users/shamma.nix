# SPDX-License-Identifier: Apache-2.0
_: {
  users.users = {
    shamma = {
      isNormalUser = true;
      home = "/home/shamma";
      description = "shamma";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3w7NzqMuF+OAiIcYWyP9+J3kwvYMKQ+QeY9J8QjAXm shamma-alblooshi@tii.ae"
      ];
      extraGroups = ["networkmanager" "wheel" "dialout" "plugdev"];
      #Set an initial dummy "Password" for the first boot
      # sudo -i ; passwd <username>
      password= "shamooh@2017";
      #hashedPassword = "$6$F0XwJUE0WhvpDo89$RTU5XkHAa50JcxzGClbzmIZjAP80v/TrqGq.WbkxGbXaotf9.er8mbMO/w2lIvwmCHNeCLJznG7TGhziPDtyf/";
    };
  };
}
