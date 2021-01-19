import 'package:flutter/material.dart';
import './detailPage.dart';

class TopNavigatorBar extends StatefulWidget {
  @override
  TopNavigatorBarState createState() => TopNavigatorBarState();
}

class TopNavigatorBarState extends State<TopNavigatorBar> {
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
       length: 2,
       child: Scaffold(
         appBar: AppBar(
           title: Text("详细页面"),
           bottom: TabBar(
             indicatorColor: Colors.blueGrey,
             unselectedLabelColor: Colors.white,
             tabs:<Widget> [
               Tab(text: "详情"),
               Tab(text: "评论"),
             ],
           ),
         ),
         body: TabBarView(
           children:<Widget> [
             DetailPage(),
             Container(
               child: Text("这是评论"),
             )
           ],
         ),
       ));
  }

}