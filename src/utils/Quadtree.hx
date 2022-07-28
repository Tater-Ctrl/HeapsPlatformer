package utils;

import components.CollisionBody;
import types.Rect;

class Quadtree {
  private var MAX_OBJECTS: Int = 10;
  private var MAX_LEVELS: Int = 5;

  private var level: Int;
  private var objects: Array<CollisionBody>;
  private var bounds: Rect;
  private var nodes: Array<Quadtree>;

  public function new(level: Int, bounds: Rect) {
    this.level = level;
    this.bounds = bounds;
    this.objects = new Array<CollisionBody>();
    this.nodes = [null, null, null, null];
  }

  public function clear() {
    while (objects.length > 0)
      objects.pop();

    for (i in 0...nodes.length) {
      if (nodes[i] != null) {
        nodes[i].clear();
        nodes[i] = null;
      }
    }
  }

  private function split() {
    var w = bounds.width / 2;
    var h = bounds.height / 2;
    var x = bounds.x;
    var y = bounds.y;

    nodes[0] = new Quadtree(level+1, new Rect(x + w, y, w, h));
    nodes[1] = new Quadtree(level+1, new Rect(x, y, w, h));
    nodes[2] = new Quadtree(level+1, new Rect(x, y + h, w, h));
    nodes[3] = new Quadtree(level+1, new Rect(x + w, y + h, w, h));
  }

  public function insert(body: CollisionBody) {
    if (nodes[0] != null) {
      var index = getIndex(body.getRect());

      if (index != -1) {
        nodes[index].insert(body);
        return;
      }
    }

    objects.push(body);

    if (objects.length > MAX_OBJECTS && level < MAX_LEVELS) {
      if (nodes[0] == null) {
        split();
      }

      var i: Int = 0;
      while(i < objects.length) {
        var index: Int = getIndex(objects[i].getRect());

        if (index != -1) {
          nodes[index].insert(objects.splice(i, 1)[0]);
        } 
        else {
          i++;
        }
      }
    }
  }

  public function retrieve(rect: Rect): Array<CollisionBody> {
    var index: Int = getIndex(rect);
    var bodies = new Array<CollisionBody>();

    if (index != -1 && nodes[0] != null) {
      bodies = bodies.concat(nodes[index].retrieve(rect));
    }

    return bodies.concat(objects);
  }

  private function getIndex(rect: Rect): Int {
    var index: Int = -1;
    var vMid: Float = bounds.x + bounds.width / 2;
    var hMid: Float = bounds.y + bounds.height / 2;

    var topQuadrant: Bool = (rect.y < hMid && rect.y + rect.height < hMid);
    var botQuadrant: Bool = (rect.y > hMid);

    if (rect.x < vMid && rect.x + rect.width < vMid) {
      if (topQuadrant) {
        index = 1;
      } else if (botQuadrant) {
        index = 2;
      }
    }
    else if (rect.x > vMid) {
      if (topQuadrant) {
        index = 0;
      }
      else if(botQuadrant) {
        index = 3;
      }
    }

    return index;
  }
}