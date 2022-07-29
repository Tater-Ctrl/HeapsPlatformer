package types;

import h2d.Tile;
import h2d.Bitmap;

class Sprite extends h2d.Drawable {
  var bitmap: Bitmap;

  public var width(get, set):Float;
  public var height(get, set):Float;

  public inline function get_width() return bitmap.width;
  public inline function set_width(w:Float) return bitmap.width = w;

  public inline function get_height() return bitmap.height;
  public inline function set_height(h: Float) return bitmap.height = h;

  public function new(tile: Tile) {
    super(null);

    bitmap = new Bitmap(tile, Game.getScene());
  }

  public function setPos(x, y) {
    bitmap.setPosition(x, y);
  }
}