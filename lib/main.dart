import 'package:flutter/material.dart';
import 'package:winter/addGoodsAndNeeds/TabBarForAdd.dart';
//import 'file:///E:/apps/winter/lib/addGoodsAndNeeds/addGoods.dart';
import 'package:winter/tradeInfo.dart';
import 'package:winter/DemandArea/NeedsTabBar.dart';
import 'addGoodsAndNeeds/addNeeds.dart';
import 'logIn.dart';
import 'mine.dart';
import 'package:provider/provider.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';
import 'package:winter/DemandArea/demandPage.dart';

void main() => runApp(bottomNavigationBar());

class bottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider<DarkModeModel>(builder: (_) => DarkModeModel())
    ],
    child: Consumer<DarkModeModel>(
    builder: (context, DarkModeModel, child) {
    return  MaterialApp(
      routes: {
        //命名路由
        'MyHomePage':(context)=>MyHomePage(),
        'LoginPage':(context)=>LoginPage(),
        'add':(context)=>TabBarForAdd(),



      },
        theme: DarkModeModel.darkMode == true
            ? ThemeData.dark()
            : ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:Scaffold(
          body: MyHomePage(),
        )
    );

    },
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
    NeedsInfo(),
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

          _buildRoteFloatingBtn(),//右下角的浮动按钮

        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('交易信息')),
          BottomNavigationBarItem(icon: Icon(Icons.add_to_photos_outlined), title: Text('需求信息')),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text('我的')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.blue,
        onTap: onTapped,
      ),


      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed:(){
      //     Navigator.push(navigationBarContext, MaterialPageRoute(builder: (context)=>AddGoods()));
      //     },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget _buildRoteFloatingBtn(){
    return  Positioned(
      right: 33,
      bottom: 33,
      //悬浮按钮
      child: RoteFloatingButton(
        //菜单图标组
        iconList: [
          Icon(Icons.add),
          Icon(Icons.search),
        ],
        //点击事件回调
        clickCallback: (int index){
        if(index==0){
          Navigator.of(context).pushNamed('add');
        }else{
            //
        }
        },
      ),
    );

  }
}
// class Home extends StatelessWidget{
//   @override
//   Widget build(BuildContext navigationBarContext) {
//    return Scaffold(
//      body:Center(
//        child:  FloatingActionButton(
//          child: Icon(Icons.add),
//          onPressed:(){ Navigator.push(navigationBarContext, MaterialPageRoute(builder: (context)=>AddGoods()));},
//        ),
//
//      )
//    );
//   }
// }
