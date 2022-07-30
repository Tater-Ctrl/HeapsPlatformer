package components;

import h2d.Graphics;
import utils.Utils;
import utils.Time;
import types.Rect;
import types.Vector2;

class Rigidbody2D extends Component {
  public var gravityEnabled: Bool = true;
  public var gravity: Float = 30;
  public var isGrounded: Bool = false;
  public var collider: Collider;

  // Different forces that affect the rigidbody
  private var jumpForce: Float = 0.;
  private var velocity: Vector2 = new Vector2(0., 0.);
  private var moveDirection: Vector2 = new Vector2(0, 0);
  private var actualVelocity: Vector2 = new Vector2(0, 0);

  private var targetPosition: Vector2 = new Vector2(0, 0);

  public function movePosition(direction: Vector2) {
    moveDirection = direction;
  }

  override function awake() {
    super.start();
    targetPosition = entity.position;
  }

  private function moveRigidBody() {
    entity.x += Math.round(actualVelocity.x);
    entity.y += Math.round(actualVelocity.y);
    
    actualVelocity.x = 0;
    actualVelocity.y = 0;
  }

  private function interpolateBody() {
    var interpPos = Utils.vInterp(entity.position, targetPosition, Time.fMod);

    entity.x = interpPos.x;
    entity.y = Math.ceil(interpPos.y);
  }

  /**
    Currently dependent on gravity being enabled to function
  **/
  public function jump(force: Float) {
    jumpForce = force;
  }

  override function draw() {
    interpolateBody();
  }
  
  override function fixedUpdate() {
    targetPosition = entity.position;

    if (gravityEnabled)
      applyGravity();

    actualVelocity += velocity + moveDirection;

    checkCollision();

    targetPosition.x += actualVelocity.x;
    targetPosition.y += actualVelocity.y;

    actualVelocity.x = 0;
    actualVelocity.y = 0;
  }

  private function checkCollision() {
    isGrounded = false;
    var start = Sys.time() * 1000;
    if (collider != null) {
      // var r1 = new Rect(targetPosition.x, targetPosition.y, collider.rect.w, collider.rect.h);
      var r1 = collider.getRect();
      var bodies = Game.getStaticColliders(r1.addMargin(-5));

      for (i in 0...bodies.length) {
        var r2 = bodies[i].getRect();

        if (Collider.checkSphereCollision(r1, r2)) {
          var hitHor = Collider.checkAABBCollision(r1, r2, new Vector2(actualVelocity.x, 0));
          if (hitHor) {
            if (actualVelocity.x > 0) {
              var offset = r1.x + r1.w + actualVelocity.x - r2.x;
              actualVelocity.x -= offset;
            }
            else if (actualVelocity.x < 0) {
              var offset = r1.x + actualVelocity.x - (r2.x + r2.w);
              actualVelocity.x -= offset;
            }
          }
  
          var hitVer = Collider.checkAABBCollision(r1, r2, new Vector2(0, actualVelocity.y));
          if (hitVer) {
            if (actualVelocity.y > 0) {
              isGrounded = true;
              var offset = r1.y + r1.h + actualVelocity.y - r2.y;
              actualVelocity.y -= offset;
            }
            else if (actualVelocity.y < 0) {
              jumpForce = 0;
              velocity.y = 0;
              var offset = r1.y + actualVelocity.y - (r2.y + r2.h);
              actualVelocity.y -= offset;
            }
          }
        }
      }
    }

    var end = Sys.time() * 1000;
    trace(end - start);
  }

  private function applyGravity() {
    if (jumpForce > 0) {
      velocity.y = -jumpForce;
      jumpForce -= gravity * Time.fixedDeltaTime;
    } else if (isGrounded) {
      velocity.y = 0.1;
    }
    else {
      velocity.y += gravity * Time.fixedDeltaTime;

      if (velocity.y > gravity) {
        velocity.y = gravity;
      }
    }
  }
}