{ ... }:

{
  flake.nixosModules.system =
    { pkgs, lib, id, ... }:
    {
      time.timeZone = "Europe/Moscow";
      i18n.defaultLocale = "en_US.UTF-8";

      nixpkgs.config.allowUnfree = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      system.stateVersion = "25.11";

      programs.fish.enable = true;

      security.polkit.enable = true;

      hardware.uinput.enable = true;

      services.udev.extraRules = ''
        KERNEL=="uinput", GROUP="uinput", MODE="0660"
        KERNEL=="event*", GROUP="input", MODE="0660"
      '';

      users.users.${id.user} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "input"
          "uinput"
          "audio"
          "video"
          "podman"
        ];
        shell = pkgs.fish;
        autoSubUidGidRange = true;
        # Box has no other way in than ssh on port 2223.
        openssh.authorizedKeys.keys = lib.optional (id.sshKey != "") id.sshKey;
      };

      services.getty.autologinUser = id.user;

      security.sudo.extraRules = [
        {
          users = [ id.user ];
          commands = [
            {
              command = "/run/current-system/sw/bin/killall";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/awg-quick";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/nixos-rebuild";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
}
