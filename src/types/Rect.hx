package types;

import haxe.display.Display.Package;

class Rect {
  public var x:Float;
  public var y:Float;
  public var width:Float;
  public var height:Float;
  public var position(get, null):Vector2;
  public var size(get, null):Vector2;

  public function new(x = 0., y = 0., width = 0., height = 0.) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  /**
    Gets the longest side of the box
  **/
  public function length(): Float {
    return Math.max(
      Math.abs(x) + Math.abs(width),
      Math.abs(y) + Math.abs(height)
    );
  }

	function get_position():Vector2 {
		return new Vector2(x, y);
	}

	function get_size():Vector2 {
		return new Vector2(width, height);
	}
}