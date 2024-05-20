# SPDX-License-Identifier: Apache-2.0
_: {
  #Just setup the access keys that can login to service the system
  users.users.root.openssh = {
    authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3w7NzqMuF+OAiIcYWyP9+J3kwvYMKQ+QeY9J8QjAXm shamma-alblooshi@tii.ae"
    ];
  };
}
