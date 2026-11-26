{ ... }:

{
  flake.nixosModules.fish = { dotfiles, ... }: {
    hm.file.".config/fish" = dotfiles.link ".config/fish";
  };
}
