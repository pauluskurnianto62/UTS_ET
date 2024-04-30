import 'dart:async';
import 'dart:math';
import 'package:myproject/main.dart';

import 'package:flutter/material.dart';
import 'package:myproject/screen/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("user_name") ?? '';
    return username;
  }

class GamePage extends StatefulWidget {
  GamePage({super.key});


  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String state = "COUNTDOWN"; // COUNTDOWN / REMEMBER / GUESS / COMPLETE
  String imageUrl = "";
  int maxPick = 5;
  int countdown = 5;
  int timeleft = 30;
  int score = 0;
  bool? isCorrect;

  List<List<String>> images = [];
  List<int> imagesImagePick = [];
  List<int> imagesImageAnswer = [];
  List<int> imagesImageUserAnswer = [];
  Timer? timer;
  String username = "";

  bool animated = false;
  double opacityLevel = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        animated = !animated;
        opacityLevel = 1-opacityLevel;
      });
    });
    for (int i = 1; i <= 20; i++) {
      images.add(['c-$i-1.png', 'c-$i-2.png', 'c-$i-3.png', 'c-$i-4.png']);
    }
    if (state == "COUNTDOWN") {
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
      if (countdown == 0) {
        timer?.cancel();
        state = "REMEMBER";
        showRandomImage();
        timer = Timer.periodic(
            const Duration(seconds: 3), (timer) => showRandomImage());
        return;
      }
      countdown -= 1;
    });
  }

  void showRandomImage() {
    setState(() {
      if (imagesImagePick.length >= maxPick) {
        timer?.cancel();
        state = "GUESS";
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
      imageUrl = images[pick][ans];
    });
  }

  void answer(int answer) {
    timer?.cancel();
    if (state == "GUESS") {
      if (imagesImageAnswer[imagesImageUserAnswer.length] == answer) {
        // correct
        score += 1;
        isCorrect = true;
      } else {
        // wrong
        isCorrect = false;
      }
      timer = Timer.periodic(
          const Duration(seconds: 3), (timer) => nextGuess(answer));
    }
    setState(() {});
  }

  void nextGuess(int ans) {
    timer?.cancel();
    imagesImageUserAnswer.add(ans);
    isCorrect = null;
    if (imagesImageUserAnswer.length >= imagesImageAnswer.length) {
      //state = "COMPLETE";
      saveScore();
      if (score == 5) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Result(score, "Maestro dell'Indovinello (Master of Riddles)")));
      }
      else if (score == 4) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Result(score, "Esperto dell'Indovinello (Expert of Riddles)")));
      }
      else if (score == 3) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Result(score, "Abile Indovinatore (Skillful Guesser)")));
      }
      else if (score == 2) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Result(score, "Principiante dell'Indovinello (Riddle Beginner)")));
      }
      else if (score == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Result(score, "Neofita dell'Indovinello (Riddle Novice)")));
      }
      else if (score == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Result(score, "Sfortunato Indovinatore (Unlucky Guesser)")));
      }
      state = "COMPLETE";
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 30), (timer) => answer(-1));
    setState(() {});
  }

  void time(){

     timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        timeleft--;
        if(timeleft==0)
        {
          //_question_no++;
          //if(_question_no>_questions.length - 6) finishQuiz();
          //_hitung=_maxtime;
        }
      });
    });
  }

  void saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("my_username", username);
    prefs.setInt("my_score", score);
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Game"),
      ),
      body: (state == "COUNTDOWN")
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${countdown}s',
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
          : (state == "REMEMBER")
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: opacityLevel,
                        duration: const Duration(seconds: 1),
                        child:
                          Image.asset('assets/$imageUrl')
                      ),
                      //Image.asset(
                        //'assets/$imageUrl',
                      //),
                      Text('${imagesImagePick.length} of $maxPick'),
                    ],
                  ),
                )
              : (state == "GUESS")
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                  color: (isCorrect != null)
                                      ? (imagesImageAnswer[imagesImageUserAnswer
                                                  .length] ==
                                              0)
                                          ? Colors.green
                                          : null
                                      : null,
                                  child: Image.asset(
                                    'assets/${images[imagesImagePick[imagesImageUserAnswer.length]][0]}', width: 240, height: 240,
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
                                  color: (isCorrect != null)
                                      ? (imagesImageAnswer[imagesImageUserAnswer
                                                  .length] ==
                                              1)
                                          ? Colors.green
                                          : null
                                      : null,
                                  child: Image.asset(
                                    'assets/${images[imagesImagePick[imagesImageUserAnswer.length]][1]}', width: 240, height: 240,
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
                                  color: (isCorrect != null)
                                      ? (imagesImageAnswer[imagesImageUserAnswer
                                                  .length] ==
                                              2)
                                          ? Colors.green
                                          : null
                                      : null,
                                  child: Image.asset(
                                    'assets/${images[imagesImagePick[imagesImageUserAnswer.length]][2]}', width: 240, height: 240,
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
                                  color: (isCorrect != null)
                                      ? (imagesImageAnswer[imagesImageUserAnswer
                                                  .length] ==
                                              3)
                                          ? Colors.green
                                          : null
                                      : null,
                                  child: Image.asset(
                                    'assets/${images[imagesImagePick[imagesImageUserAnswer.length]][3]}', width: 240, height: 240,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                            '${imagesImageUserAnswer.length + 1} of $maxPick'),
                        if (isCorrect != null && isCorrect!)
                          Text(
                            'Your answer is correct\nYour score now is $score',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        if (isCorrect != null &&
                            isCorrect! == false)
                          Text(
                              'Your answer is wrong!\nYour score now is $score',
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
                        Text('Your score is $score'),
                      ],
                    ),
    );
  }
}
