{
  description = "A basic flake for aarch64-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager } @ inputs:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.my-packages = pkgs.buildEnv {
        name = "my-packages-list";
        paths = with pkgs; [
          git
          curl
        ];
      };

      apps.${system}.update = {
        type = "app";
        program = toString (pkgs.writeShellScript "update-script" ''
          set -e
          echo "Updating flake..."
          nix flake update
          echo "Updating nix-darwin..."
          sudo nix run nix-darwin -- switch --flake .#yoshitaka-darwin
          echo "Updating home-manager..."
          nix run nixpkgs#home-manager -- switch --flake .#myHomeConfig          
          echo "Update complete!"
        '');
      };

      darwinConfigurations.yoshitaka-darwin = nix-darwin.lib.darwinSystem {
        system = system;
        modules = [
          ./nix/nix-darwin/default.nix
        ];
      };

      homeConfigurations = {
        myHomeConfig = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = system;
          };
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./nix/home-manager/home.nix
          ];
        };
      };

    };
}
