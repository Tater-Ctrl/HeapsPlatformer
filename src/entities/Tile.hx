package entities;

import types.Rect;
import components.Collider.CollisionMode;
import components.TileCollider;

class Tile extends Entity {
  private var collider: TileCollider;

  public function createCollider(bounds: Rect, tileType: TileType = TileType.SOLID) {
    collider = addComponent(TileCollider);
    collider.collisionMode = CollisionMode.TILEMAP;
    collider.tileType = tileType;
    collider.setBounds(bounds);
  }
}