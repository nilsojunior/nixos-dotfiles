{
    config,
    lib,
    pkgs,
    ...
}:
let
    user = config.systemSettings.user;
in
{
    options = {
        systemSettings.user = lib.mkOption {
            description = "The user for the system";
            type = lib.types.str;
            default = "nilso";
        };
    };

    config = {
        users.users.${user} = {
            isNormalUser = true;
            extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        };

        home-manager.users.${user} = {
            home = {
                username = user;
                homeDirectory = "/home/${user}";
            };
        };
    };
}
