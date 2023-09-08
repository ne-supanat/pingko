import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pingko/module/ball.dart';

class PrizeBox extends BodyComponent {
  final Vector2 size;
  final Vector2 position;
  final Function() onContactBall;

  PrizeBox({required this.size, required this.position, required this.onContactBall});

  @override
  Body createBody() {
    final tempSize = size / 2;
    final shape = PolygonShape()
      ..setAsBox(
        tempSize.x,
        tempSize.y,
        Vector2(tempSize.x, -tempSize.y),
        0,
      );

    final fixtureDef = FixtureDef(
      shape,
      friction: 1,
      userData: BallWallCallback(onContactBall: onContactBall),
    );
    final bodyDef = BodyDef(
      userData: this,
      position: position,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class BallWallCallback extends ContactCallbacks {
  final Function() onContactBall;

  BallWallCallback({required this.onContactBall});

  @override
  void beginContact(Object other, Contact contact) {
    print('contact ${other.runtimeType}');
    if (other is Ball) {
      // other.remove(other);
      onContactBall();
    }
  }
}
