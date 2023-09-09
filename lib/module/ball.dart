import 'package:flame_forge2d/flame_forge2d.dart';

class Ball extends BodyComponent {
  final double size;
  final Vector2 initPosition;

  Ball({required this.initPosition, required this.size});

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size;

    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.8,
      density: 20.0,
      friction: 0.4,
    );

    final bodyDef = BodyDef(
      userData: this,
      angularDamping: 0.8,
      position: initPosition,
      type: BodyType.dynamic,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
