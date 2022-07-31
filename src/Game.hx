import hxd.Key;
import entities.Level;
import h2d.Graphics;
import h2d.RenderContext;
import utils.Time;
import h2d.Layers;
import utils.SpatialHash;
import h2d.Camera;
import h2d.Object;
import hxd.Window;
import utils.Quadtree;
import types.Vector2;
import types.Rect;
import entities.Platform;
import h2d.Scene;
import components.Collider;
import entities.Player;
import utils.Debug;
import entities.Entity;
import hxd.Timer;
import hxd.Res;

class Game extends hxd.App {
	public static var inst:Game;

  public static function getScene(): Scene {
    return Game.inst.s2d;
  }

	override function init() {
    inst = this;
    Window.getInstance().resize(1280, 720);
    s2d.scaleMode = LetterBox(Const.RENDER_WIDTH, Const.RENDER_HEIGHT, false);

    new Level();
	}

  private function editorInput() {
    if (Key.isPressed(Key.P))
      Level.unload();
    if (Key.isPressed(Key.L))
      Level.load();
  }

	override function update(dt:Float) {
    editorInput();

    Time.deltaTime = dt;
    Time.fixedDeltaTime += dt;
    Time.fMod = Math.round(Timer.fps() / Const.FIXED_FRAMES);

    var entities = Level.getEntities();

    if (entities != null) {
      var length:Int = entities.length;
      
      while (Time.fixedDeltaTime >= Const.FIXED_TIME_STEP) {
        for (i in 0...length)
          entities[i].fixedUpdate();
        
        Time.fixedDeltaTime -= Const.FIXED_TIME_STEP;
      }
      for (i in 0...length)
        entities[i].update();
      
      for (i in 0...length)
        entities[i].draw();
  
      #if debug
      var debugger = Level.getDebugger();

      if (debugger != null) {
        debugger.clear();
        for (i in 0...length)
          entities[i].drawGizmos(debugger);
      }
      #end
    }
	}

	static function main() {
		Res.initEmbed();
		new Game();
	}
}
