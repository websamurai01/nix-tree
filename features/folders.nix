{ ... }:

{
  flake.nixosModules.folders = { dotfiles, ... }: {
    hm.file = {
      ".applications" = dotfiles.link ".applications";
      ".bashrc" = dotfiles.link ".bashrc";
      ".commands" = dotfiles.link ".commands";
      ".scripts" = dotfiles.link ".scripts";
      "Wallpapers" = dotfiles.link "Wallpapers";
    };
  };
}
