{
  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      ...
    }:

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

          devShells.default = pkgs.callPackage ./shell.nix { };
        }
      )

      // {
        overlays.default = final: prev: {
          inherit (prev.callPackage ./. { }) openconnect-sso;
        };

        overlay = self.overlays.default;
      }
    );
}
