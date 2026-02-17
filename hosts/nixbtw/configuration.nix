{ config, lib, pkgs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
            ../../modules/system
        ];

    boot.initrd.luks.devices.crypt = {
        device = "/dev/disk/by-partuuid/c0b7beb9-e90a-4643-9dd2-46dd74b7c4f1";
    };

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

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;

    environment.systemPackages = with pkgs; [
        vim
        wget
    ];

    system.stateVersion = "25.11";
}
