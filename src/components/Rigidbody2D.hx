package components;

import types.Rect;
import utils.Time;
import types.Vector2;

class Rigidbody2D extends Component {
  public var collisionEnabled: Bool = true;
  public var gravityEnabled: Bool = true;
  public var gravity: Int = 1;
  public var isGround: Bool = false;
  public var isCeil: Bool = false;
  public var isWallRight: Bool = false;
  public var isWallLeft: Bool = false;
  public var collider: Collider;

  // Different forces that affect the rigidbody
  private var jumpForce: Int = 0;
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
    var posX = clampedValue(entity.position.x, targetPosition.x, moveSpeed);
    var posY = clampedValue(entity.position.y, targetPosition.y, 30);

    entity.x -= Math.floor(posX);
    entity.y -= Math.floor(posY);
  }

  private function clampedValue(a: Float, b: Float, max: Float): Int {
    var val = (a - b) / Time.fMod;

    if (val > 0)
      return Math.round(Math.min(val, max / 2));
    else if (val < 0)
      return Math.round(Math.max(val, -max / 2));
    
    return 0;
  }

  /**
    Currently dependent on gravity being enabled to function
  **/
  public function jump(force: Int) {
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

  private function resetCollisionFlags() {
    isGround = false;
    isCeil = false;
    isWallRight = false;
    isWallLeft = false;
  }

  private function checkCollision() {
    resetCollisionFlags();

    if (collider != null) {
      var r1 = new Rect(
        targetPosition.x + collider.rect.x, 
        targetPosition.y + collider.rect.y, 
        collider.rect.w, 
        collider.rect.h);

      var bodies = Game.getStaticColliders(r1);

      for (i in 0...bodies.length) {
        var r2 = bodies[i].getRect();

        if (Collider.checkSphereCollision(r1, r2)) {
          var hitHor = Collider.checkAABBCollision(r1, r2, new Vector2(actualVelocity.x, 0));
          if (hitHor) {
            var overlap = r1.x - r2.x;
            if (overlap < 0) {
              actualVelocity.x = 0;
              targetPosition.x = r2.x - (collider.rect.x + collider.rect.w);
              isWallRight = true;
            }
            if (overlap > 0) {
              actualVelocity.x = 0;
              targetPosition.x = (r2.x + r2.w) - collider.rect.x;
              isWallLeft = true;
            }
          }
          
          r1 = new Rect(
            targetPosition.x + collider.rect.x, 
            targetPosition.y + collider.rect.y, 
            collider.rect.w, 
            collider.rect.h);
          
          var hitVer = Collider.checkAABBCollision(r1, r2, new Vector2(0, actualVelocity.y));
          if (hitVer) {
            var overlap = r1.y - r2.y;
            if (overlap < 0) {
              isGround = true;
              actualVelocity.y = 0;
              targetPosition.y = r2.y - (collider.rect.y + collider.rect.h);
            }
            else if (overlap > 0) {
              isCeil = true;
              actualVelocity.y = 0;
              targetPosition.y = (r2.y + r2.h) - collider.rect.y;
            }
          }
        }
      }
    }
  }

  private function applyGravity() {
    velocity.y += gravity;

    if (isGround)
      velocity.y = 0.1;
    else if (isCeil) {
      velocity.y = 0;
      jumpForce = 0;
    }

    if (jumpForce > 0) {
      velocity.y = -jumpForce;
      jumpForce -= gravity;
    }

    if (velocity.y > 20) {
      velocity.y = 20;
    }
  }
}