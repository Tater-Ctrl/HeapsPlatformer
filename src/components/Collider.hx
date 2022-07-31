package components;

import entities.Level;
import h2d.Graphics;
import types.Rect;
import types.Vector2;

enum CollisionMode {
  STATIC;
  DYNAMIC;
  TILEMAP;
}

enum CollisionShape {
  Rectangle;
  Circle;
}

class Collider extends Component {
  public var rect: Rect;
  public var margin: Vector2 = new Vector2(10, 5);
  public var collisionMode: CollisionMode = CollisionMode.STATIC;
  
  public var yMin(get, null):Float;
  public var xMax(get, null):Float;
  public var xMin(get, null):Float;
  public var yMax(get, null):Float;

  public var debug: Bool = false;

  override function drawGizmos(graphics:Graphics) {
    if (debug) {
      graphics.beginFill(0xFFFFFF);
      var r = getRect();
      graphics.drawRect(r.x, r.y, r.w, r.h);
      graphics.endFill();
    }
  }

  override function awake() {
    super.awake();
    activeCol();
  }
  
  public function activeCol() {
    if (collisionMode == CollisionMode.TILEMAP) {
      Level.addTilemapCollider(this);
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

	function get_yMin():Float {
		return entity.y + rect.y;
	}

  function get_xMin():Float {
    return entity.x + rect.x;
  }

	function get_xMax():Float {
		return entity.x + (rect.x + rect.w);
	}


	function get_yMax():Float {
		return entity.y + (rect.y + rect.h);
	}
}