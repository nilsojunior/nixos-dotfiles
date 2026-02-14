{
    config,
    pkgs,
    lib,
    ...
}:

{
    imports = [
        ./hyprland
        ./nvidia
        ./sshd
        ./gpg
        ./stylix
        ./pipewire
        ./userinfo
    ];

    home-manager.users.${config.systemSettings.user}.imports = [
        ../../hosts/${config.networking.hostName}/home.nix
    ];

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    time.timeZone = "Brazil/East";

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    environment.systemPackages = with pkgs; [
        wget
        neovim
        pavucontrol
        gcc15
        just
        sshfs
    ];

    # https://github.com/thiagokokada/nix-configs/blob/a00e8aa50e6e5786e1d533389c100aca41800417/modules/nixos/desktop/locale.nix#L12-L14
    i18n = {
        defaultLocale = "en_IE.UTF-8";
        extraLocaleSettings = {
            LC_CTYPE = "pt_BR.UTF-8"; # Fix ç in us-intl.
        };
    };
}
