import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../global/constant.dart';
import '../module/ball.dart';
import '../module/pin.dart';
import '../module/prize_box.dart';
import '../module/wall.dart';
import 'start_button.dart';
import 'win_dialog.dart';

class GameView extends StatelessWidget {
  GameView({super.key});

  final FlameGame _game = GameComponent();

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      backgroundBuilder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.orange,
        ),
      ),
      game: _game,
      overlayBuilderMap: {
        startButtonKeyName: (_, game) => StartButton(game: game as GameComponent),
        winDialogKeyName: (_, game) => WinDialog(game: game as GameComponent),
      },
      initialActiveOverlays: const [startButtonKeyName],
    );
  }
}

class GameComponent extends Forge2DGame {
  GameComponent();

  late Vector2 boardSize;
  late PositionComponent board;

  bool playing = false;

  String prizeName = '';
  Ball? ball;

  @override
  Future<void> onLoad() async {
    boardSize = Vector2(size.x / 2, size.y * 0.9);
    board = PositionComponent(
      position: size / 2,
      size: boardSize,
      anchor: Anchor.center,
    );
    board.addAll(createComponent(boardSize));
    add(board);
  }

  List<Component> createComponent(Vector2 boardSize) {
    final components = <Component>[];

    components.addAll(createBoundaries(boardSize: boardSize));
    // components.addAll(createPins(boardSize: boardSize));
    components.addAll(createPrizeBoxs(boardSize: boardSize));

    return components;
  }

  List<Component> createBoundaries({required Vector2 boardSize}) {
    final topLeft = Vector2.zero();
    final bottomRight = boardSize;
    final topRight = Vector2(bottomRight.x, topLeft.y);
    final bottomLeft = Vector2(topLeft.x, bottomRight.y);

    return [
      Wall(topLeft, topRight),
      Wall(topRight, bottomRight),
      Wall(bottomLeft, bottomRight),
      Wall(topLeft, bottomLeft)
    ];
  }

  List<Component> createPins({required Vector2 boardSize}) {
    final columnPositionMultiplier1 = boardSize.x / columnSize;
    final rowPositionMultiplier = boardSize.y * 0.75 / rowSize;

    final pins = <Component>[];
    for (int row = 0; row < rowSize; row++) {
      for (int column = 0; column <= columnSize; column++) {
        if ((row + column) % 2 == 1) {
          pins.add(
            Pin(
              size: boardSize.x / 80,
              position: Vector2(0, boardSize.y * 0.15) +
                  Vector2(
                    (column.toDouble() * columnPositionMultiplier1),
                    (row.toDouble() * rowPositionMultiplier),
                  ),
            ),
          );
        }
      }
    }

    return pins;
  }

  List<Component> createPrizeBoxs({required Vector2 boardSize}) {
    final boxes = <Component>[];

    final boxHeight = boardSize.y * 0.005;

    final boxWidths = [0.2, 0.125, 0.15, 0.1, 0.3, 0.125];
    final prizes = ['😭', '😆', '🙂', '😃', '🥲', '😎'];
    final prizePreviews = ['T^T', 'XD', ':)', ':D', '; v ;', 'B)'];

    double cursor = 0;

    for (int i = 0; i < boxWidths.length; i++) {
      final width = boardSize.x * boxWidths[i];

      if (i > 0) {
        boxes.add(createPrizeWall(cursor, boardSize.y));
      }
      boxes.add(PrizeBox(
        size: Vector2(width, boxHeight),
        position: Vector2(cursor, boardSize.y),
        onContactBall: () {
          playing = false;
          paused = true;
          prizeName = prizes[i];
          overlays.add(winDialogKeyName);
        },
      ));

      boxes.add(
        TextComponent(
          text: prizePreviews[i],
          textRenderer: TextPaint(
              style: const TextStyle(
            color: Colors.white,
            fontSize: 2,
          )),
          size: Vector2.zero(),
          position: Vector2(cursor + width / 2, boardSize.y - 3),
          anchor: Anchor.center,
        ),
      );

      cursor += width;
    }

    return boxes;
  }

  createPrizeWall(x, y) {
    return Wall(Vector2(x, y), Vector2(x, y * 0.9));
  }

  spawnBall() {
    ball?.removeFromParent();

    ball = Ball(
      initPosition: Vector2(
        Random().nextDouble() * boardSize.x,
        0,
      ),
      size: boardSize.x / 50,
    );

    board.add(ball!);
  }
}
