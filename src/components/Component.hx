package components;

import entities.Entity;

class Component extends Entity{
  private var entity: Entity;
  
  public function new(entity: Entity) {
    super();
    this.entity = entity;
  }
}