{ ... }:

let
  id = {
    user = "hash";
    email = "reifzisdlefux@gmail.com";
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOCLOWozNoUPD3hRrUBQsx3umKjgsJT6F2RPrzxNvgek reifzisdlefux@gmail.com";
    repoPath = "/home/hash/nix-tree";
  };
in
{
  flake.nixosModules.id = { ... }: {
    _module.args.id = id;
  };
}
