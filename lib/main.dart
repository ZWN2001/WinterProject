
import 'package:flutter/material.dart';

void main() =>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: HomeContent(),
    ),
  );
  }
}
class HomeContent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

  }
}