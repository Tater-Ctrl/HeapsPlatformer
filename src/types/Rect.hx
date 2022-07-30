package types;

class Rect {
  public var x:Float;
  public var y:Float;
  public var w:Float;
  public var h:Float;
  public var position(get, null):Vector2;
  public var size(get, null):Vector2;

  // Used for calculating collisions
  public var cx:Float;
  public var cy:Float;
  /**
    Radius used in collision calculations
  **/
  public var r:Float;

  public function new(x = 0., y = 0., width = 0., height = 0.) {
    this.x = x;
    this.y = y;
    this.w = width;
    this.h = height;

    cx = x + w / 2;
    cy = y + h / 2;
    r = Math.sqrt(h * h + w * w) / 2;
  }

  /**
    Gets the longest side of the box
  **/
  public function length(): Float {
    return Math.max(
      Math.abs(x) + Math.abs(w),
      Math.abs(y) + Math.abs(h)
    );
  }

  public function addMargin(v: Float): Rect {
    return new Rect(
      x - v,
      y - v,
      w + v * 2,
      h + v * 2
    );
  }

	function get_position():Vector2 {
		return new Vector2(x, y);
	}

	function get_size():Vector2 {
		return new Vector2(w, h);
	}
}