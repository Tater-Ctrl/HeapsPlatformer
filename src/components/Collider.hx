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

class Collider extends Component {
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
      rect.w,
      rect.h
    );
  }

  public function setRect(rect: Rect) {
    this.rect = rect;
  }

  public static function checkAABBCollision(b1: Rect, b2: Rect, v: Vector2): Bool {
    return !(b1.x + v.x >= b2.x + b2.w
      || b1.x + b1.w + v.x <= b2.x
      || b1.y + v.y >= b2.y + b2.h
      || b1.y + b1.h + v.y <= b2.y
      );
  }

  public static function checkSphereCollision(b1: Rect, b2: Rect): Bool {
    return Math.abs((b1.cx - b2.cx) * (b1.cx - b2.cx) + (b1.cy - b1.cy) * (b1.cy - b2.cy)) < (b1.r + b2.r) * (b1.r + b2.r);
  }

  /**
    Checks if point is overlappping the collisionbody, returns the amount of overlap in a Vector2
  **/
  public static function isPointOverlapping(point: Vector2, col: Collider):Bool {
    var rect = col.getRect();
    return point.x >= rect.x 
      && point.x <= rect.x + rect.w
      && point.y >= rect.y 
      && point.y <= rect.y + rect.h;
  }

  public function debugRect() {
    var customGraphics = new h2d.Graphics(Game.getScene());
    customGraphics.beginFill(0xEA8220);
    
    var r = getRect();
    customGraphics.drawRect(
      r.x, r.y, r.w, r.h
    );

    customGraphics.endFill();
  }

	function get_bottomLeft():Vector2 {
		return entity.position + rect.position + new Vector2(0, rect.h);
	}

  function get_bottomRight():Vector2 {
		return entity.position + rect.position + rect.size;
	}

	function get_topLeft():Vector2 {
		return entity.position + rect.position;
	}

	function get_topRight():Vector2 {
		return entity.position + rect.position + new Vector2(rect.w, 0);
	}
}