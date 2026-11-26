{ inputs, self, ... }:

{
  flake.nixosConfigurations.home = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules =
      [
        inputs.disko.nixosModules.disko
        inputs.ungoogled.nixosModules.default

        ./hardware.nix
        ./disko.nix
        ./network.nix
        ./packages.nix
        ./system.nix
        ./home-manager.nix
        ./microvm.nix
      ]
      ++ (with self.nixosModules; [
        # Core
        id
        dotfiles
        system

        # Modules
        home-manager
        web-apps
        folders
        theme
        audio
        bluetooth
        games

        # Programs
        chromium
        figma
        photopea
        youtube
        librechat
        hyprland
        thunar
        v2raya
        direnv
        awww
        polkit-agent

        alacritty
        fish
        foot
        fuzzel
        imv
        kitty
        mako
        mimeapps
        mpv
        nvim
        nvim-notes
        podman
        repomix
        uwsm
        waybar
        xremap

        # Scripts
        rebuild
        ns
        nt
      ]);
  };
}
