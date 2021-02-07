import 'dart:convert';
import 'package:winter/Basic/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winter/GoodsDetail/topNavigatorBar.dart';
import 'package:winter/GoodsDetail/commodityClass.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart';


class AllGoods extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AllGoodsState();
}

class AllGoodsState extends State<AllGoods> {

  //临时数据
  List listData = [
    {
      "title": "标题1",
      "price": "价格1",
      "image": "https://www.itying.com/images/flutter/1.png",
      "commodityId": "1",
      "description": "lalala",
      "category": "null",
      "account": "123"
    },
    {
      "title": "标题2",
      "price": "价格2",
      "image": "https://www.itying.com/images/flutter/2.png",
      "commodityId": "1",
      "description": "lalala",
      "category": "null",
      "account": "123"
    },
    {
      "title": "标题3",
      "price": "价格3",
      "image": "https://www.itying.com/images/flutter/3.png",
      "commodityId": "1",
      "description": "lalala",
      "category": "null",
      "account": "123"
    },
    {
      "title": "标题4",
      "price": "价格4",
      "image": "https://www.itying.com/images/flutter/4.png",
      "commodityId": "1",
      "description": "lalala",
      "category": "null",
      "account": "123"
    },
    {
      "title": "标题5",
      "price": "价格5",
      "image": "https://www.itying.com/images/flutter/5.png",
      "commodityId": "1",
      "description": "lalala",
      "category": "null",
      "account": "123"
    },
    {
      "title": "标题6",
      "price": "价格6",
      "image": "https://www.itying.com/images/flutter/6.png",
      "commodityId": "1",
      "description": "lalala",
      "category": "null",
      "account": "123"
    },
    {
      "title": "标题7",
      "price": "价格7",
      "image": "https://www.itying.com/images/flutter/7.png",
      "commodityId": "1",
      "description": "lalala",
      "category": "null",
      "account": "123"
    },
    {
      "title": "标题8",
      "price": "价格8",
      "image": "https://www.itying.com/images/flutter/1.png",
      "commodityId": "1",
      "description": "lalala",
      "category": "null",
      "account": "123"
    },
    {
      "title": "标题9",
      "price": "价格9",
      "image": "https://www.itying.com/images/flutter/2.png",
      "commodityId": "1",
      "description": "lalala",
      "category": "null",
      "account": "123"
    }
  ];

  List<Commodity> commodityList = new List();
  List<Commodity> tempList = new List();
  int startNum = 0;
  int _page = 1;
  bool isLoading = false;//是否正在加载数据
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCommodityData();
    _transferIntoLocalList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("滑到了最底部");
        _getMore();
      }
    });
  }

  Future _getCommodityData() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post('http://widealpha.top:8080/shop/commodity/allCommodity',
        options: Options(headers: {'Authorization':'Bearer'+LoginPageState.token}));
    String feedback = response.data.toString();
    print(feedback);
    if (response.data['code'] == 0) {
      if (response.data['data'] == null) {
        print("no information");
        return;
      } else {
        setState(() {
          List commodityJson = JsonDecoder().convert(response.data['data'].toString());
          commodityList = commodityJson.map((e) => Commodity.fromJson(e)).toList();
        });
      }
    }
  }

  Future _getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1), () {
        print("加载更多");
        setState(() {
          for (int i = startNum; i < startNum + 10; i++) {
            startNum = i;
            if (i == commodityList.length) {
              print("没有更多数据了");
              isLoading = false;
              return;
            }
            tempList[i] = commodityList[i];
          }
          _page++;
          isLoading = false;
        });
      });
    }
  }

  _transferIntoLocalList() {
    if (commodityList != null) {
      commodityList.reversed;//确保时间顺序展示
      //每次加载10条商品信息
      for (int i = 0; i < 10; i++) {
        startNum = i;
        if (i == commodityList.length){
          print("没有更多数据");
          //startNum = i;
          return;
        }
        tempList[i] = commodityList[i];
        print(tempList[i]);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return commodityList.length == 0
        ? noCommodityText()
        : commodityGridView();
    /*GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                scrollDirection: Axis.vertical,
                itemCount: listData.length,
                itemBuilder: (context,index){
                  return Material(
                    child: itemWidget(index),
                  );
                });*/
  }

  //有商品时的页面
  Widget commodityGridView() {
    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            //itemCount: listData.length,
            itemCount: tempList.length,
            itemBuilder: (context,index){
              return Material(
                child: itemWidget(index),
              );
            })
    );
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      print("refresh");
      setState(() {
        commodityList.clear();
        tempList.clear();
        startNum = 0;
        _getCommodityData();
        _transferIntoLocalList();
      });
    });
    Toast.show("刷新成功", context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  //无商品时的页面
  Widget noCommodityText() {
    return Center(
      child: Text("暂时还没有商品哦",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 20,
      ),),
    );
  }

  //每个商品的窗口
  Widget itemWidget(int temp) {
    return InkWell(
      onTap: (){
        Navigator.push(context,new MaterialPageRoute(builder: (context){
          return new TopNavigatorBar();
        }));
      },//点击后进入详细页面
        child:  Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget> [
                Row(
                  children: [
                    Expanded(
                        child:
                        Image.network(
                          tempList[temp].image,
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child:Text(
                            tempList[temp].title,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                            ),
                          )
                        )
                    ],
                ),
                Row(
                  children: [
                    Expanded(
                        child:Text(
                            tempList[temp].price,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                            ),
                          )
                        )],
                ),
              ],
            ),
            decoration: BoxDecoration(
                border: Border.all(color:DarkModeModel.darkMode ? Colors.white : Colors.black87,width: 1)
            ),
          );
        }
    ));
  }

}