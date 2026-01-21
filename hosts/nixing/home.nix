{ config, pkgs, ... }:
{
    imports = [
        ../../modules/user
    ];

    userSettings = {
        hyprland = {
            enable = true;
            nvidia = true;
            config = {
                "$main" = "DP-2";
                "$second" = "HDMI-A-1";
                monitor = [
                    "$main, 1920x1080@240, 0x1080, 1"
                    "$second, 1920x1080@60, 0x0, 1"
                ];
                workspace = [
                    "1, monitor:$main"
                    "2, monitor:$main"
                    "3, monitor:$main"
                    "4, monitor:$main"
                    "5, monitor:$main"
                    "6, monitor:$second"
                    "7, monitor:$second"
                    "8, monitor:$second"
                    "9, monitor:$main"
                    "10, monitor:$main"
                ];
            };
        };
        zsh.enable = true;
        browser = "firefox";
        editor = "nvim";
        terminal = "kitty";
        keepass.enable = true;
        git.enable = true;
        emacs.enable = true;
        stylix = {
            enable = true;
            theme = "gruvboxing";
        };
    };

    programs.ssh.enableDefaultConfig = false;
    programs.ssh = {
        enable = true;

        matchBlocks = {
            "github.com" = {
                hostname = "github.com";
                user = "git";
                addKeysToAgent = "yes";
                identityFile = "~/.ssh/id_ed25519";
            };
        };
    };

    home.username = "nilso";
    home.homeDirectory = "/home/nilso";
    home.stateVersion = "25.11";
}
