package entities;
import h2d.Graphics;
import types.Vector2;
import haxe.Constraints;
import components.Component;

class Entity {
  /**
    Pixel X coordinate in the world
  **/
  public var px(get, null): Int;
  function get_px(): Int return Math.floor(x);
  /**
    Pixel Y coordinate in the world
  **/
  public var py(get, null): Int;
  function get_py(): Int return Math.floor(y);
  /**
    Floating X coordinate in the world
  **/
  public var x:Float;
  /**
    Floating Y coordinate in the world
  **/
  public var y:Float;

  public var position(get, set): Vector2;
  /**
    Cell X coordinate in the world
  **/
  public var cx: Int;
  function get_cx(): Int return px * Const.DEFAULT_TILE_SIZE;
  /**
    Cell Y coordinate in the world
  **/
  public var cy(get, null): Int;
  function get_cy(): Int return py * Const.DEFAULT_TILE_SIZE;

  /**
    References to all child components
  **/
  private var components: Array<Component> = [for (i in 0...32) null];
  function get_position():Vector2 return new Vector2(x, y);
  function set_position(value: Vector2):Vector2 {
    x = value.x;
    y = value.y;

    return value;
  };

  public function new() {}

  @:generic
  public function getComponent<T: Component>(type: Class<T>): T {
    for(i in 0...components.length) {
      if (Std.isOfType(components[i], type)) {
        var result: T = cast components[i];
        return result;
      }
    }

    return null;
  }

  @:generic
  public function addComponent<T: Constructible<Entity->Void>>(type: Class<T>): T {
    var comp = new T(this);

    if (Std.isOfType(comp, Component)) {
      for (i in 0...components.length) {
        if (components[i] == null) {
          components[i] = cast comp;
          components[i].start();
          return comp;
        }
      }
    }

    return null;
  }

  public function setPosition(x: Float, y: Float) {
    this.x = x;
    this.y = y;
  }

  public function awake(): Void {
    for (i in 0...components.length) {
      if (components[i] != null) {
        components[i].awake();
      }
    }
  }

	public function start(): Void {
    for (i in 0...components.length) {
      if (components[i] != null) {
        components[i].start();
      }
    }
  }

	public function update(): Void {
    for (i in 0...components.length) {
      if (components[i] != null) {
        components[i].update();
      }
    }
  }

	public function draw(): Void {
    for (i in 0...components.length) {
      if (components[i] != null) {
        components[i].draw();
      }
    }
  }

	public function fixedUpdate(): Void {
    for (i in 0...components.length) {
      if (components[i] != null) {
        components[i].fixedUpdate();
      }
    }
  }

	public function drawGizmos(graphics: Graphics): Void {
    for (i in 0...components.length) {
      if (components[i] != null) {
        components[i].drawGizmos(graphics);
      }
    }
  }
}