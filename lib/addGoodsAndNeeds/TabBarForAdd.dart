import 'package:flutter/material.dart';
import 'package:winter/GoodsTypePage/allGoods.dart';
import 'package:winter/addGoodsAndNeeds/addGoods.dart';
import 'package:winter/addGoodsAndNeeds/addNeeds.dart';

class TabBarForAdd extends StatefulWidget {
  @override
  _TabBarForAddState createState() => _TabBarForAddState();
}

class _TabBarForAddState extends State<TabBarForAdd> with TickerProviderStateMixin{

  //顶部导航栏的内容
  final List<Tab> Types = <Tab>[
    Tab(text:"我要发布商品"),
    Tab(text: "我要发布需求"),
  ];

  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: Types.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: TabBar(
              tabs: Types,
              // isScrollable: true,
              labelColor: Colors.white,
              controller: _tabController,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children:<Widget> [
              Center(
                child: AddGoods(),
              ),
              Center(
                child: AddNeeds(),
              ),
            ],
          ),
        ));
  }

}