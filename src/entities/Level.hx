package entities;

import h2d.Graphics;
import h2d.Object;
import components.Collider;
import utils.SpatialHash;
import types.Rect;
import h2d.Layers;

typedef EntityDef = {
	public function new():Void;
}

typedef Grid = ldtk.Layer_IntGrid;

class Level {
  public var layer: Layers = new Layers();

  private static var instance: Level;
  private static var loader: assets.MapLoader;

  private var tilemapColliders: SpatialHash<Collider>;
  private var entities: Array<Entity>;
  private var debugger: Graphics;

  private var collisionLayer: Grid;
  private var backgroundLayer: Grid;
  private var foregroundLayer: Grid;

  public function new() {
    if (instance != null)
      return;

    instance          = this;
    layer             = new Layers(Game.getScene());
    tilemapColliders  = new SpatialHash();
    entities          = new Array<Entity>();
    debugger          = new Graphics();

    if (loader == null)
      loader  = new assets.MapLoader();

    load();
  }

  public function load() {
    var backgroundLayer = loader.all_levels.PlayTest.l_Background;
    var collisionLayer = loader.all_levels.PlayTest.l_Collision;
    createLevelColliders(collisionLayer);

		var player = Level.createEntity(Player);
    player.setPosition(55, 55);
    
    layer.add(collisionLayer.render(), 0);
    layer.add(backgroundLayer.render(), -1);
    layer.add(debugger, -1);
  }

  public function unload() {
    backgroundLayer = null;
    collisionLayer = null;
    foregroundLayer = null;

    tilemapColliders.clear();

    layer.removeChildren();
  }

  public static function addLayer(object: Object, layer: Int) {
    Level.instance.layer.add(object, layer);
  }

  public static function getEntities(): Array<Entity> {
    return Level.instance.entities;
  }

  public static function getDebugger(): Graphics {
    return Level.instance.debugger;
  }

  public static function addTilemapCollider(col: Collider) {
    Level.instance.tilemapColliders.insert(col, col.getRect());
  }

  public static function getTilemapColliders(rect: Rect): Array<Collider> {
    return Level.instance.tilemapColliders.retrieve(rect);
  }

  @:generic
	public static function createEntity<T:EntityDef>(type:Class<T>, ?parent: Object):T {
		var entity = new T();

		if (Std.isOfType(entity, Entity)) {
			var result = cast entity;
			Level.instance.entities.push(result);

			return entity;
		}

		return null;
	}

  private function createLevelColliders(tiles: Grid) {
    for(cx in 0...tiles.cWid) {
      for (cy in 0...tiles.cHei) {
        if (!tiles.hasValue(cx, cy))
          continue;

        var entity = createEntity(Platform);
        entity.setPosition(cx * 8, cy * 8);
        entity.createCollider(new Rect(0, 0, 8, 8));
      }
    }
  }
}