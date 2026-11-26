{ ... }:

{
  flake.nixosModules.uwsm = { dotfiles, ... }: {
    hm.file.".config/uwsm" = dotfiles.link ".config/uwsm";
  };
}
