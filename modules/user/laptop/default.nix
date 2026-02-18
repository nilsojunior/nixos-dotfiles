{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.userSettings.laptop;
in
{
    options = {
        userSettings.laptop = lib.mkEnableOption "Enable Laptop Settings";
    };
}
