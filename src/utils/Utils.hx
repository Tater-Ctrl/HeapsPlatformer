package utils;

import types.Vector2;

class Utils {
  public static function vInterp(cur: Vector2, tar: Vector2, rate: Float): Vector2 {
    return new Vector2(
      (cur.x * (1.0-rate)) + (tar.x * rate),
      (cur.y * (1.0-rate)) + (tar.y * rate)
    );
  }

  public static function vInterp2(cur:Vector2, tar: Vector2, alpha: Float): Vector2 {
    return new Vector2(
      cur.x + (tar.x - cur.x) * alpha,
      cur.y + (tar.y - cur.y) * alpha
    );
  }

  public static function fInterp(cur: Float, tar: Float, rate: Float): Float {
    return (cur * (1.0-rate)) + (tar * rate);
  }

  public static function vInterpConst(cur: Vector2, tar: Vector2, rate: Float) {
    return;
  }
}