{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.userSettings.spotify;
in
{
    options = {
        userSettings.spotify.enable = lib.mkEnableOption "Enables Spotify";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.spotify ];
    };
}
