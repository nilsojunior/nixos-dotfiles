{ config, lib, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/system
    ];

    boot.initrd.luks.devices.crypt = {
        device = "/dev/disk/by-partuuid/c0b7beb9-e90a-4643-9dd2-46dd74b7c4f1";
    };

    nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
            "spotify"
        ];

    systemSettings = {
        user = "nilso";
        pipewire.enable = true;
        hyprland.enable = true;
        stylix = {
            enable = true;
            theme = "gruvboxing";
        };
        kanata.enable = true;
    };

    services.upower.enable = true;

    system.stateVersion = "25.11";
}
