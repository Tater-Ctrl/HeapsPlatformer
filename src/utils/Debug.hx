package utils;

import hxd.res.DefaultFont;
import h2d.Console;

class Debug {
  private static var console : Console;

  public static function init() {
    #if debug
    if (console == null) {
      console = new Console(DefaultFont.get());
      Game.getScene().addChild(console);
    }
    #end
  }

  public static function test(message: Dynamic) {
    #if debug
    trace(message);
    #end
  }

  public static function log(message: Dynamic) {
    #if debug
    if (console == null) {
      init();
    }

    console.log(Std.string(message));
    #end
  }
}