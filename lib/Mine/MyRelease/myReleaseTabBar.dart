import 'package:flutter/material.dart';
import 'myGoods.dart';
import 'myNeeds.dart';

class MyReleaseTabBar extends StatefulWidget {
  @override
  _MyReleaseTabBarState createState() => _MyReleaseTabBarState();
}

class _MyReleaseTabBarState extends State<MyReleaseTabBar> with TickerProviderStateMixin{

  //顶部导航栏的内容
  final List<Tab> Types = <Tab>[
    Tab(text:"我发布的商品"),
    Tab(text: "我发布的需求"),
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
                child: MyGoods(),
              ),
              Center(
                child: MyNeeds(),
              ),
            ],
          ),
        ));
  }

}