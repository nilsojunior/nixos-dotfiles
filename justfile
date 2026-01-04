build:
    git add *.nix
    sudo nixos-rebuild switch --flake .#nixing
