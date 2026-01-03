{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.userSettings.hyprland;
    browser = config.userSettings.browser;
    terminal = config.userSettings.terminal;
    theme = import ./theme.nix { inherit pkgs; };
in
{
    options = {
        userSettings.hyprland = {
            enable = lib.mkEnableOption "Enables Hyprland";
            nvidia = lib.mkEnableOption "Enables Nvidia for Hyprland";
            config = lib.mkOption {
                type = lib.types.attrs;
                default = { };
                description = "Adds configuration to Hyprland";
            };
        };
    };

    config = lib.mkIf cfg.enable {
        wayland.windowManager.hyprland.enable = true;
        wayland.windowManager.hyprland.settings = lib.mkMerge [
            {
                "$mainMod" = "SUPER";
                "$rotate_val" = 100;
                cursor = {
                    hide_on_key_press = true;
                };
                exec-once = [
                    "[workspace 1 silent] ${browser}"
                    "[workspace 3 silent] ${terminal}"
                ];
                input = {
                    force_no_accel = true;
                    follow_mouse = 1;
                    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
                };
                windowrulev2 = [
                    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
                    "suppressevent maximize, class:.*"
                ];
                dwindle = {
                    pseudotile = true;
                    preserve_split = true;
                };
                master = {
                    new_status = "master";
                };
                misc = {
                    key_press_enables_dpms = true;
                };
                bind = [
                    "$mainMod, T, exec, ${terminal}"
                    "$mainMod, B, exec, ${browser}"
                    "$mainMod, Q, killactive"
                    "$SUPER_SHIFT, Q, forcekillactive"
                    "$SUPER_SHIFT, BACKSPACE, exit"
                    "$mainMod, V, togglefloating"
                    "$mainMod, F, fullscreen"
                    "$mainMod, H, movefocus, l"
                    "$mainMod, J, movefocus, d"
                    "$mainMod, K, movefocus, u"
                    "$mainMod, L, movefocus, r"
                    "$SUPER_SHIFT, H, resizeactive, -$rotate_val 0"
                    "$SUPER_SHIFT, J, resizeactive, 0 $rotate_val"
                    "$SUPER_SHIFT, K, resizeactive, 0 -$rotate_val"
                    "$SUPER_SHIFT, L, resizeactive, $rotate_val 0"
                    "$mainMod, 1, workspace, 1"
                    "$mainMod, 2, workspace, 2"
                    "$mainMod, 3, workspace, 3"
                    "$mainMod, 4, workspace, 4"
                    "$mainMod, 5, workspace, 5"
                    "$mainMod, 6, workspace, 6"
                    "$mainMod, 7, workspace, 7"
                    "$mainMod, 8, workspace, 8"
                    "$mainMod, 9, workspace, 9"
                    "$mainMod, 0, workspace, 10"
                    "$mainMod SHIFT, 1, movetoworkspace, 1"
                    "$mainMod SHIFT, 2, movetoworkspace, 2"
                    "$mainMod SHIFT, 3, movetoworkspace, 3"
                    "$mainMod SHIFT, 4, movetoworkspace, 4"
                    "$mainMod SHIFT, 5, movetoworkspace, 5"
                    "$mainMod SHIFT, 6, movetoworkspace, 6"
                    "$mainMod SHIFT, 7, movetoworkspace, 7"
                    "$mainMod SHIFT, 8, movetoworkspace, 8"
                    "$mainMod SHIFT, 9, movetoworkspace, 9"
                    "$mainMod SHIFT, 0, movetoworkspace, 10"
                ];
                bindm = [
                    "$mainMod, mouse:272, movewindow"
                    "$mainMod, mouse:273, resizewindow"
                ];
            }
            # Add Nvidia config if necessary
            (lib.mkIf cfg.nvidia {
                env = [
                    "LIBVA_DRIVER_NAME, nvidia"
                    "__GLX_VENDOR_LIBRARY_NAME, nvidia"
                    "NVD_BACKEND, direct"
                    # Electron
                    "ELECTRON_OZONE_PLATFORM_HINT,auto"
                    "NIXOS_OZONE_WL=1"
                ];
                cursor = {
                    no_hardware_cursors = true;
                };
                misc = {
                    vrr = 1;
                };
            })

            # Add extra config
            cfg.config
            theme
        ];
    };
}
