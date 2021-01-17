import 'package:flutter/material.dart';
import 'package:winter/addGoods.dart';
import '../mine.dart';

class bottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext navigationBarContext) {
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
    Home(),
    Mine(),
  ];
  @override
  Widget build(BuildContext navigationBarContext) {
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
    );
  }

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
class Home extends StatelessWidget{
  @override
  Widget build(BuildContext navigationBarContext) {
   return Scaffold(
     body:Center(
       child:  FloatingActionButton(
         onPressed:(){ Navigator.push(navigationBarContext, MaterialPageRoute(builder: (context)=>AddGoods()));},
       ),
     )
   );
  }
}
