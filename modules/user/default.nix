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
        ./emacs
        ./stylix
    ];
    home.file.".config/nvim".source = ./nvim;

    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
    };

    home.packages = with pkgs; [
        # Languages
        lua
        go
        rustc
        cargo
        rust-analyzer

        dysk
        ripgrep
        eza
        valgrind
        fd
        bat
        fzf
        tealdeer
        imagemagick
        pandoc
    ];
}
