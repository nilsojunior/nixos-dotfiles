{
    config,
    lib,
    pkgs,
    ...
}:
let
    browser = config.userSettings.browser;
in
{
    imports = [
        ./firefox.nix
    ];

    options = {
        userSettings.browser = lib.mkOption {
            type = lib.types.enum [
                "firefox"
                null
            ];
            default = null;
            description = "Default Browser";
        };
    };

    config = {
        userSettings.firefox.enable = lib.mkIf (browser == "firefox") true;
        home.sessionVariables.BROWSER = browser;
    };
}
