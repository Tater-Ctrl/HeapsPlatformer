package entities;

import types.Rect;
import components.CollisionBody;

class Platform extends Entity {
  private var collider: CollisionBody;
  public function new() {
    super();

    collider = addComponent(CollisionBody);
  }

  public function createCollider(rect: Rect):Void {
    if (collider != null) {
      collider.setRect(rect); 

    }
  }
}