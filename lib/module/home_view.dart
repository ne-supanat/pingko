import 'package:flutter/material.dart';
import 'package:pingko/module/game_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String prizeText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameView());
  }
}
