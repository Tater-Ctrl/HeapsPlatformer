package components;

import types.Rect;
import hxd.System;
import hxd.App;

class HurtCollider extends TileCollider {

  public function die() {
    System.exit();
  }

  override function getBounds():Rect {
    trace("Hit!");
    return new Rect(0, 0);
  }
}