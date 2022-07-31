package components;

import types.Rect;

enum TileType {
  SOLID;
  HALF_TOP;
  HALF_BOTTOM;
  HALF_LEFT;
  HALF_RIGHT;
}

class TileCollider extends Collider {
  public var tileType: TileType = TileType.SOLID;

  override function setBounds(rect:Rect) {
    var halfTile = Const.DEFAULT_TILE_SIZE / 2;

    switch(tileType) {
      case HALF_TOP:
        this.rect = new Rect(rect.x, rect.y, rect.w, rect.h - halfTile);
      case HALF_BOTTOM:
        this.rect = new Rect(rect.x, rect.y + halfTile, rect.w, rect.h - halfTile);
      case HALF_LEFT:
        this.rect = new Rect(rect.x, rect.y, rect.w - halfTile, rect.h);
      case HALF_RIGHT:
        this.rect = new Rect(rect.x + halfTile, rect.y, rect.w - halfTile, rect.h);
      default:
        this.rect = rect;
    }
  }
}