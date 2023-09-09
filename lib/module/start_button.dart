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
              width: 100,
              height: 100,
              child: IconButton(
                onPressed: () {
                  if (!game.playing) {
                    game.playing = true;
                    game.spawnBall();
                    game.paused = false;
                  }
                },
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 64,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
