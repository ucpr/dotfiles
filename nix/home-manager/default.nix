{ user, ... }:

{
  home-manager = {
    extraSpecialArgs = { inherit user; };
    useGlobalPkgs = true;
    useUserPackages = false;

    users.${user} = { ... }: {
      home.username = user;
      home.homeDirectory = "/Users/${user}";
      home.stateVersion = "24.11";

      imports = [
        ./home.nix
      ];

      programs.home-manager.enable = true;
    };
  };
}

