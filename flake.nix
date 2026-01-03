{
    description = "Hyprland on Nixos";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs =
        {
            nixpkgs,
            home-manager,
            ...
        }@inputs:
        {
            nixosConfigurations.nixing = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./hosts/nixing/configuration.nix
                    home-manager.nixosModules.home-manager
                    {
                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            users.nilso = import ./hosts/nixing/home.nix;
                            backupFileExtension = "backup";
                            extraSpecialArgs = { inherit inputs; };
                        };
                    }
                ];
            };
        };
}
