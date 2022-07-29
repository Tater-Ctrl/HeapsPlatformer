package components;

import types.Vector2;

class Camera extends Component {

  override function draw(dt:Float) {
    var scene = Game.getScene();
    var current = new Vector2(scene.camera.x, scene.camera.y);
    var target = new Vector2(entity.x - scene.width * 0.5, entity.y - scene.height * 0.5);
    var value = vInterp(current, target, 0.05);

    scene.camera.setPosition(value.x, value.y);
  }
  
  function vInterp(cur: Vector2, tar: Vector2, rate: Float): Vector2 {
    return new Vector2(
      (cur.x * (1.0-rate)) + (tar.x * rate),
      (cur.y * (1.0-rate)) + (tar.y * rate)
    );
  }
}