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
import assets.TestMap;

typedef EntityDef = {
	public function new():Void;
}

class Game extends hxd.App {
	private var entities:Array<Entity> = new Array<Entity>();
  // Gets used for static collision calculation
  private var spatialColliders: SpatialHash<Collider>;
  private var debugGraphics: h2d.Graphics;
  private var layer: Layers;

	var fixedTimeAccumulator:Float = 0.;

	public static var inst:Game;

  public static function addStaticCollider(body: Collider) {
    Game.inst.spatialColliders.insert(body, body.getRect());
  }

  public static function getStaticColliders(rect: Rect): Array<Collider> {
    return Game.inst.spatialColliders.retrieve(rect);
  }

	@:generic
	public static function createEntity<T:EntityDef>(type:Class<T>, ?parent: Object):T {
		var entity = new T();

		if (Std.isOfType(entity, Entity)) {
			var result = cast entity;
			Game.inst.entities.push(result);

			return entity;
		}

		return null;
	}

  public static function getScene(): Scene {
    return Game.inst.s2d;
  }

	override function init() {
		inst = this;

    spatialColliders = new SpatialHash();
    layer = new Layers(s2d);
    debugGraphics = new h2d.Graphics();
    layer.add(debugGraphics, 1000);

    var map = new TestMap();
    var level = map.all_levels.Level_0;

    if (level != null && level.hasBgImage()) {
      var background = level.getBgBitmap();
      layer.add(background, 0);
    }

    layer.add(level.l_Tiles.render(), 0);
    var tiles = level.json.layerInstances[0].gridTiles;

    for(i in 0...tiles.length) {
      var tile = tiles[i];

      if (tile != null) {
        var entity = createEntity(Platform);
        entity.setPosition(tile.px[0], tile.px[1]);
        entity.createCollider(new Rect(0, 0, 35, 35));
      }
    }
    
		var player = createEntity(Player);
    player.setPosition(55, 55);

    for (i in 0...entities.length) {
      var col = entities[i].getComponent(Collider);

      if (col != null) {
        col.activeCol();
      }
    }

    for (i in 0...entities.length)
      entities[i].awake();
	}

	override function update(dt:Float) {
		var length:Int = entities.length;
    
    Time.fixedDeltaTime += dt;
    Time.fMod = Timer.tmod - (30 / 60);


		for (i in 0...length)
			entities[i].update();

		while (Time.fixedDeltaTime >= Const.FIXED_TIME_STEP) {
			for (i in 0...length)
				entities[i].fixedUpdate();

			Time.fixedDeltaTime -= Const.FIXED_TIME_STEP;
		}

		for (i in 0...length)
			entities[i].draw();

    #if debug
    debugGraphics.clear();
    for (i in 0...length)
      entities[i].drawGizmos(debugGraphics);
    #end
	}

	static function main() {
		Res.initEmbed();
		new Game();
	}
}
