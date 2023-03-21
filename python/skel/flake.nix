let
  project-name = throw "Change project-name in flake.nix";
  project-version = "";
in
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let
      pkgs = import nixpkgs { inherit system; };
      python3 = pkgs.python3;

      nixie-env = pkgs.callPackage ./nixie-env.nix;
    in
    {
      packages = {
        default = python3.pkgs.buildPythonApplication {
          pname = project-name;
          version = project-version;

          src = ./.;
          format = "pyproject";

          nativeBuildInputs = nixie-env.buildsystem-requires;
          buildInputs = nixie-env.dependencies;
        };
      };
      devShells.default = pkgs.mkShell {
        packages = nixie-env.tools;
        inputsFrom = self.packages."${system}".default;
      };
    });
}
