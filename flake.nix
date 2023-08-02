{
  description = "Plataforma Digital PEA Pescarte";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

  outputs = {nixpkgs, ...}: let
    systems = {
      linux = "x86_64-linux";
      darwin = "aarch64-darwin";
    };

    pkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    inputs = sys:
      with pkgs sys;
        [
          gnumake
          gcc
          readline
          openssl
          zlib
          libxml2
          curl
          libiconv
          elixir
          glibcLocales
          postgresql_15
          nodejs_18
        ]
        ++ lib.optional stdenv.isLinux [
          inotify-tools
          gtk-engine-murrine
        ]
        ++ lib.optional stdenv.isDarwin [
          darwin.apple_sdk.frameworks.CoreServices
          darwin.apple_sdk.frameworks.CoreFoundation
        ];
  in {
    packages = {
      "${systems.darwin}".default = let
        darwinPkgs = pkgs systems.darwin;
        erl = darwinPkgs.beam.packages.erlang;
        nodeDependencies = (darwinPkgs.callPackage ./apps/plataforma_digital/assets/default.nix {}).shell.nodeDependencies;
      in
        erl.callPackage ./nix/pescarte.nix {
          inherit nodeDependencies;
          inherit (darwinPkgs) nix-gitignore;
        };
    };

    devShells = {
      "${systems.linux}".default = with pkgs systems.linux;
        mkShell {
          name = "pescarte";
          packages = inputs systems.linux;
        };

      "${systems.darwin}".default = with pkgs systems.darwin;
        mkShell {
          name = "pescarte";
          packages = inputs systems.darwin;
        };
    };
  };
}
