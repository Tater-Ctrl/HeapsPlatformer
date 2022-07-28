package utils;

import hxd.res.DefaultFont;
import h2d.Console;
#if debug
class Debug {
  private static var console : Console;

  public static function init() {
    if (console == null) {
      console = new Console(DefaultFont.get());
      Game.getScene().addChild(console);
    }
  }

  public static function log(message: Dynamic) {
    if (console == null) {
      init();
    }

    console.log(Std.string(message));
  }
}
#end