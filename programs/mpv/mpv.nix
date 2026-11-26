{ ... }:

{
  flake.nixosModules.mpv = { pkgs, dotfiles, ... }: {
    environment.systemPackages = [ pkgs.mpv ];

    hm.file.".config/mpv" = dotfiles.link ".config/mpv";
  };
}
