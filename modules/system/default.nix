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
    ];
}
