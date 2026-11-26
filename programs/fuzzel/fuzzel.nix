{ ... }:

{
  flake.nixosModules.fuzzel = { pkgs, dotfiles, ... }: {
    environment.systemPackages = [ pkgs.fuzzel ];

    hm.file.".config/fuzzel" = dotfiles.link ".config/fuzzel";
  };
}
