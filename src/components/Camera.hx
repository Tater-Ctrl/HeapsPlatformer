package components;

import utils.Utils;
import types.Vector2;

class Camera extends Component {

  public var camera(get, null): h2d.Camera;
  public inline function get_camera() return Game.getScene().camera;

  override function draw() {
    var scene = Game.getScene();
    var current = new Vector2(scene.camera.x, scene.camera.y);
    var target = new Vector2(entity.x - scene.width * 0.5, entity.y - scene.height * 0.5);
    var value = Utils.vInterp(current, target, 0.05);

    value.x = clamp(value.x, target.x - 85, target.x + 85);

    // var dist = 

    // scene.camera.setPosition(Math.round(value.x), Math.round(value.y));
    scene.camera.setPosition(target.x, target.y);
  }

  function clamp(value: Float, min: Float, max: Float) {
    if (value > max)
      return max;
    if (value < min)
      return min;
    return value;
  }

  function interp() {

  }
}