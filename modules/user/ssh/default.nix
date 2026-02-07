{
    lib,
    config,
    ...
}:
let
    cfg = config.userSettings.ssh;
in
{
    options = {
        userSettings.ssh.enable = lib.mkEnableOption "Enable SSH";
    };

    config = lib.mkIf cfg.enable {
        programs.ssh = {
            enable = true;
            enableDefaultConfig = false;
            matchBlocks = {
                "github.com" = {
                    hostname = "github.com";
                    user = "git";
                    addKeysToAgent = "yes";
                    identityFile = "~/.ssh/id_ed25519";
                };

                "nix-droid" = {
                    hostname = "192.168.1.183";
                    user = "u0_a184";
                    port = 3435;
                    identityFile = "~/.ssh/id_rsa";
                };
            };
        };
    };
}
