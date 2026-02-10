{
    description = "Hyprland on Nixos";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "nixpkgs/nixos-25.11";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        stylix = {
            url = "github:nix-community/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        vicinae = {
            url = "github:vicinaehq/vicinae";
            # inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs =
        {
            nixpkgs,
            nixpkgs-stable,
            home-manager,
            stylix,
            ...
        }@inputs:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; };
            pkgs-stable = import nixpkgs-stable { inherit system; };
        in
          {
              nixosConfigurations.nixing = nixpkgs.lib.nixosSystem {
                  system = "x86_64-linux";
                  modules = [
                      ./hosts/nixing/configuration.nix
                      home-manager.nixosModules.home-manager
                      stylix.nixosModules.stylix
                      {
                          home-manager = {
                              useGlobalPkgs = true;
                              useUserPackages = true;
                              users.nilso = import ./hosts/nixing/home.nix;
                              backupFileExtension = "backup";
                              extraSpecialArgs = { inherit inputs; inherit pkgs-stable; };
                          };
                      }
                  ];
                  specialArgs = {
                      inherit pkgs-stable;
                      inherit inputs;
                  };
              };
          };
}
