import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myproject/screen/game.dart';
import 'package:myproject/screen/highscore.dart';
import 'package:myproject/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString("user_name") ?? '';
  return userId;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '') {
      runApp(const MyLogin());
    } else {
      active_user = result;
      runApp(const MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorimage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {'highscore': (context) => Highscore()},
      home: const MyHomePage(title: 'Memorimage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _user_name = "";
  bool animated = false;
  double opacityLevel = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        animated = !animated;
        opacityLevel = 1 - opacityLevel;
      });
    });
    checkUser().then((value) => setState(
          () {
            _user_name = value;
          },
        ));
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_name");
    main();
  }

  Widget funDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(_user_name),
              accountEmail: const Text(""),
              currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          ListTile(
              title: const Text("High Score"),
              leading: const Icon(Icons.score),
              onTap: () {
                Navigator.popAndPushNamed(context, "highscore");
              }),
          ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () {
                doLogout();
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedOpacity(
                opacity: opacityLevel,
                duration: const Duration(seconds: 1),
                child: const Text(
                  'Welcome to Memorimage',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1, fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Cara Bermain',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const ListTile(
                title: Text(
                  'Anda akan dihadapkan pada 1 gambar secara acak setiap 3 detik, disini anda harus mengingat gambar tersebut sampai 10 gambar',
                  style: TextStyle(fontSize: 14),
                ),
                leading: Text('1', style: TextStyle(fontSize: 24)),
              ),
              const ListTile(
                title: Text(
                  'Setelah selesai ditampilkan, anda akan dihadapkan pada 4 gambar secara acak yang serupa tetapi berbeda warna / bentuk, tugas anda disini adalah memlih gambar yang benar dari yang anda ingat',
                  style: TextStyle(fontSize: 14),
                ),
                leading: Text('2', style: TextStyle(fontSize: 24)),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GamePage()),
                    );
                  },
                  child: const Text('Mulai Bermain')),
            ],
          ),
        ),
        drawer: funDrawer());
  }
}
