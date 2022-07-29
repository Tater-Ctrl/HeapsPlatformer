import utils.SpatialHash;
import h2d.Camera;
import h2d.Object;
import hxd.Window;
import utils.Quadtree;
import types.Vector2;
import entities.Background;
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

	var fixedTimeStep:Float = 1. / 60.;
	var fixedTime:Float = 0.;

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
			//Game.inst.s2d.addChild(result);

      // if (parent != null)
      //   parent.addChild(result);

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

    var map = new TestMap();
    var level = map.all_levels.Level_0;

    if (level != null && level.hasBgImage()) {
      var background = level.getBgBitmap();
      s2d.addChild(background);
    }

    s2d.addChild(level.l_Tiles.render());
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
    player.setPosition(50, 50);

    for (i in 0...entities.length) {
      var col = entities[i].getComponent(Collider);

      if (col != null) {
        col.activeCol();
      }
    }
	}

	override function update(dt:Float) {
		fixedTime += Timer.elapsedTime;
		var length:Int = entities.length;

		for (i in 0...length)
			entities[i].componentUpdate(dt);
		for (i in 0...length)
			entities[i].update(dt);

		while (fixedTime > fixedTimeStep) {
			for (i in 0...length)
				entities[i].componentFixedUpdate(dt);
			for (i in 0...length)
				entities[i].fixedUpdate(dt);

			fixedTime -= fixedTimeStep;
		}

		for (i in 0...length)
			entities[i].componentDraw(dt);
		for (i in 0...length)
			entities[i].draw(dt);
	}

	static function main() {
		Res.initEmbed();
		new Game();
	}
}
