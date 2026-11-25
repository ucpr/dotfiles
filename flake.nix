{
  description = "A flake to provision ucpr environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
    let
      system = "aarch64-darwin";
      defaultUser =
        let u = builtins.getEnv "NIX_USER";
        in if u != "" then u else "ucpr";
      user = defaultUser;
      pkgs = nixpkgs.legacyPackages.${system};
      mkDarwin =
        { user ? defaultUser
        , extraModules ? [ ]
        , extraHomeModules ? [ ]
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs user system; };

          modules = [
            ./nix/nix-darwin/default.nix
            home-manager.darwinModules.home-manager
            ./nix/home-manager/default.nix
            { home-manager.users.${user}.imports = extraHomeModules; }
          ] ++ extraModules;
        };
    in
    {
      lib.mkDarwin = mkDarwin;

      darwinConfigurations.mac = mkDarwin { };

      homeConfigurations = {
        mac = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs user system; };
          modules = [
            ./nix/home-manager/home.nix
          ];
        };
      };
    };
}

