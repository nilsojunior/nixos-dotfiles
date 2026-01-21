{
    config,
    lib,
    pkgs,
    ...

}:
let
    cfg = config.systemSettings.stylix;
    theme = import (../../themes + ("/" + config.systemSettings.stylix.theme));
    font = config.systemSettings.stylix.font;
in
    {
        options = {
            systemSettings.stylix = {
                enable = lib.mkEnableOption "Enables Stylix";
                theme = lib.mkOption {
                    type = lib.types.str;
                    description = "Theme name for Stylix";
                    default = "gruvbox-dark-hard";
                };
                font.name = lib.mkOption {
                    type = lib.types.str;
                    default = "Caskaydia Cove Nerd Font";
                    description = "Font name for Stylix";
                };
                font.package = lib.mkOption {
                    type = lib.types.package;
                    default = pkgs.nerd-fonts.caskaydia-cove;
                    description = "Font package for Stylix";
                };
                font.size = lib.mkOption {
                    type = lib.types.int;
                    default = 19;
                    description = "Font size for Stylix";
                };
            };
        };

        config = lib.mkIf cfg.enable {
            stylix = {
                enable = true;
                base16Scheme = theme;
                fonts = {
                    monospace = {
                        name = font.name;
                        package = font.package;
                    };
                    serif = {
                        name = font.name;
                        package = font.package;
                    };
                    sansSerif = {
                        name = font.name;
                        package = font.package;
                    };
                    emoji = {
                        name = "Twitter Color Emoji";
                        package = pkgs.twitter-color-emoji;
                    };
                    sizes = {
                        terminal = font.size;
                    };
                };
            };
        };
    }
