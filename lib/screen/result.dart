import 'package:flutter/material.dart';
import 'package:myproject/screen/game.dart';
import 'package:myproject/screen/highscore.dart';
import 'package:myproject/main.dart';

class Result extends StatelessWidget {
  final int score;
  final String title;
  const Result(this.score, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Score: $score", style: const TextStyle(fontSize: 24)),
          Text("Title: $title", style: const TextStyle(fontSize: 24)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GamePage()),
                  );
                },
                child: const Text('Play Again')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Highscore()),
                  );
                },
                child: const Text('High Score')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                },
                child: const Text('Main Menu'))
          ])
        ]),
      ),
    );
  }
}
