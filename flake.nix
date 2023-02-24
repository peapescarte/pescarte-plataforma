{
  description = ''
    Plataforma PEA Pescarte
  '';

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
    let
      systems = {
        linux = "x86_64-linux";
        darwin = "aarch64-darwin";
      };

      pkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      inputs = sys: with pkgs sys; [
        gnumake
        gcc
        readline
        openssl
        zlib
        libxml2
        curl
        libiconv
        elixir_1_14
        glibcLocales
        postgresql
        #redpanda
        nodejs
      ] ++ lib.optional stdenv.isLinux [
        inotify-tools
        gtk-engine-murrine
      ] ++ lib.optional stdenv.isDarwin [
        darwin.apple_sdk.frameworks.CoreServices
        darwin.apple_sdk.frameworks.CoreFoundation
      ];
    in {
      applications."${systems.linux}".pescarte =
        let
          inherit (pkgs systems.linux) beam callPackage;
          beamPackages = beam.packagesWith beam.interpreters.erlang;

          pname = "pescarte";
          version = "0.1.0";

          src = ./.;

          nodeDependencies = (callPackage ./assets/default.nix { }).shell.nodeDependencies;
        in beamPackages.mixRelease {
          inherit src pname version;

          mixNixDeps = with pkgs systems.linux; import ./deps.nix { inherit lib beamPackages; };
          preBuild = "ln -sf ${nodeDependencies}/lib/node_modules assets/node_modules";
          postBuild = "mix do deps.loadpaths --no-deps-check, assets.deploy";
        };

      devShells = {
        "${systems.linux}".default = with pkgs systems.linux; mkShell {
          name = "pescarte";
          buildInputs = inputs systems.linux;
        };

        "${systems.darwin}".default = with pkgs systems.darwin; mkShell {
          name = "pescarte";
          buildInputs = inputs systems.darwin;
        };
      };
    };
}
