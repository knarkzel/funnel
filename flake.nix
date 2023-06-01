{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, zig, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [ zig.overlays.default ];
      pkgs = import nixpkgs {inherit system overlays;};
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [ gdb qemu grub2 xorriso zigpkgs.master ];
      };
    });
}
