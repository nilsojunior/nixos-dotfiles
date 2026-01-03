{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.userSettings.kitty;
    # font = config.userSettings.font;
in
{
    options = {
        userSettings.kitty.enable = lib.mkEnableOption "Enable Kitty";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.kitty ];
        programs.kitty.enable = true;
        programs.kitty.settings = {
            shell_integration = "no-cursor";
            font_size = 19.0;
            # font_family = font;
            confirm_os_window_close = 0;
            copy_on_select = "yes";
            cursor_blink_interval = 0;
            enable_audio_bell = "no";
        };
    };
}
