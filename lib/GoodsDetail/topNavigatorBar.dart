import 'package:flutter/material.dart';
import './detailPage.dart';

class TopNavigatorBar extends StatefulWidget {
  @override
  TopNavigatorBarState createState() => TopNavigatorBarState();
}

class TopNavigatorBarState extends State<TopNavigatorBar> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
         appBar: AppBar(
           title: Text("详细页面"),
         ),
         body: DetailPage(),
         );
  }

}