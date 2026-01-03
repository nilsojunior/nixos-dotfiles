{
    config,
    lib,
    pkgs,
    ...
}:
let
    terminal = config.userSettings.terminal;
in
{
    imports = [
        ./kitty.nix
    ];

    options = {
        userSettings.terminal = lib.mkOption {
            type = lib.types.enum [
                "kitty"
            ];
            default = "kitty";
            description = "Default Terminal";
        };
    };

    config = {
        userSettings.kitty.enable = lib.mkIf (terminal == "kitty") true;
        home.sessionVariables = {
            TERMINAL = terminal;
        };
    };
}
