interface IUpdate {
  function start(): Void;
  function update(dt: Float): Void;
  function lateUpdate(dt: Float): Void;
  function fixedUpdate(dt: Float): Void;
  function drawGizmos(graphics: h2d.Graphics): Void;
}