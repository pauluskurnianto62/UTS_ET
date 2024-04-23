import 'package:flutter/material.dart';

class About extends StatelessWidget {

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: Text('High Score'),
   ),
   body: Center(
    child: Text("This is High Score"),
   ),
  );
 }
}