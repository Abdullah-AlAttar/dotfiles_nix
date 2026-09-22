# DBFlux — keyboard-first database client
# https://docs.dbflux.dev/install/
{ inputs, pkgs, ... }: {
  home.packages = [inputs.dbflux.packages.${pkgs.stdenv.hostPlatform.system}.dbflux];
}