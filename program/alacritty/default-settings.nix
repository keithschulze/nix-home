{
  background_opacity = 1.0;

  window = {
    padding.x = 10;
    padding.y = 25;
    decorations = "transparent";
  };

  font = {
    size = 15.0;
    use_thin_strokes = true;

    normal.family = "JetBrainsMono Nerd Font";
    bold.family = "JetBrainsMono Nerd Font";
    italic.family = "JetBrainsMono Nerd Font";
  };

  cursor.style = "Block";

  # TokyoNight Alacritty Colors
  colors = {
    # Default colors
    primary = {
      background = "0x24283b";
      foreground = "0xc0caf5";
    };

    # Normal colors
    normal = {
      black =   "0x1D202F";
      red =     "0xf7768e";
      green =   "0x9ece6a";
      yellow =  "0xe0af68";
      blue =    "0x7aa2f7";
      magenta = "0xbb9af7";
      cyan =    "0x7dcfff";
      white =   "0xa9b1d6";
    };

    # Bright colors
    bright = {
      black =   "0x414868";
      red =     "0xf7768e";
      green =   "0x9ece6a";
      yellow =  "0xe0af68";
      blue =    "0x7aa2f7";
      magenta = "0xbb9af7";
      cyan =    "0x7dcfff";
      white =   "0xc0caf5";
    };

    indexed_colors = [
      { index = 16; color = "0xff9e64"; }
      { index = 17; color = "0xdb4b4b"; }
    ];
  };

  # Nord
  # colors = {
  #   primary = {
  #     background = "0x2E3440";
  #     foreground = "0xD8DEE9";
  #   };

  #   cursor = {
  #     text = "0x2E3440";
  #     cursor = "0xD8DEE9";
  #   };

  #   normal = {
  #     black = "0x3B4252";
  #     red = "0xBF616A";
  #     green = "0xA3BE8C";
  #     yellow = "0xEBCB8B";
  #     blue = "0x81A1C1";
  #     magenta = "0xB48EAD";
  #     cyan = "0x88C0D0";
  #     white = "0xE5E9F0";
  #   };

  #   bright = {
  #     black = "0x4C566A";
  #     red = "0xBF616A";
  #     green = "0xA3BE8C";
  #     yellow = "0xEBCB8B";
  #     blue = "0x81A1C1";
  #     magenta = "0xB48EAD";
  #     cyan = "0x8FBCBB";
  #     white = "0xECEFF4";
  #   };
  # };
}
