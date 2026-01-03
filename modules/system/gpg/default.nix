{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.systemSettings.gpg;
in
{
    options = {
        systemSettings.gpg.enable = lib.mkEnableOption "Enable GPG";
    };

    config = lib.mkIf cfg.enable {
        programs.gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
        };
    };
}
