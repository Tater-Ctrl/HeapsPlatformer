package entities;
import types.Rect;
import components.CollisionBody;
import components.HealthComponent;
import hxd.Res;
import components.SpriteComponent;
import components.Rigidbody2D;
import components.InputComponent;

class Player extends Entity {
  private var input: InputComponent;
  private var body: Rigidbody2D;
  private var sprite: SpriteComponent;
  private var health: HealthComponent;
  private var collider: CollisionBody;

  private var speed: Float = 150.;

  public function new() {
    super();

    health    = addComponent(HealthComponent);
    input     = addComponent(InputComponent);
    body      = addComponent(Rigidbody2D);
    sprite    = addComponent(SpriteComponent);
    collider  = addComponent(CollisionBody);

    body.gravityEnabled = true;
    body.collider = collider;

    collider.setRect(new Rect(20, 10, 25, 25));
    collider.collisionMode = CollisionMode.DYNAMIC;

    var tile = Res.img.SmolBunHop2.toTile();
    sprite.setSprite(tile.sub(0, 0, tile.width / 3, tile.height));
    input.Jump = jump;
  }

  public override function fixedUpdate(dt:Float) {
    body.movePosition(input.moveDirection * speed * dt);
  }

  public function jump() {
    if (body.isGrounded) {
      body.jump(10);
    }
  }
}