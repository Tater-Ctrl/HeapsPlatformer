package types;

abstract Vector2(Array<Float>) {
  public var x(get, set): Float;
  public var y(get, set): Float;

  function set_x(value:Float):Float return this[0] = value;
  function set_y(value:Float):Float return this[1] = value;
  function get_x():Float return this[0];
  function get_y():Float return this[1];

  public function new(x = 0., y = 0.) {
    this = [x, y];

    set_x(x);
    set_y(y);
  }

  /**
    Measures the distance from v1 to v2 and returns the result.
  **/
  public static function distanceTo(v1: Vector2, v2: Vector2): Float {
    return Math.sqrt(Math.pow(v2.x - v1.x, 2) + Math.pow(v2.y - v1.y, 2));
  }

  public function length(): Float {
    return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
  }

  public function floor(): Vector2 {
    return new Vector2(
      Math.floor(x),
      Math.floor(y)
    );
  }

  public function toString(): String {
    return "X: " + Std.string(x) + ", Y: " + Std.string(y); 
  }

  @:op(A + B)
  public static function addFloat(v1: Vector2, val: Float) {
    return new Vector2(v1.x + val, v1.y + val);
  }

  @:op(A - B)
  public static function subtractFloat(v1: Vector2, val: Float) {
    return new Vector2(v1.x - val, v1.y - val);
  }

  @:op(A * B)
  public static function multiplyFloat(v1: Vector2, val: Float) {
    return new Vector2(v1.x * val, v1.y * val);
  }

  @:op(A / b)
  public static function divideFloat(v1: Vector2, val: Float) {
    return new Vector2(v1.x / val, v1.y / val);
  }

  @:op(A + B)
  public static function addVector(v1: Vector2, v2: Vector2) {
    return new Vector2(v1.x + v2.x, v1.y + v2.y);
  }

  @:op(A - B)
  public static function subtractVector(v1: Vector2, v2: Vector2) {
    return new Vector2(v1.x - v2.x, v1.y - v2.y);
  }

  @:op(A * B)
  public static function multiplyVector(v1: Vector2, v2: Vector2) {
    return new Vector2(v1.x * v2.x, v1.y * v2.y);
  }

  @:op(A / b)
  public static function divideVector(v1: Vector2, v2: Vector2) {
    return new Vector2(v1.x / v2.x, v1.y / v2.y);
  }
}