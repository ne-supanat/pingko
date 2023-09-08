import 'package:flame_forge2d/flame_forge2d.dart';

class Pin extends BodyComponent {
  final double size;
  final Vector2 position;

  Pin({required this.position, required this.size});

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size;

    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.5,
      density: 10.0,
      friction: 0.4,
    );

    final bodyDef = BodyDef(
      userData: this,
      angularDamping: 0.8,
      position: position,
      type: BodyType.static,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
