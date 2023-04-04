let
  project-name = throw "Change project-name in flake.nix";
  project-version = "";
in
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, nixpkgs, flake-utils, ...}:
  flake-utils.lib.EachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
    cmake = pkgs.cmake;

    nixie-env = pkgs.callPackage ./nixie-env.nix;
  in {
    packages = {};
  });
}
