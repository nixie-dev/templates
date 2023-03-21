{ description = "Default set of templates for Nixie projects";

  inputs.nixpkgs.url = github:nixos/nixpkgs;
  inputs.flake-utils.url = github:numtide/flake-utils;

  nixConfig.extra-substituters = "https://nix-wrap.cachix.org";
  nixConfig.extra-trusted-public-keys = "nix-wrap.cachix.org-1:FcfSb7e+LmXBZE/MdaFWcs4bW2OQQeBnB/kgWlkZmYI=";

  outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let pkgs = import nixpkgs { inherit system; };
        templates = pkgs.lib.filterAttrs (m: v: (m != "override") && (m != "overrideDerivation"))
          (pkgs.callPackage ./templates.nix {});
    in
    { packages =
      { predicates = pkgs.stdenv.mkDerivation {
          name = "nixie-templates-predicates";
          src = pkgs.emptyDirectory;
          installPhase =
            builtins.foldl'
              (l: r: l + "\ncp ${templates."${r}"}/lib/predicate $out/predicates/${r}")
              "mkdir -p $out/predicates"
              (builtins.attrNames templates);
        };
      };
      legacyPackages = templates;
    }
    );
}
