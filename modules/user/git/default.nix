{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.userSettings.git;
in
{
    options = {
        userSettings.git.enable = lib.mkEnableOption "Enables Git";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            git
        ];

        services.ssh-agent.enable = true;

        programs.git = {
            enable = true;
            signing.format = "ssh";
            signing.key = "~/.ssh/id_ed25519.pub";
        };

        programs.git.settings = {
            user = {
                name = "Nilso Júnior";
                email = "162613094+Nilsojunior@users.noreply.github.com";
            };

            init.defaultBranch = "main";
            commit.gpgSign = true;
            push.autoSetupRemote = true;
            url = {
                "https://github.com/nilsojunior/" = {
                    insteadOf = "nj:";
                };
                "https://github.com/" = {
                    insteadOf = "gh:";
                };
            };
        };
    };
}
