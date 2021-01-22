import 'package:flutter/material.dart';
import 'package:winter/GoodsTypePage/allGoods.dart';

class NeedsInfo extends StatefulWidget {
  @override
  NeedsTabBarState createState() => NeedsTabBarState();
}

class NeedsTabBarState extends State<NeedsInfo> with TickerProviderStateMixin{

  //顶部导航栏的内容
  final List<Tab> productionTypes = <Tab>[
    Tab(text:"所有"),
    Tab(text: "数码产品"),
    Tab(text: "二手书"),
    Tab(text:"食品"),
    Tab(text:"生活用品"),
    Tab(text:"美妆"),
    Tab(text:"其他"),
  ];

  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = new TabController(length: 7, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: productionTypes.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: TabBar(
              tabs: productionTypes,
              isScrollable: true,
              labelColor: Colors.white,
              controller: _tabController,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children:<Widget> [
              Center(
                child: AllGoods(),
              ),
              Center(
                child: Text("这是数码产品"),
              ),
              Center(
                child: Text("这是二手书"),
              ),
              Center(
                child: Text("这是食物"),
              ),
              Center(
                child: Text("这是生活用品"),
              ),
              Center(
                child: Text("这是美妆用品"),
              ),
              Center(
                child: Text("这是其他物品"),
              ),
            ],
          ),
        ));
  }

}