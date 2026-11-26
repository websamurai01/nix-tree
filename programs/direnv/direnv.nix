{ ... }:

{
  flake.nixosModules.direnv = { ... }: {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;

      # Load dev shells declared in flake.nix.
      nix-direnv.enable = true;
    };
  };
}
