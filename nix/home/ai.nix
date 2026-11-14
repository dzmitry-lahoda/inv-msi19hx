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
  ] ++ [pkgs.codex];

  systemd.user.services.codex-app-server = {
    Unit.Description = "Codex app server";
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.codex}/bin/codex app-server --listen unix://";
      WorkingDirectory = "%h";
      UMask = "0077";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.file = {
    ".gemini/config/plugins/conductor".source = agy-conductor;
    ".gemini/config/plugins/postgres".source = agy-postgres;
  };
}
