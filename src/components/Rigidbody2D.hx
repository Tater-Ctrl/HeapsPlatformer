package components;

import hxd.Timer;
import types.Rect;
import utils.Debug;
import types.Vector2;

class Rigidbody2D extends Component {
  public var gravityEnabled: Bool = true;
  public var gravity: Float = 8;
  public var isGrounded: Bool = false;
  public var collider: CollisionBody;
  
  // Different forces that affect the rigidbody
  private var jumpForce: Float = 0.;
  private var velocity: Vector2 = new Vector2(0., 0.);
  private var moveDirection: Vector2 = new Vector2(0, 0);
  private var collisionOffset: Vector2 = new Vector2(0, 0);

  public function movePosition(direction: Vector2) {
    moveDirection = direction;
  }

  private function moveBody(direction: Vector2) {
    entity.x += direction.x - collisionOffset.x;
    entity.y += direction.y - collisionOffset.y;

    collisionOffset.x = 0;
    collisionOffset.y = 0;
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
    
    checkCollision();
    moveBody(new Vector2(0, velocity.y) + moveDirection);
  }

  private function checkCollision() {
    isGrounded = false;
    if (collider != null) {
      var start = Sys.time() * 1000;
      var bodies = Game.inst.quadTreeColliders.retrieve(collider.getRect());
      for (i in 0...bodies.length) {
        var hit = collider.checkAABBCollision(bodies[i].getRect(), velocity);

        if (hit) {
          var offset = collider.getRect().position - bodies[i].getRect().position;

          if (offset.y < 0) {
            isGrounded = true;
            collisionOffset.y = offset.y + collider.rect.height;
            if (velocity.y > 0)
              velocity.y = 0; 
            if (moveDirection.y > 0)
              moveDirection.y = 0;
          }
          if (offset.y > 0) {
            collisionOffset.y = offset.y - bodies[i].rect.height;
            jumpForce = 0;

            if (velocity.y < 0)
              velocity.y = 0;
            if (moveDirection.y < 0)
              moveDirection.y = 0;
          }
        }
      }

      var end = Sys.time() * 1000;
      trace(end - start);
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