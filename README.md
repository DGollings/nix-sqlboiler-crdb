# SQLboiler CRDB CockroachDB 
SQLBoiler is a tool to generate a Go ORM tailored to your database schema.
This is the CockroachDB/CRDB plugin
https://github.com/glerchundi/sqlboiler-crdb

# Example usage:

flake.nix
``` nix
{
  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      flake-utils.url = "github:numtide/flake-utils";
      sqlboiler-crdb.url = "github:DGollings/nix-sqlboiler-crdb";
    };

  outputs = { self, nixpkgs, flake-utils, sqlboiler-crdb }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = [
            sqlboiler-crdb.packages.${system}.sqlboiler-crdb
          ];
        };
      });
}
```
