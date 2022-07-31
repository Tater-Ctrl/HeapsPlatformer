package components;

import entities.Entity;
import utils.Utils;
import types.Vector2;

enum CameraFollowMode {
  STATIC(target:Entity);
  INTERPOLATED(target:Entity, time:Float);
}

class Camera extends Component {
  public var followMode: CameraFollowMode;

  override function draw() {
    if (followMode == null)
      return;

    switch(followMode) {
      case STATIC(target):
        staticFollow(target);
      case INTERPOLATED(target, time):
        interpolatedFollow(target, time);
    }
  }

  private function staticFollow(target: Entity) {
    var scene = Game.getScene();
    var pos = new Vector2(target.x - scene.width * 0.5, target.y - scene.height * 0.5);
    scene.camera.setPosition(pos.x, pos.y);
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