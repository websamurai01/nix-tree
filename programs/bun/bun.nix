{ ... }:

{
  flake.nixosModules.bun = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.bun ];
  };
}
