{
  pkgs,
  antigravity-nix,
  agy-conductor,
  agy-postgres,
  ...
}:
{
  home.packages = with antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}; [
    google-antigravity
    google-antigravity-cli # agy
  ];

  home.file = {
    ".gemini/config/plugins/conductor".source = agy-conductor;
    ".gemini/config/plugins/postgres".source = agy-postgres;
  };
}
