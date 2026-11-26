{ ... }:

{
  flake.nixosModules.hyprland =
    { pkgs, dotfiles, ... }:
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      environment.systemPackages = with pkgs; [
        hyprshot
        hyprpicker
      ];

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
          pkgs.kdePackages.xdg-desktop-portal-kde
        ];
        config = {
          common.default = [ "kde" ];
          hyprland.default = [ "hyprland" "kde" ];
        };
      };

      hm.file.".config/hypr" = dotfiles.link ".config/hypr";
    };
}
