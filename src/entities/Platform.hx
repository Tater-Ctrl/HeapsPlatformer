package entities;

import types.Rect;
import components.Collider;

class Platform extends Entity {
  private var collider: Collider;
  public function new() {
    super();

    collider = addComponent(Collider);
    collider.collisionMode = CollisionMode.TILEMAP;
  }

  public function createCollider(rect: Rect):Void {
    if (collider != null) {
      collider.setRect(rect);
    }
  }
}