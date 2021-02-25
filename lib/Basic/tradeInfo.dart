import 'package:flutter/material.dart';
import 'package:winter/GoodsTypePage/allGoods.dart';
import 'package:winter/GoodsTypePage/digitalProduct.dart';
import 'package:winter/GoodsTypePage/usedBook.dart';
import 'package:winter/GoodsTypePage/food.dart';
import 'package:winter/GoodsTypePage/dailyNecessity.dart';
import 'package:winter/GoodsTypePage/cosmetics.dart';
import 'package:winter/GoodsTypePage/otherGoods.dart';
import 'package:winter/AdapterAndHelper/buildRoteFloatingBtn.dart';

class TradeInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TradeInfoState();
}

class TradeInfoState extends State<TradeInfo> with TickerProviderStateMixin{

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
    return Stack(
      children: [
        Material(
            child:DefaultTabController(
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
                        child: DigitalProduct(),
                      ),
                      Center(
                        child: UsedBook(),
                      ),
                      Center(
                        child: Food(),
                      ),
                      Center(
                        child: DailyNecessity(),
                      ),
                      Center(
                        child: Cosmetics(),
                      ),
                      Center(
                        child: OtherGoods(),
                      ),
                    ],
                  ),
                ))
        ),
        buildRoteFloatingBtn(),
      ],
    );

  }

}