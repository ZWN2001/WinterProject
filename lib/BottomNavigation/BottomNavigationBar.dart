import 'package:flutter/material.dart';

import '../Mine.dart';


// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; //默认选中的界面索引
  final _widgetOptions = [
    Text('Index 0:主界面'),
     Mine(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('交易信息')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text('我的')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onTapped,
      ),
    );
  }
  
  //架构“我的”页面
    Widget buildMine(){
    return Scaffold(
    body:Column(
    children: [

    ],
    ) ,
    );
    }

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
