{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.userSettings.keepass;
in
{
    options = {
        userSettings.keepass.enable = lib.mkEnableOption "Enable Keepass";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            keepassxc
        ];

        programs.keepassxc = {
            enable = true;
            settings = {
                Browser = {
                    Enabled = true;
                    # https://mynixos.com/home-manager/option/programs.keepassxc.enable
                    UpdateBinaryPath = false;
                };
            };
        };
    };
}
