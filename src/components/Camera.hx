package components;

import entities.Entity;
import utils.Utils;
import types.Vector2;

enum CameraMode {
  STATIC(x: Float, y: Float);
  INTERPOLATED(target:Entity, time:Float);
}

class Camera extends Component {
  public var mode: CameraMode;

  override function draw() {
    if (mode == null)
      return;

    switch(mode) {
      case STATIC(x, y):
        staticFollow(x, y);
      case INTERPOLATED(target, time):
        interpolatedFollow(target, time);
    }
  }

  private function staticFollow(xPos: Float, yPos: Float) {
    var scene = Game.getScene();
    scene.camera.setPosition(xPos, yPos);
  }

  private function interpolatedFollow(target: Entity, time: Float) {
    var scene = Game.getScene();
    var camPos = new Vector2(scene.camera.x, scene.camera.y);
    var curPos = new Vector2(target.x - scene.width * 0.5, target.y - scene.height * 0.5);
    var midpoint = (curPos * 0.5) + (camPos * 0.5);
    var value = Utils.vInterp(camPos, midpoint, time);
    var position = camPos + (value - camPos);

    scene.camera.setPosition(position.x, position.y);
  }
}