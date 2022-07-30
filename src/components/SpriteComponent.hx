package components;

import dn.heaps.slib.HSprite;
import types.Vector2;
import h2d.Tile;
import h2d.Bitmap;

import types.Sprite;

class SpriteComponent extends Component {
  public var sprite : Sprite;

  public function setSprite(tile: Tile) {
    sprite = new Sprite(tile);
  }

  public function setSpriteRect(size: Vector2) {
    sprite.width = size.x;
    sprite.height = size.y;
  }

  override function draw() {
    super.draw();
    sprite.setPos(entity.x, entity.y);
  }
}