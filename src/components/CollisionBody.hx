package components;

import types.Rect;
import types.Vector2;

enum CollisionMode {
  STATIC;
  DYNAMIC;
}

enum CollisionShape {
  Rectangle;
  Circle;
}

class CollisionBody extends Component {
  public var rect: Rect;
  public var margin: Vector2 = new Vector2(10, 5);
  public var collisionMode: CollisionMode = CollisionMode.STATIC;
  
  public var topLeft(get, null):Vector2;
  public var topRight(get, null):Vector2;
  public var bottomLeft(get, null):Vector2;
  public var bottomRight(get, null):Vector2;

  private var _rect: Rect;
  
  public function activeCol() {
    if (collisionMode == CollisionMode.STATIC) {
      Game.addStaticCollisionBody(this);
      Game.addCollisionBody(this);
    }
  }

  public function getRect(): Rect {
    return new Rect(
      entity.x + rect.x,
      entity.y + rect.y,
      rect.width,
      rect.height
    );
  }

  public function setRect(rect: Rect) {
    this.rect = rect;
  }

  public function checkAABBCollision(b2: Rect, v: Vector2): Bool {
    var b1 = getRect();
    return !(b1.x + v.x > b2.x + b2.width
      || b1.x + b1.width + v.x < b2.x
      || b1.y + v.y > b2.y + b2.height
      || b1.y + b1.height + v.y < b2.y
      );
  }

  /**
    Checks if point is overlappping the collisionbody, returns the amount of overlap in a Vector2
  **/
  public function isPointOverlapping(point: Vector2, col: CollisionBody):Vector2 {
    var horCol: Bool = point.x >= col.rect.x && point.x <= col.rect.x + col.rect.width;
    var verCol: Bool = point.y >= col.rect.y && point.y <= col.rect.y + col.rect.height;

    if (horCol && verCol) {
      return point - col.rect.position;
    }

    return new Vector2(0, 0);
  }

  public function debugRect() {
    var customGraphics = new h2d.Graphics(Game.getScene());
    customGraphics.beginFill(0xEA8220);
    
    var r = getRect();
    customGraphics.drawRect(
      r.x, r.y, r.width, r.height
    );

    customGraphics.endFill();
  }

	function get_bottomLeft():Vector2 {
		return entity.position + rect.position + new Vector2(0, rect.height);
	}

  function get_bottomRight():Vector2 {
		return entity.position + rect.position + rect.size;
	}

	function get_topLeft():Vector2 {
		return entity.position + rect.position;
	}

	function get_topRight():Vector2 {
		return entity.position + rect.position + new Vector2(rect.width, 0);
	}
}