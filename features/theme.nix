{ ... }:

{
  flake.nixosModules.theme =
    { pkgs, dotfiles, ... }:
    {
      fonts = {
        enableDefaultPackages = true;

        packages = with pkgs; [
          fixedsys-excelsior
          nerd-fonts.commit-mono
          commit-mono
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          twitter-color-emoji
        ];

        fontconfig = {
          enable = true;
          useEmbeddedBitmaps = true;

          defaultFonts = {
            serif = [ "Noto Serif" "Noto Serif CJK SC" ];
            sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
            monospace = [ "CommitMono Nerd Font" ];
            emoji = [ "Twitter Color Emoji" ];
          };
        };
      };

      programs.dconf.enable = true;

      hm = {
        file = {
          ".config/fontconfig" = dotfiles.link ".config/fontconfig";
          ".config/gtk-3.0/bookmarks" = dotfiles.link ".config/gtk-3.0/bookmarks";
          ".config/qt5ct" = dotfiles.link ".config/qt5ct";
          ".config/qt6ct" = dotfiles.link ".config/qt6ct";
        };

        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            cursor-theme = "Adwaita";
          };
        };

        gtk = {
          enable = true;

          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };

          font = {
            name = "Noto Sans";
            size = 11;
          };

          gtk3.extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
        };

        qt = {
          enable = true;
          platformTheme.name = "qtct";
        };
      };
    };
}
