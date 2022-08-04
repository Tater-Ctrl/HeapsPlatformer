import hxd.System;
import hxd.App;
import hxd.Key;
import entities.Level;
import utils.Time;
import hxd.Window;
import h2d.Scene;
import hxd.Timer;
import hxd.Res;

class Game extends hxd.App {
	public static var inst:Game;

  public static function getScene(): Scene {
    return Game.inst.s2d;
  }

	override function init() {
    inst = this;
    Window.getInstance().resize(960, 540);
    
    s2d.scaleMode = LetterBox(Const.RENDER_WIDTH, Const.RENDER_HEIGHT, false);

    new Level();
	}

  private function editorInput() {
    if (Key.isPressed(Key.P))
      Level.unload();
    if (Key.isPressed(Key.L))
      Level.load();
    if (Key.isPressed(Key.ESCAPE))
      System.exit();
    if (Key.isPressed(Key.V))
      Window.getInstance().vsync = !Window.getInstance().vsync;
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
