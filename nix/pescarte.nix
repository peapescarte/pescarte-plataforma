{
  mixRelease,
  fetchMixDeps,
  erlang,
  nix-gitignore,
  nodeDependencies,
}: let
  src = nix-gitignore.gitignoreSource [../.gitignore] ./..;
in
  mixRelease rec {
    inherit src;
    pname = "pescarte";
    version = "production";
    mixFodDeps = fetchMixDeps {
      inherit version;
      pname = "${pname}-deps";
      inherit src;
      sha256 = "8yS5gtFzmgl8mV2nNJzYbdxxyqf/P30XougCMprGFa8=";
    };
    postBuild = ''
      ln -sf ${nodeDependencies}/lib/node_modules assets/node_modules
      mix do deps.loadpaths --no-deps-check, phx.digest
    '';
    installPhase = ''
      runHook preInstall
      mix release ${pname} --no-deps-check --path "$out"
      runHook postInstall
    '';
    preFixup = ''
      for script in $out/releases/*/elixir; do
        substituteInPlace "$script" --replace 'ERL_EXEC="erl"' 'ERL_EXEC="${erlang}/bin/erl"'
      done

      wrapProgram $out/bin/pescarte --set RELEASE_COOKIE ${pname}
    '';
  }
