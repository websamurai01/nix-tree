{ ... }:

{
  flake.nixosModules.thunar = { dotfiles, ... }: {
    programs.thunar.enable = true;

    services.gvfs.enable = true;
    services.tumbler.enable = true;
    services.udisks2.enable = true;

    hm.file = {
      ".config/Thunar" = dotfiles.link ".config/Thunar";
      ".config/xfce4" = dotfiles.link ".config/xfce4";
    };
  };
}
