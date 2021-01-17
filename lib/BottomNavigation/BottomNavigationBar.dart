import 'package:flutter/material.dart';
import '../Mine.dart';
import '../tradeInfo.dart';

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
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0; //默认选中的界面索引
  final widgetOptions = [
    TradeInfo(),
    Mine(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('交易信息')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text('我的')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.blue,
        onTap: onTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
       /* onPressed: (){
        },*/
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
