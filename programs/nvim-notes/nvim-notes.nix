{ ... }:

{
  flake.nixosModules.nvim-notes = { dotfiles, ... }: {
    hm.file.".config/nvim-notes" = dotfiles.link ".config/nvim-notes";
  };
}
