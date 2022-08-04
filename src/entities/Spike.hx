package entities;

import components.HurtCollider;

class Spike extends Tile {
  public function new() {
    super();
    collider = addComponent(HurtCollider);
  }
}