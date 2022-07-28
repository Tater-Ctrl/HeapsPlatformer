package components;

import types.Vector2;
import h2d.Tile;
import h2d.Bitmap;

class SpriteComponent extends Component {
  var bitmap : Bitmap;

  public function setSprite(tile: Tile) {
    bitmap = new Bitmap(tile, entity);
  }

  public function setSpriteRect(scale: Vector2) {
    bitmap.width = scale.x;
    bitmap.height = scale.y;
  }
}