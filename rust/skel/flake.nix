let
  project-name = throw "Change project-name in flake.nix";
  project-version = "";
in
{
  inputs.nixpkgs.follows = "cargo2nix/nixpkgs";
  inputs.flake-utils.follows = "cargo2nix/flake-utils";
  inputs.cargo2nix.url = "github:cargo2nix/cargo2nix";

  outputs = { self, nixpkgs, flake-utils, cargo2nix, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ cargo2nix.overlays.default ];
      };

      nixie-env = pkgs.callPackage ./nixie-env.nix;
      rustPkgs = pkgs.rustBuilder.makePackageSet {
        rustVersion = "1.61.0";
        packageFun = import ./Cargo.nix;
      };
    in
    {
      packages = {
        default = (rustPkgs.workspace."${project-name}".bin);
      };
      devShells.default = pkgs.mkShell {
        packages = nixie-env.tools ++ [
          cargo2nix.packages."${system}".cargo2nix
        ];
        inputsFrom = self.packages."${system}".default;
      };
    });
}
