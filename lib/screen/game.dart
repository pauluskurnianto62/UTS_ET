import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  GamePage({super.key});
  String state = "COUNTDOWN"; // COUNTDOWN / REMEMBER / GUESS / COMPLETE
  String imageUrl = "";
  int maxPick = 5;
  int countdown = 5;
  int score = 0;
  bool? isCorrect;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<List<String>> images = [];
  List<int> imagesImagePick = [];
  List<int> imagesImageAnswer = [];
  List<int> imagesImageUserAnswer = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 20; i++) {
      images.add(['c-$i-1.png', 'c-$i-2.png', 'c-$i-3.png', 'c-$i-4.png']);
    }
    if (widget.state == "COUNTDOWN") {
      timer =
          Timer.periodic(const Duration(seconds: 1), (timer) => doCountdown());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void doCountdown() {
    setState(() {
      if (widget.countdown == 0) {
        timer?.cancel();
        widget.state = "REMEMBER";
        showRandomImage();
        timer = Timer.periodic(
            const Duration(seconds: 3), (timer) => showRandomImage());
        return;
      }
      widget.countdown -= 1;
    });
  }

  void showRandomImage() {
    setState(() {
      if (imagesImagePick.length >= widget.maxPick) {
        timer?.cancel();
        widget.state = "GUESS";
        timer =
            Timer.periodic(const Duration(seconds: 30), (timer) => answer(-1));
        return;
      }
      int pick = Random().nextInt(images.length);
      while (imagesImagePick.contains(pick)) {
        pick = Random().nextInt(images.length);
      }
      int ans = Random().nextInt(4);
      imagesImagePick.add(pick);
      imagesImageAnswer.add(ans);
      widget.imageUrl = images[pick][ans];
    });
  }

  void answer(int answer) {
    timer?.cancel();
    if (widget.state == "GUESS") {
      if (imagesImageAnswer[imagesImageUserAnswer.length] == answer) {
        // correct
        widget.score += 1;
        widget.isCorrect = true;
      } else {
        // wrong
        widget.isCorrect = false;
      }
      timer = Timer.periodic(
          const Duration(seconds: 3), (timer) => nextGuess(answer));
    }
    setState(() {});
  }

  void nextGuess(int ans) {
    timer?.cancel();
    imagesImageUserAnswer.add(ans);
    widget.isCorrect = null;
    if (imagesImageUserAnswer.length >= imagesImageAnswer.length) {
      widget.state = "COMPLETE";
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 30), (timer) => answer(-1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Game"),
      ),
      body: (widget.state == "COUNTDOWN")
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.countdown}s',
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Text(
                  'Get Ready',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )
          : (widget.state == "REMEMBER")
              ? Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/${widget.imageUrl}',
                      ),
                      Text('${imagesImagePick.length} of ${widget.maxPick}'),
                    ],
                  ),
                )
              : (widget.state == "GUESS")
                  ? Column(
                      children: [
                        const Text('Ingat gambarnya manakah yang tadi keluar?'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  answer(0);
                                },
                                child: Container(
                                  color: (widget.isCorrect != null)
                                      ? (imagesImageAnswer[imagesImageUserAnswer
                                                  .length] ==
                                              0)
                                          ? Colors.green
                                          : null
                                      : null,
                                  child: Image.asset(
                                    'assets/${images[imagesImagePick[imagesImageUserAnswer.length]][0]}',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  answer(1);
                                },
                                child: Container(
                                  color: (widget.isCorrect != null)
                                      ? (imagesImageAnswer[imagesImageUserAnswer
                                                  .length] ==
                                              1)
                                          ? Colors.green
                                          : null
                                      : null,
                                  child: Image.asset(
                                    'assets/${images[imagesImagePick[imagesImageUserAnswer.length]][1]}',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  answer(2);
                                },
                                child: Container(
                                  color: (widget.isCorrect != null)
                                      ? (imagesImageAnswer[imagesImageUserAnswer
                                                  .length] ==
                                              2)
                                          ? Colors.green
                                          : null
                                      : null,
                                  child: Image.asset(
                                    'assets/${images[imagesImagePick[imagesImageUserAnswer.length]][2]}',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  answer(3);
                                },
                                child: Container(
                                  color: (widget.isCorrect != null)
                                      ? (imagesImageAnswer[imagesImageUserAnswer
                                                  .length] ==
                                              3)
                                          ? Colors.green
                                          : null
                                      : null,
                                  child: Image.asset(
                                    'assets/${images[imagesImagePick[imagesImageUserAnswer.length]][3]}',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                            '${imagesImageUserAnswer.length + 1} of ${widget.maxPick}'),
                        if (widget.isCorrect != null && widget.isCorrect!)
                          Text(
                            'Your answer is correct\nYour score now is ${widget.score}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        if (widget.isCorrect != null &&
                            widget.isCorrect! == false)
                          Text(
                              'Your answer is wrong!\nYour score now is ${widget.score}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Game Complete',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text('Your score is ${widget.score}'),
                      ],
                    ),
    );
  }
}
