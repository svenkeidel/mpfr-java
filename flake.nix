{
  description = "GNU MPFR Java Bindings ";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      packages.default =
        let pkgs = import nixpkgs {inherit system;};
            mavenRepo = pkgs.buildMaven ./formatted-project-info.json;
        in with pkgs; stdenv.mkDerivation rec {

            name = "mpfr-java";
            version = "1.4";

            src = ./.;

            nativeBuildInputs = [ maven gmp mpfr automake autoconf libtool gcc ];

            buildPhase = ''
              mvn --offline --settings=${mavenRepo.settings} compile
            '';

            installPhase = ''
              mvn --offline --settings=${mavenRepo.settings} package -DskipTests
              mkdir $out
              install target/*.jar $out
            '';

            meta = with lib; {
              homepage = "https://github.com/runtimeverification/mpfr-java/";
              description = "GNU MPFR Java Bindings ";
              license = "K Release License";
              platforms = platforms.all;
            };

          };
  });
}
