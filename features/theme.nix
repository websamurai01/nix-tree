{ ... }:

{
  flake.nixosModules.theme =
    { pkgs, dotfiles, ... }:
    let
      # Apple does not allow redistribution: AppleColorEmoji.ttf is a manual
      # asset in the dotfiles worktree (116 MB, not in git).
      # It cannot go into fonts.packages. A flake is evaluated in pure mode,
      # where nix may not read files outside the flake, so no store copy is
      # possible. The directory goes into fontconfig as a plain path string
      # and fontconfig scans it at runtime.
      appleEmojiDir = "${dotfiles.dotfilesPath}/Fonts";
    in
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
          # On purpose there is no second colour emoji font: with two of them
          # the glyph fallback is a lottery over fontconfig directory order.
          # Apple is the only one left, so every fontconfig app picks it.
        ];

        fontconfig = {
          enable = true;
          useEmbeddedBitmaps = true;

          localConf = ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
            <fontconfig>
              <dir>${appleEmojiDir}</dir>
            </fontconfig>
          '';

          defaultFonts = {
            serif = [ "Noto Serif" "Noto Serif CJK SC" ];
            sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
            monospace = [ "CommitMono Nerd Font" ];
            emoji = [ "Apple Color Emoji" ];
          };
        };
      };

      # Firefox ignores fontconfig for emoji: it has its own preference list
      # and ships its own Twemoji. A policy file is the only place that works
      # for every profile without touching the profile itself.
      environment.etc."firefox/policies/policies.json".text = builtins.toJSON {
        policies.Preferences = {
          # gfxPlatformGtk::GetCommonFallbackFonts hardcodes the bundled
          # "Twemoji Mozilla" first for colour emoji, before system fonts.
          # With bundled fonts off it cannot, and the system font is used.
          "gfx.bundled-fonts.activate" = {
            Value = 0;
            Status = "locked";
          };
          # font.name-list.emoji cannot go through a policy here. The
          # Preferences policy allows only a fixed list of name prefixes
          # (gfx., browser., media., ...) and font.* is not in it, so the
          # pref is rejected and the policy shows up as "not fully applied".
          # Firefox keeps its default "Noto Color Emoji, Twemoji Mozilla";
          # fonts.conf maps those names onto Apple instead.
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
