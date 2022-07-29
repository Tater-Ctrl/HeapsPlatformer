package components;

import types.Vector2;
import h2d.Graphics;
import entities.Entity;
import h2d.Object;

class Component extends Entity{
  private var entity: Entity;
  
  public function new(entity: Entity) {
    super();
    this.entity = entity;
  }
}