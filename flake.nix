{
  description = "uBar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.aarch64-darwin.uBar = nixpkgs.legacyPackages.aarch64-darwin.callPackage ./uBar.nix { };
    packages.aarch64-darwin.default = self.packages.aarch64-darwin.uBar;
    packages.aarch64-darwin.swiftpm2nix = nixpkgs.legacyPackages.aarch64-darwin.swiftPackages.swiftpm2nix;
  };
}
