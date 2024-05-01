import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Highscore extends StatefulWidget {
  Highscore({super.key});
  List<String> listUsername = [];
  List<int> listScore = [];

  @override
  State<Highscore> createState() => _HighscoreState();
}

class _HighscoreState extends State<Highscore> {
  void getAllScore() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys().toList();
    for (String key in keys) {
      if (key.startsWith("score_")) {
        String username = key.substring(6);
        int score = prefs.getInt(key) ?? 0;
        widget.listUsername.add(username);
        widget.listScore.add(score);
        print("$username: $score");
      }
    }
    List<int> sortedScores = List.from(widget.listScore)..sort();
    sortedScores.reversed.toList();
    List<String> sortedUsernames = List.generate(
      widget.listUsername.length,
      (index) =>
          widget.listUsername[widget.listScore.indexOf(sortedScores[index])],
    );
    widget.listUsername = sortedUsernames.reversed.toList();
    widget.listScore = sortedScores.reversed.toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllScore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Score'),
      ),
      body: Column(
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Score')),
            ],
            rows: List.generate(
              widget.listUsername.length,
              (index) => DataRow(
                cells: [
                  DataCell(Text(widget.listUsername[index])),
                  DataCell(Text(widget.listScore[index].toString())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
