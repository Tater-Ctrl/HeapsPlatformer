package entities;
import h2d.Graphics;
import types.Vector2;
import haxe.Constraints;
import components.Component;
import h2d.Object;

class Entity {
  public var x:Float;
  public var y:Float;

  private var components: Array<Component> = [for (i in 0...32) null];
  public var position(get, null): Vector2;

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

  public function componentUpdate(dt:Float) {
    for (i in 0...components.length) {
      if (components[i] != null) {
        components[i].update(dt);
      }
    }
  }

  public function componentFixedUpdate(dt:Float) {
    for (i in 0...components.length) {
      if (components[i] != null) {
        components[i].fixedUpdate(dt);
      }
    };
  }

  public function componentDraw(dt:Float) {
    for (i in 0...components.length) {
      if (components[i] != null) {
        components[i].draw(dt);
      }
    }
  }

  public function setPosition(x: Float, y: Float) {
    this.x = x;
    this.y = y;
  }

	public function start() {}

	public function update(dt:Float) {}

	public function draw(dt:Float) {}

	public function fixedUpdate(dt:Float) {}

	function get_position():Vector2 {
		return new Vector2(x, y);
	}

	public function drawGizmos(graphics: Graphics) {}
}