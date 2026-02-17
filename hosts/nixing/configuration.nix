{
    config,
    lib,
    pkgs,
    ...
}:

{
    imports = [
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

    services.udev.packages = [ pkgs.vial ];

    system.stateVersion = "25.11";
}
