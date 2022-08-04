package components;

import types.Vector2;
import h2d.Tile;

import types.Sprite;

enum ESpriteMoveMode {
  Free;
  Snap(snap: Float);
}

class SpriteComponent extends Component {
  public var sprite : Sprite;
  public var moveMode: ESpriteMoveMode = ESpriteMoveMode.Free;

  private var gridPos: Vector2 = new Vector2(0, 0);

  public function setSprite(tile: Tile, layer: Int = 0) {
    sprite = new Sprite(tile, layer);
  }

  public function setSpriteRect(size: Vector2) {
    sprite.width = size.x;
    sprite.height = size.y;
  }

  override function draw() {
    super.draw();

    switch (moveMode) {
      case ESpriteMoveMode.Snap(size):
        snapMode(size);
      default:
        sprite.setPos(entity.x, entity.y);
    }
  }

  private function snapMode(size: Float) {
    var gridX: Float = Math.floor(entity.x / size);
    var gridY: Float = Math.floor(entity.y / size);

    sprite.setPos(
      if (gridX != gridPos.x) { gridX * size; } else { gridPos.x; },
      if (gridY != gridPos.y) { gridY * size; } else { gridPos.y; }
    );
  }
}