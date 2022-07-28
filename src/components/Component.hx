package components;

import types.Vector2;
import h2d.Graphics;
import entities.Entity;
import h2d.Object;

class Component extends Object implements IUpdate {
  private var entity: Entity;
  public var position(get, null): Vector2;
  
  public function new(entity: Entity) {
    super();
    this.entity = entity;
  }

	public function start() {}
	public function update(dt:Float) {}
	public function lateUpdate(dt:Float) {}
	public function fixedUpdate(dt:Float) {}

	public function drawGizmos(graphics:Graphics) {}
  
  function get_position():Vector2 {
		return new Vector2(x, y);
	}
}