{...}:
{
  enable = true;
  enableZshIntegration = true;
  colorSchemes = let 
    fg = "#A0A8CD";
    background = "#000b1e";
    pink = "#ff00ee";
    red = "#ff0000";
    orange = "#ff9500";
    teal = "#00f7ff";
    green = "#15ff00";
    blue = "#006bff";
    yellow = "#D7A65F";
    purple = "#8c33ff";
    grey = "#4A5057";
  in rec {
    foreground = teal;
    cursor_fg = teal;
    inherit background;
    ansi = [
      green
      red
      pink
      orange
      blue
      purple
      teal
      fg
    ];
    brights = ansi;
  };
  extraConfig = builtins.readFile ../raw/wezterm/wezterm.lua;
}
