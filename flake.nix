{
  description = ''
    Front end para a Plataforma de Gerenciamento de Documentos da Secretaria de Transparência e Controle do Município de Campos dos Goytacazes
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        elixir_1_12 = pkgs.beam.packages.erlangR24.elixir.override {
          version = "1.12.2";
          minimumOTPVersion = "24";
          sha256 = "1f8b63x2klhdz1fq1dgbrqs7x6rq309abzq48gicmd0vprfhc641";
        };
      in {
        devShell = pkgs.mkShell {
          name = "fuschia_dev";
          buildInputs = with pkgs; [
            gnumake
            gcc
            readline
            openssl
            zlib
            libxml2
            curl
            libiconv
            # my elixir derivation
            elixir_1_12
            glibcLocales
            nodejs-12_x
            yarn
            postgresql
          ] ++ pkgs.lib.optional stdenv.isLinux [
                inotify-tools
                # observer gtk engine
                gtk-engine-murrine
              ]
            ++ pkgs.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
                CoreFoundation
                CoreServices
              ]);
         # define shell startup command
        shellHook = ''
          # create local tmp folders
          mkdir -p .nix-mix
          mkdir -p .nix-hex
        '';
      };
    });
}
