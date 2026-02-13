build:
    git add --intent-to-add .
    sudo nixos-rebuild switch --flake .#${HOSTNAME}
