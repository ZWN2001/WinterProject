import 'package:flutter/material.dart';
import 'package:winter/GoodsDetail/detailPage.dart';
import './detailPage.dart';

class TopNavigatorBar extends StatefulWidget {
  TopNavigatorBar({this.commodityId});
  final int commodityId;
  @override
  TopNavigatorBarState createState() => TopNavigatorBarState(commodityId: commodityId);
}

class TopNavigatorBarState extends State<TopNavigatorBar> {
  TopNavigatorBarState({this.commodityId});
  int commodityId;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
         appBar: AppBar(
         ),
         body: DetailPage(commodityId: commodityId,),
         );
  }

}