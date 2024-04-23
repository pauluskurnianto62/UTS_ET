import 'package:flutter/material.dart';
import 'package:myproject/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_name") ?? '';
    return user_id;
  }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  @override
  void initState() {
    super.initState();
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
                accountEmail: Text(""),
                currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150"))),
            ListTile(
              title: new Text("High Score"),
              leading: new Icon(Icons.score),
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () {
                doLogout();
            })
          ],
        ),
      );
  }

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
            const Text(
              'Lorem ipsum dolor sit amet',
            ),
          ],
        ),
      ),
      drawer: funDrawer(),
    );
  }
}
