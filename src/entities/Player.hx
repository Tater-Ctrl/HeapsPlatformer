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

  private var speed: Float = 4.;

  public function new() {
    super();

    health    = addComponent(HealthComponent);
    input     = addComponent(InputComponent);
    body      = addComponent(Rigidbody2D);
    sprite    = addComponent(SpriteComponent);
    collider  = addComponent(Collider);
    camera    = addComponent(Camera);
    
    camera.mode = CameraMode.STATIC(0, 0);

    body.gravityEnabled = true;
    body.collisionEnabled = true;
    body.collider = collider;
    
    collider.setBounds(new Rect(0, 0, 16, 16));
    collider.collisionMode = CollisionMode.DYNAMIC;
    
    var tile = Res.img.traveler.toTile();
    sprite.setSprite(tile.sub(0, 0, tile.width / 6, tile.height / 8));

    input.Jump = jump;
  }

  override function fixedUpdate() {
    super.fixedUpdate();
    body.movePosition(input.moveDirection * speed);
  }

  public function jump() {
    if (body.isGround) {
      body.jump(7);
    }
  }
}