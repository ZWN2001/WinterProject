import 'package:flutter/material.dart';
import './detailPage.dart';

class TopNavigatorBar extends StatefulWidget {
  TopNavigatorBar({this.commodityId});
  final int commodityId;
  @override
  TopNavigatorBarState createState() => TopNavigatorBarState(commodityId: commodityId);
}

class TopNavigatorBarState extends State<TopNavigatorBar> {
  TopNavigatorBarState({this.commodityId});
  final int commodityId;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
         appBar: AppBar(
           title: Text("详细页面"),
         ),
         body: DetailPage(commodityId: commodityId,),
         );
  }

}