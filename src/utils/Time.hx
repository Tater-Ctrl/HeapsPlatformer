package utils;

class Time {
  public static var deltaTime(default, set):Float;
	static inline function set_deltaTime(value: Float):Float return deltaTime = value;

  public static var fixedDeltaTime(default, set): Float;
	static inline function set_fixedDeltaTime(value:Float):Float return fixedDeltaTime = value;

  public static var fMod(default, set): Float;
	static inline function set_fMod(value:Float):Float return fMod = value;

}