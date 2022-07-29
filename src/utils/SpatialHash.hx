package utils;

import haxe.ds.Map;
import types.Rect;

class SpatialHash<T> {
  public var GRID_SIZE:Int = 64;
  public var grid:Map<String, Array<T>> = new Map();

  public function new() {}

  public function insert(object: T, rect: Rect) {
    var keys = hashRect(rect);

    if (grid.exists(keys[0]))
      grid[keys[0]].push(object);
    else 
      grid[keys[0]] = [object];

    if (keys[1] != keys[0])
      if (grid.exists(keys[1]))
        grid[keys[1]].push(object);
      else 
        grid[keys[1]] = [object];

    if ((keys[2] != keys[0] || keys[2] != keys[1]))
      if (grid.exists(keys[2]))
        grid[keys[2]].push(object);
      else
        grid[keys[2]] = [object];

    if ((keys[3] != keys[0] || keys[3] != keys[1] || keys[3] != keys[2]))
      if (grid.exists(keys[3]))
        grid[keys[3]].push(object);
      else
        grid[keys[3]] = [object];
  }

  public function retrieve(rect: Rect): Array<T> {
    var keys = hashRect(rect);
    var objects: Array<T> = [];

    if (grid.exists(keys[0]))
      objects = grid[keys[0]];

    if (keys[1] != keys[0] && grid.exists(keys[1]))
      objects = objects.concat(grid[keys[1]]);

    if ((keys[2] != keys[0] || keys[2] != keys[1]) && grid.exists(keys[2]))
      objects = objects.concat(grid[keys[2]]);

    if ((keys[3] != keys[0] || keys[3] != keys[1] || keys[3] != keys[2]) && grid.exists(keys[3]))
      objects = objects.concat(grid[keys[3]]);

    return objects;
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

	private function hashKey(p1:Float, p2:Float) {
		return Std.string(p1) + "." + Std.string(p2);
	}
}

