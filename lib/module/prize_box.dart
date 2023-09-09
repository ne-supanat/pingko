import 'package:flame/components.dart';
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

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // add(BallSprite(objSize: size));
  }
}

class BallWallCallback extends ContactCallbacks {
  final Function() onContactBall;

  BallWallCallback({required this.onContactBall});

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      onContactBall();
    }
  }
}

class BallSprite extends SpriteComponent {
  BallSprite({required this.srcSize, required this.srcPosition});

  final Vector2 srcSize;
  final Vector2 srcPosition;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      'bg_board.jpg',
      srcSize: Vector2(10, 10),
      srcPosition: Vector2(0, 70),
    );
    anchor = Anchor.center;
    scale = srcSize / 2;
  }
}
