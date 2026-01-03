{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.systemSettings.sshd;
in
{
    options = {
        systemSettings.sshd.enable = lib.mkEnableOption "Enable SSH Daemon";
    };

    config = lib.mkIf cfg.enable {
        services.openssh = {
            enable = true;
            settings = {
                PasswordAuthentication = false;
                PermitRootLogin = "no";
            };
        };
    };
}
