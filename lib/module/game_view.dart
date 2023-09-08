import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pingko/module/start_button.dart';
import 'package:pingko/module/win_dialog.dart';

import '../global/constant.dart';
import '../module/ball.dart';
import '../module/pin.dart';
import '../module/prize_box.dart';
import '../module/wall.dart';

class GameView extends StatelessWidget {
  GameView({super.key});

  final FlameGame _game = GameComponent();

  @override
  Widget build(BuildContext context) {
    return GameWidget(
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
    components.addAll(createPins(boardSize: boardSize));
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
        if ((row + column) % 2 == 0) {
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

    final boxWidths = [0.3, 0.15, 0.15, 0.25, 0.15];
    final onContactFunctions = [onWin1, onWin2, onWin3, onWin4, onWin5];

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
          onContactFunctions[i]();
          overlays.add(winDialogKeyName);
        },
      ));

      cursor += width;
    }

    return boxes;
  }

  createPrizeWall(x, y) {
    return Wall(Vector2(x, y), Vector2(x, y * 0.9));
  }

  onWin1() {
    final text = 'win1 -> show reward & restart';
    print(text);
    prizeName = text;
  }

  onWin2() {
    final text = 'win2 -> show reward & restart';
    print(text);
    prizeName = text;
  }

  onWin3() {
    final text = 'win3 -> show reward & restart';
    print(text);
    prizeName = text;
  }

  onWin4() {
    final text = 'win4 -> show reward & restart';
    print(text);
    prizeName = text;
  }

  onWin5() {
    final text = 'win5 -> show reward & restart';
    print(text);
    prizeName = text;
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
