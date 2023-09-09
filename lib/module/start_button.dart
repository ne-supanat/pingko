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
        height: 200,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 75,
              child: ElevatedButton(
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
                    fontSize: 28.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
