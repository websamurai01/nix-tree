{ ... }:

{
  flake.nixosModules.xremap = { pkgs, dotfiles, ... }: {
    environment.systemPackages = [ pkgs.xremap ];

    hm.file.".config/xremap" = dotfiles.link ".config/xremap";
  };
}
