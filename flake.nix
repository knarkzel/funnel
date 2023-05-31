{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zigpkgs = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, zigpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [ zigpkgs.overlays.default ];
      pkgs = import nixpkgs {inherit system overlays;};
    in {
      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.zls
          pkgs.qemu
          pkgs.zigpkgs.master
        ];
      };
    });
}
