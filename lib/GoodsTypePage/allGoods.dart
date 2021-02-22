import 'dart:convert';
import 'package:winter/Basic/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winter/GoodsDetail/topNavigatorBar.dart';
import 'package:winter/GoodsDetail/commodityClass.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart'hide BuildContext;
import 'package:winter/AdapterAndHelper/breakWord.dart';


class AllGoods extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AllGoodsState();
}

class AllGoodsState extends State<AllGoods> {

  //临时数据
  /*List listData = [
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
  ];*/

  List<Commodity> commodityList = new List();
  List<Commodity> tempList = new List();
  Iterable<Commodity> reservedList = new List();
  int startNum = 0;
  int itemLength = 0;
  int _page = 1;
  bool isLoading = false;//是否正在加载数据
  ScrollController _scrollController = ScrollController();
  Widget centerContent;
  bool needRefresh;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    needRefresh = false;
   /* if (!LoginPageState.logged) {
      Toast.show("请先登录", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }*/
   centerContent = _loadingText();
    _getCommodityData().then((value) => {
    _transferIntoLocalList()
    }).whenComplete(() {
      itemLength = tempList.length;
      if (commodityList.isEmpty) {
        setState(() {
          centerContent = noCommodityText();
        });
      } else {
        setState(() {
          centerContent = commodityGridView();
        });
      }
    });
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
      print(runtimeType);
      print(feedback);
      if (response.data['code'] == 0) {
        if (response.data['data'] == null) {
          print("no information");
          return;
        } else {
          if (mounted) {
            setState(() {
              List commodityJson = response.data['data'];
              print("标记");
              print(commodityJson);
              commodityList = commodityJson.map((e) => Commodity.fromJson(e)).toList();
              print(commodityList);
            });
          }
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
          for (int i = startNum; i <= startNum + 10; i++) {
            print('i');
            print(i);
            startNum = i;
            if (i == commodityList.length || i == startNum+10) {
              print("没有更多数据了");
              isLoading = false;
              return;
            }
            tempList.insert(i, reservedList.elementAt(i));
            print(tempList);
          }
          _page++;
          isLoading = false;

        });
      }).whenComplete(() {
        setState(() {
          itemLength = tempList.length;
          centerContent = commodityGridView();
          print('change');
        });
      });
    }
  }

  _transferIntoLocalList() {
    if(LoginPageState.logged) {
      if (commodityList != null) {
        reservedList = commodityList.reversed;//确保时间顺序展示
        print(reservedList);
        print(reservedList.length);
        //每次加载10条商品信息
        for (int i = 0; i < 10; i++) {
          startNum = i+1;
          if (reservedList.length == 1){
            tempList.insert(0, reservedList.elementAt(0));
            startNum = 1;
            return;
          }
          if (i == reservedList.length){
            startNum = i;
            print("没有更多数据");
            //startNum = i;
            return;
          }
          //tempList[i] = reservedList.elementAt(i);
          tempList.insert(i, reservedList.elementAt(i));
          print(tempList[i].image);
        }
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
   return centerContent;
      /*return commodityList.length == 0
          ? noCommodityText()
          : commodityGridView();*/
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
            itemCount: itemLength,
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
        _getCommodityData().then((value) => {
          _transferIntoLocalList()
        }).whenComplete(() {
          itemLength = tempList.length;
          if (commodityList.isEmpty) {
            setState(() {
              centerContent = noCommodityText();
            });
          } else {
            setState(() {
              centerContent = commodityGridView();
            });
          }
        });
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

  Widget _loadingText() {
    return  Center(
        child: Text(
          "加载中...",
          style: TextStyle(fontSize: 20),
        ),
      );
  }

  //每个商品的窗口
  Widget itemWidget(int temp) {
    return InkWell(
      onTap: (){
        Navigator.push(context,new MaterialPageRoute(builder: (context){
          return new TopNavigatorBar(commodityId: tempList[temp].commodityId);
        }));
      },//点击后进入详细页面
        child: Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget> [
                Row(
                  children: [
                    Expanded(
                        child:SizedBox(
                          height: 130,
                          child: //Text("暂时没有图片哦", style: TextStyle(color: Colors.grey, fontSize: 10),textAlign: TextAlign.center,)
                          tempList[temp].image.isEmpty
                          ? Text("暂时没有图片哦", style: TextStyle(color: Colors.grey, fontSize: 10),textAlign: TextAlign.center)
                          : Image.network(_imageToList(temp), fit: BoxFit.cover,),
                        )
                        /*Image.network(
                          tempList[temp].image,
                          fit: BoxFit.cover,
                        )*/
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 160,
                      child: Text(
                        BreakWord.breakWord(tempList[temp].title),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    )
                    ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                        child:Text('￥',textAlign: TextAlign.start,style: TextStyle(fontSize: 9),)),
                    Expanded(
                      flex: 15,
                        child:Text(
                            tempList[temp].price.toString(),
                            //textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.red,
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

  //将所有图片放入一个list，默认加载第一张
  String _imageToList(int temp) {
    List imageList = json.decode(tempList[temp].image);
    return imageList[0];
  }

}