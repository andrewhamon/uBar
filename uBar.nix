{ lib, swiftPackages, fetchFromGitHub, stdenvNoCC }:
let
  inherit (swiftPackages) apple_sdk stdenv swift swiftpm;
in
stdenv.mkDerivation rec {
  pname = "uBar";
  version = "0.0.1";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [ swift swiftpm ];

  buildInputs = with apple_sdk.frameworks; [ AppKit Foundation ];

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
    cp $binPath/uBar $out/bin/
  '';

  meta = with lib; {
    description = "Write menubar apps in any language";
    homepage = "https://github.com/andrewhamon/uBar";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" ];
  };
}
