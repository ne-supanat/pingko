import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pingko/module/prize_box.dart';

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

class BallWallCallback extends ContactCallbacks {
  final Function() onContactPrizeBox;

  BallWallCallback({required this.onContactPrizeBox});

  @override
  void beginContact(Object other, Contact contact) {
    print('contact ${other.runtimeType}');
    if (other is PrizeBox) {
      onContactPrizeBox();
    }
  }
}

class BallSprite extends SpriteComponent {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  BallSprite() : super(size: Vector2.all(16));

  Future<void> onLoad() async {
    sprite = await Sprite.load('crate.png');
    anchor = Anchor.center;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // We don't need to set the position in the constructor, we can set it directly here since it will
    // be called once before the first time it is rendered.
    position = gameSize / 2;
  }
}
