package components;

import hxd.Key;
import types.Vector2;

class InputComponent extends Component {
  public var moveDirection: Vector2 = new Vector2();
  public var Jump:Void->Void;

  override function update() {
    updateMoveDirection();

    if (Key.isPressed(Key.SPACE) && Jump != null) {
      Jump();
    }
  }

  private function updateMoveDirection() {
    moveDirection.x = 0.;
    moveDirection.y = 0.;

    if (Key.isDown(Key.A)) {
      moveDirection.x -= 1;
    }
    if (Key.isDown(Key.D)) {
      moveDirection.x += 1;
    }
    if (Key.isDown(Key.W)) {
      moveDirection.y -= 1;
    }
    if (Key.isDown(Key.S)) {
      moveDirection.y += 1;
    }
  }
}