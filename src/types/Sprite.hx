package types;

import utils.Time;
import utils.Utils;
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
    super(Game.getScene());
    bitmap = new Bitmap(tile, this);

  }

  public function setPos(x: Float, y: Float) {
    // var add = new Vector2(x - this.x, y - this.y) * Time.fMod;

    // setPosition(Math.floor(this.x + add.x), Math.floor(this.y + add.y));
    setPosition(x, y);
  }
}