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

            overlays = [ self.overlays.default ];
          };

          inherit (pkgs) openconnect-sso;
        in
        {
          packages = {
            inherit openconnect-sso;

            default = openconnect-sso;
          };

          devShells.default = (import ./nix { inherit pkgs; }).shell;
        }
      )
      // {
        overlays.default = final: prev: {
          openconnect-sso = (prev.callPackage ./nix { pkgs = final; }).openconnect-sso.override {
            python3 = final.python312;
            python3Packages = final.python312Packages;
          };

          poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { pkgs = final; };
        };

        overlay = self.overlays.default;
      }
    );
}
