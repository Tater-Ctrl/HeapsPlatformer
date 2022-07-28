package entities;

import utils.Debug;
import types.Vector2;
import hxd.Res;
import components.SpriteComponent;

class Background extends Entity {
  var sprite: SpriteComponent;

  public function new() {
    super();

    // var tile = Res.img.Mountain2.toTile();
    // sprite = addComponent(SpriteComponent);
    // sprite.setSprite(tile);
    // var size = new Vector2(Game.getScene().width, Game.getScene().height);
    // sprite.setSpriteRect(size);
  }
}