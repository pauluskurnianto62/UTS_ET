import 'package:flutter/material.dart';
import 'package:myproject/screen/game.dart';
import 'package:myproject/screen/highscore.dart';
import 'package:myproject/main.dart';

class Result extends StatelessWidget {
  final int score;
  final String title;
  Result(this.score, this.title);

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: Text('Result'),
   ),
   body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Score: $score", style: TextStyle(fontSize: 24)), 
      Text("Title: $title", style: TextStyle(fontSize: 24)),
      Row(mainAxisAlignment: MainAxisAlignment.center, 
        children: [ElevatedButton(
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
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        },
        child: const Text('Main Menu'))])]
    ),
   ),
  );
 }
}