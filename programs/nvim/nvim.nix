{ ... }:

{
  flake.nixosModules.nvim = { pkgs, dotfiles, ... }: {
    environment.systemPackages = [ pkgs.neovim ];

    hm.file.".config/nvim" = dotfiles.link ".config/nvim";
  };
}
