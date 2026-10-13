{ pkgs }:
let
  signal-desktop-wrapper = pkgs.writeShellApplication {
    name = "signal-desktop";
    text = ''
      ${pkgs.lib.meta.getExe pkgs.nixgl.nixGLIntel} ${pkgs.lib.meta.getExe pkgs.signal-desktop} "$@"
    '';
  };
in
[
  signal-desktop-wrapper
]
