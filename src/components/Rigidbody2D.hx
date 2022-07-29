package components;

import types.Vector2;

class Rigidbody2D extends Component {
  public var gravityEnabled: Bool = true;
  public var gravity: Float = 9.81;
  public var isGrounded: Bool = false;
  public var collider: Collider;

  // Different forces that affect the rigidbody
  private var jumpForce: Float = 0.;
  private var velocity: Vector2 = new Vector2(0., 0.);
  private var moveDirection: Vector2 = new Vector2(0, 0);
  private var actualVelocity: Vector2 = new Vector2(0, 0);

  public function movePosition(direction: Vector2) {
    moveDirection = direction;
  }

  private function moveRigidBody() {
    entity.x += actualVelocity.x;
    entity.y += actualVelocity.y;
    
    actualVelocity.x = 0;
    actualVelocity.y = 0;
  }

  /**
    Currently dependent on gravity being enabled to function
  **/
  public function jump(force: Float) {
    jumpForce = force;
  }

  override function fixedUpdate(dt:Float) {
    if (gravityEnabled)
      applyGravity(dt);

    actualVelocity += velocity + moveDirection;

    checkCollision();
    moveRigidBody();
  }

  private function checkCollision() {
    isGrounded = false;
    if (collider != null) {
      var bodies = Game.getStaticColliders(collider.getRect());

      for (i in 0...bodies.length) {
        if (Collider.checkSphereCollision(collider.getRect(), bodies[i].getRect())) {
          var r1 = collider.getRect();
          var r2 = bodies[i].getRect();
  
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
  }

  private function applyGravity(dt:Float) {
    if (jumpForce > 0) {
      velocity.y = -jumpForce;
      jumpForce -= gravity * dt;
    } else if (isGrounded) {
      velocity.y = 0.1;
    }
    else {
      velocity.y += gravity * dt;

      if (velocity.y > gravity) {
        velocity.y = gravity;
      }
    }
  }
}