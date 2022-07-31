package utils;

import haxe.ds.Map;
import types.Rect;

class SpatialHash<T> {
  public var GRID_SIZE:Int = 16;
  public var grid:Map<String, Array<T>> = new Map();

  public function new() {}

  public function insert(object: T, rect: Rect) {
    var keys = hashRect(rect);
    var addedKeys: Array<String> = [];

    for(k in keys) {
      if (!addedKeys.contains(k)) {
        if (grid.exists(k))
          grid[k].push(object);
        else 
          grid[k] = [object];
      }
    }
  }

  public function retrieve(rect: Rect): Array<T> {
    var keys = search(rect);
    var addedKeys: Array<String> = [];
    var objects: Array<T> = [];

    for (k in keys) {
      if (grid.exists(k) && !addedKeys.contains(k)) {
        objects = objects.concat(grid[k]);
        addedKeys.push(k);
      }
    }

    return objects;
  }

  public function clear() {
    grid.clear();
  }

  
  private function hashRect(rect: Rect): Array<String> {
    var x = Math.floor(rect.x / GRID_SIZE);
    var y = Math.floor(rect.y / GRID_SIZE);
    var w = Math.floor((rect.x + rect.w) / GRID_SIZE);
    var h = Math.floor((rect.y + rect.h) / GRID_SIZE);

    var keys = [
      hashKey(x, y),
      hashKey(w, y),
      hashKey(x, h),
      hashKey(w, h)
    ];

    return keys;
  }

  private function search(rect: Rect): Array<String> {
    var x = Math.round(rect.x / GRID_SIZE);
    var y = Math.round(rect.y / GRID_SIZE);
    var w = Math.round((rect.x + rect.w) / GRID_SIZE);
    var h = Math.round((rect.y + rect.h) / GRID_SIZE);

    var keys = [];

    for (i in x-1...w+1) {
      for (j in y-1...h+1) {
        keys.push(hashKey(i, j));
      }
    }

    return keys;
  }

	private function hashKey(p1:Float, p2:Float) {
		return Std.string(p1) + "." + Std.string(p2);
	}
}

