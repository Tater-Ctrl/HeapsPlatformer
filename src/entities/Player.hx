package entities;
import h2d.Graphics;
import types.Vector2;
import utils.Time;
import components.Camera;
import types.Rect;
import components.Collider;
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
  private var collider: Collider;
  private var camera: Camera;

  private var speed: Float = 10.;

  public function new() {
    super();

    health    = addComponent(HealthComponent);
    input     = addComponent(InputComponent);
    body      = addComponent(Rigidbody2D);
    sprite    = addComponent(SpriteComponent);
    collider  = addComponent(Collider);
    camera    = addComponent(Camera);
    
    body.gravityEnabled = true;
    body.collisionEnabled = true;
    
    body.collider = collider;
    collider.setRect(new Rect(21, 10, 23, 24));
    collider.collisionMode = CollisionMode.DYNAMIC;
    
    var tile = Res.img.SmolBunHop2.toTile();
    sprite.setSprite(tile.sub(0, 0, tile.width / 3, tile.height));

    input.Jump = jump;
  }

  override function fixedUpdate() {
    super.fixedUpdate();
    body.movePosition(input.moveDirection, speed);
  }

  public function jump() {
    if (body.isGround) {
      body.jump(20);
    }
  }
}