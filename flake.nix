{
  description = "SQLBoiler is a tool to generate a Go ORM tailored to your database schema.";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      version = "7b35c4d19c05fdc53d1efdcc074f20ee6b56f340";

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          sqlboiler-crdb = pkgs.buildGoModule {
            pname = "sqlboiler-crbd";
            version = version;

            src = pkgs.fetchFromGitHub {
              owner = "glerchundi";
              repo = "sqlboiler-crdb";
              rev = "${version}";
              sha256 = "sha256-RlppCRYP7TlM1z1PiXtEVifNVxQHwLuoBXxgYIpUirE=";
            };

            vendorSha256 = "sha256-N16GH8ZDyeWWBsaaG4RkJwzAbuQ7E8YjZAgVsfeECo4";

            checkPhase = [ ];

            meta = with pkgs.lib; {
              description = "SQLBoiler is a tool to generate a Go ORM tailored to your database schema.";
              homepage = https://github.com/glerchundi/sqlboiler-crdb/;
              maintainers = with maintainers; [ dgollings ];
              platforms = platforms.linux ++ platforms.darwin;
              mainProgram = "sqlboiler-crdb";
            };
          };
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.sqlboiler-crdb);
    };
}
