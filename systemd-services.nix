{ pkgs, unwrapFlakeInput, ... }:
let
  lib = pkgs.lib;
in {
  eww-bar-selector = let
    path = pkgs.lib.strings.concatStringsSep ":" [
        "${pkgs.bspwm}/bin"
        "${pkgs.eww}/bin"
        "/bin"
    ];
  in {
    Unit = {
      Description = "Eww bar selector";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${unwrapFlakeInput "eww-bar-selector"}/bin/bar-selector";
      ExecSearchPath = path;
   };
 };

  eww = let
    path = lib.strings.concatStringsSep ":" [
        "${unwrapFlakeInput "bspwm-desktops-report"}/bin"
        "${unwrapFlakeInput "window-title-watcher"}/bin"
        "${unwrapFlakeInput "volume-watcher"}/bin"
        "${pkgs.eww}/bin"
        "${pkgs.bspwm}/bin"
        "${pkgs.pulseaudio}/bin"
        "${pkgs.pamixer}/bin"
        "${pkgs.playerctl}/bin"
        "/bin"
    ];
  in {
    Unit = {
      Description = "Eww bar";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.eww}/bin/eww daemon --no-daemonize";
      ExecSearchPath = path;
    };
  };
}
