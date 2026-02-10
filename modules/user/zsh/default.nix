{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.userSettings.zsh;
in
{
    options = {
        userSettings.zsh.enable = lib.mkEnableOption "Enables Zsh";
    };

    config = lib.mkIf cfg.enable {
        programs.zsh = {
            enable = true;
            profileExtra = /* bash */ ''
                if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
                    exec start-hyprland
                fi
            '';
            shellAliases = {
                v = "nvim";
            };
        };
    };
}
