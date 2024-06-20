{
  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix/2024.5.939250";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        systems.follows = "systems";
      };
    };
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, flake-utils, nixpkgs, ... }@inputs:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.packageOverrides = _: { poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }; };
        };

        inherit (import ./nix { inherit pkgs; }) openconnect-sso shell;
      in {
        packages = { inherit openconnect-sso; };
        defaultPackage = openconnect-sso;

        devShells.default = shell;
      }) // {
        overlay = final: prev: {
          poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { pkgs = final; };
          inherit (prev.callPackage ./nix { pkgs = final; }) openconnect-sso;
        };
      });
}
