# Session variables previously in nix_home.nix
{ ... }: {
  home.sessionVariables = {
    SSH_ASKPASS = "";
    SSH_ASKPASS_REQUIRE = "never";
  };
}
