import 'package:flutter/material.dart';
import 'package:winter/Basic/tradeInfo.dart';
import 'package:winter/ChatArea/chatGroup.dart';
import 'package:winter/DemandArea/demandPage.dart';
import '../Mine/mine.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: MyHomePage(),
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
    DemandPage(),
    ChatGroup(),
    Mine(),
  ];
  @override
  Widget build(BuildContext navigationBarContext) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: widgetOptions.elementAt(selectedIndex),
          ),
          //_buildRoteFloatingBtn(),//右下角的浮动按钮
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label:'交易信息'),
          BottomNavigationBarItem(icon: Icon(Icons.add_to_photos_outlined), label:'需求信息'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label:'消息'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label:'我的'),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.blue,
        unselectedItemColor:Colors.grey ,
        onTap: onTapped,
      ),
    );
  }

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  //
  // Widget buildRoteFloatingBtn(){
  //   return  Positioned(
  //     right: 33,
  //     bottom: 33,
  //     //悬浮按钮
  //     child: RoteFloatingButton(
  //       //菜单图标组
  //       iconList: [
  //         Icon(Icons.add),
  //         Icon(Icons.search),
  //       ],
  //       //点击事件回调
  //       clickCallback: (int index){
  //       if(index==0){
  //         Navigator.of(context).pushNamed('add');
  //       }else{
  //         Navigator.of(context).pushNamed('search');
  //       }
  //       },
  //     ),
  //   );
  // }
}

