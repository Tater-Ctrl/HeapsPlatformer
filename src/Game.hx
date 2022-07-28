import h2d.Object;
import hxd.Window;
import utils.Quadtree;
import types.Vector2;
import entities.Background;
import types.Rect;
import entities.Platform;
import h2d.Scene;
import components.CollisionBody;
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
  private static var collisionBodies:Array<CollisionBody> = new Array<CollisionBody>();
  public var quadTreeColliders: Quadtree;

	var fixedTimeStep:Float = 1. / 60.;
	var fixedTime:Float = 0.;

	public static var inst:Game;

  public static function addCollisionBody(body: CollisionBody): Int {
    return collisionBodies.push(body);
  }

  public static function getCollisionBodies(): Array<CollisionBody> {
    return collisionBodies;
  }

  public function insertBody(body: CollisionBody) {
    quadTreeColliders.insert(body);
  }

  public static function addStaticCollisionBody(body: CollisionBody) {
    Game.inst.quadTreeColliders.insert(body);
  }

	@:generic
	public static function createEntity<T:EntityDef>(type:Class<T>, ?parent: Object):T {
		var entity = new T();

		if (Std.isOfType(entity, Entity)) {
			var result = cast entity;
			Game.inst.entities.push(result);
			Game.inst.s2d.addChild(result);

      if (parent != null)
        parent.addChild(result);

			return entity;
		}

		return null;
	}

  public static function getScene(): Scene {
    return Game.inst.s2d;
  }

	override function init() {
    Window.getInstance().resize(1280, 720);
		inst = this;

    quadTreeColliders = new Quadtree(0, new Rect(0, 0, s2d.width, s2d.height));

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
        entity.createCollider(new Rect(tile.px[0], tile.px[1], 35, 35));
      }
    }
    
		createEntity(Player).setPosition(50, 50);

    for (i in 0...entities.length) {
      var col = entities[i].getComponent(CollisionBody);

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
			entities[i].componentLateUpdate(dt);
		for (i in 0...length)
			entities[i].lateUpdate(dt);
	}

	static function main() {
		Res.initEmbed();
		new Game();
	}
}
