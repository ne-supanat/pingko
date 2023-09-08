import 'package:flutter/material.dart';

import 'game_view.dart';

const startButtonKeyName = 'StartButton';

class StartButton extends StatelessWidget {
  final GameComponent game;
  const StartButton({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (!game.playing) {
                  game.playing = true;
                  game.spawnBall();
                  game.paused = false;
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text(
                game.prizeName.isEmpty ? 'Play' : 'Play again',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
