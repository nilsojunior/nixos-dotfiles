{
    config,
    lib,
    pkgs,
    ...
}:

{
    imports = [
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ../../modules/system
    ];

    nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
            "nvidia-x11"
            "nvidia-settings"
            "spotify"
        ];

    systemSettings = {
        user = "nilso";
        pipewire.enable = true;
        hyprland.enable = true;
        nvidia.enable = true;
        stylix = {
            enable = true;
            theme = "gruvboxing";
        };
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
            timeout = 0; # Acess by pressing space
        };
        kernelParams = [ "quiet" ];
    };

    services = {
        # Journal (logs)
        # Limit size and things to optimize boot speed
        journald.extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
        journald.rateLimitBurst = 500;
        journald.rateLimitInterval = "30s";

        tailscale.enable = true;
        udev.packages = [ pkgs.vial ];

        getty.autologinUser = config.systemSettings.user;
    };

    # Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;
    # Don't wait for internet connection to start
    systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];

    security.rtkit.enable = true;

    system.stateVersion = "25.11";
}
