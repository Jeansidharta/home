{ unwrapFlakeInput, ... }:
{
  enable = true;
  enableZshIntegration = true;
  package = unwrapFlakeInput "wallpaper-manager";
  wallpapers-dir = "/home/sidharta/wallpapers/live";
  cache-dir = "/home/sidharta/.local/state/wallpaper-manager";
}
