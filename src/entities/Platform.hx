package entities;

import components.TileCollider;
import types.Rect;
import components.Collider;

class Platform extends Entity {
  private var collider: TileCollider;
  public function new() {
    super();

    collider = addComponent(TileCollider);
    collider.collisionMode = CollisionMode.TILEMAP;
    collider.tileType = TileType.HALF_BOTTOM;
  }

  public function createCollider(rect: Rect):Void {
    if (collider != null) {
      collider.setBounds(rect);
    }
  }
}