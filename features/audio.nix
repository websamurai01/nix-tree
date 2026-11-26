{ ... }:

{
  flake.nixosModules.audio = { dotfiles, ... }: {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    hm.file.".config/wireplumber" = dotfiles.link ".config/wireplumber";
  };
}
