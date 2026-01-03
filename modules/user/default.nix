{ pkgs, lib, ... }:

{
    imports = [
        ./zsh
        ./hyprland
        ./browser
        ./editor
        ./terminal
        ./keepass
        ./git
    ];
    home.file.".config/nvim".source = ./nvim;

    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
    };
}
