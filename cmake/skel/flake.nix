let
  project-name = throw "Change project-name in flake.nix";
  project-version = "";
in
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "";
  };

  outputs = {};
}
