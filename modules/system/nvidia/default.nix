{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.systemSettings.nvidia;
in
{
    options = {
        systemSettings.nvidia.enable = lib.mkEnableOption "Enables Nvidia";
    };

    config = lib.mkIf cfg.enable {
        nixpkgs.config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
                "nvidia-x11"
                "nvidia-settings"
            ];

        services.xserver.videoDrivers = [ "nvidia" ];
        hardware = {
            graphics.enable = true;
            nvidia.open = true;
            nvidia.modesetting.enable = true; # For Wayland
            nvidia.powerManagement.enable = true; # From Hyprland docs
        };
    };
}
