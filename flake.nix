{
  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        systems.follows = "systems";
      };
    };
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      ...
    }@inputs:
    (
      flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;

            overlays = [ self.overlay ];
          };

          inherit (import ./nix { inherit pkgs; }) openconnect-sso shell;
        in
        {
          packages = { inherit openconnect-sso; };
          defaultPackage = openconnect-sso;

          devShells.default = shell;
        }
      )
      // {
        overlay = final: prev: {
          inherit (prev.callPackage ./nix { pkgs = final; }) openconnect-sso;

          poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { pkgs = final; };
        };
      }
    );
}
