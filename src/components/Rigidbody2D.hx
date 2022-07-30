package components;

import types.Rect;
import utils.Time;
import types.Vector2;

class Rigidbody2D extends Component {
  public var collisionEnabled: Bool = true;
  public var gravityEnabled: Bool = true;
  public var gravity: Float = 30;
  public var isGrounded: Bool = false;
  public var collider: Collider;

  // Different forces that affect the rigidbody
  private var jumpForce: Float = 0.;
  private var velocity: Vector2 = new Vector2(0., 0.);
  private var moveDirection: Vector2 = new Vector2(0, 0);
  private var moveSpeed: Float = 0.;
  private var actualVelocity: Vector2 = new Vector2(0, 0);

  private var targetPosition: Vector2 = new Vector2(0, 0);

  public function movePosition(direction: Vector2, speed: Float) {
    moveSpeed = speed;
    moveDirection = direction * speed;
  }

  override function awake() {
    super.start();
    targetPosition = entity.position;
  }

  private function interpolateBody() {
    var posX = clampedValue(entity.position.x, targetPosition.x);
    var posY = clampedValue(entity.position.y, targetPosition.y);

    entity.x = Math.round(entity.x - posX);
    entity.y = targetPosition.y;
    //entity.y = Math.round(entity.y - posY);
  }

  private function clampedValue(a: Float, b: Float): Int {
    var val = (a - b) / Time.fMod;

    if (val > 0)
      return Math.round(Math.min(val, moveSpeed / 2));
    else if (val < 0)
      return Math.round(Math.max(val, -moveSpeed / 2));
    
    return 0;
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
    if (gravityEnabled)
      applyGravity();

    actualVelocity += velocity + moveDirection;

    if (collisionEnabled)
      checkCollision();

    targetPosition.x += actualVelocity.x;
    targetPosition.y += actualVelocity.y;

    actualVelocity.x = 0;
    actualVelocity.y = 0;
  }

  private function checkCollision() {
    isGrounded = false;
    if (collider != null) {
      // var r1 = new Rect(targetPosition.x, targetPosition.y, collider.rect.w, collider.rect.h);
      var r1 = collider.getRect();
      var margin = Math.max(Math.abs(actualVelocity.x), Math.abs(actualVelocity.y));
      var bodies = Game.allColliders; // Game.getStaticColliders(r1.addMargin(5));

      for (i in 0...bodies.length) {
        var r2 = bodies[i].getRect();

        if (Collider.checkSphereCollision(r1, r2)) {
          var hitHor = Collider.checkAABBCollision(r1, r2, new Vector2(actualVelocity.x, 0));
          if (hitHor) {
            var overlap = r1.x - r2.x;
            if (overlap < 0) {
              actualVelocity.x = 0;
              targetPosition.x = r2.x - (collider.rect.x + collider.rect.w);
            }
            if (overlap > 0) {
              actualVelocity.x = 0;
              targetPosition.x = (r2.x + r2.w) - collider.rect.x;
            }
          }
          
          r1 = collider.getRect();
          var hitVer = Collider.checkAABBCollision(r1, r2, new Vector2(0, actualVelocity.y));
          if (hitVer) {
            var overlap = r1.y - r2.y;
            if (overlap < 0) {
              isGrounded = true;
              actualVelocity.y = 0;
              targetPosition.y = r2.y - (collider.rect.y + collider.rect.h);
            }
            else if (overlap > 0) {
              jumpForce = 0;
              velocity.y = 0;
              actualVelocity.y = 0;
              targetPosition.y = (r2.y + r2.h) - collider.rect.y;
            }
          }
        }
      }
    }
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