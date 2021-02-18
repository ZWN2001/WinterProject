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
  final int commodityId;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
         appBar: AppBar(
           title: Text("id."+commodityId.toString()),
         ),
         body: DetailPage(commodityId: commodityId,),
         );
  }

}