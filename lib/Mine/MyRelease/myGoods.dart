import 'dart:convert';
import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:winter/AdapterAndHelper/darkModeModel.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winter/GoodsDetail/topNavigatorBar.dart';
import 'package:winter/GoodsDetail/commodityClass.dart';
import 'package:winter/Basic/login.dart';
import 'package:toast/toast.dart';

class MyGoods extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyGoodsState();
}

class MyGoodsState extends State<MyGoods> {

  //临时数据
  List listData = [
    {
      "title": "标题1标题1标题1标题1标题1标题1标题1标题1标题1",
      "price": "价格1",
      "image": "https://www.itying.com/images/flutter/1.png"
    },
    {
      "title": "标题2",
      "price": "价格2",
      "image": "https://www.itying.com/images/flutter/2.png"
    },
    {
      "title": "标题3",
      "price": "价格3",
      "image": "https://www.itying.com/images/flutter/3.png"
    },
    {
      "title": "标题4",
      "price": "价格4",
      "image": "https://www.itying.com/images/flutter/4.png"
    },
    {
      "title": "标题5",
      "price": "价格5",
      "image": "https://www.itying.com/images/flutter/5.png"
    },
    {
      "title": "标题6",
      "price": "价格6",
      "image": "https://www.itying.com/images/flutter/6.png"
    },
    {
      "title": "标题7",
      "price": "价格7",
      "image": "https://www.itying.com/images/flutter/7.png"
    },
    {
      "title": "标题8",
      "price": "价格8",
      "image": "https://www.itying.com/images/flutter/1.png"
    },
    {
      "title": "标题9",
      "price": "价格9",
      "image": "https://www.itying.com/images/flutter/2.png"
    }
  ];

  List<Commodity> myCommodityList = new List();
  List<Commodity> tempList = new List();
  Iterable<Commodity> reservedList = new List();
  int startNum = 0;
  int _page = 1;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  SlidableController slidableController = SlidableController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMyCommodityData().then((value) => {
      _transferIntoLocalList()
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("滑到了最底部");
        _getMore();
      }
    });
  }

  //获取我发布的商品
  Future _getMyCommodityData() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post('http://widealpha.top:8080/shop/commodity/myCommodity',
    options: Options(headers: {'Authorization':'Bearer'+LoginPageState.token}));
    String feedback = response.data.toString();
    print(feedback);
    if (response.data['code'] == 0) {
      if (response.data['data'] == null) {
        print("no information");
        return;
      } else {
        setState(() {
          List commodityJson = response.data['data'];
          myCommodityList = commodityJson.map((e) => Commodity.fromJson(e)).toList();
          print(myCommodityList);
        });
      }
    }
  }

  //下拉加载更多
  Future _getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1), () {
        print("加载更多");
        setState(() {
          for (int i = startNum; i <= startNum + 10; i++) {
            startNum = i;
            if (i == myCommodityList.length || i == startNum + 10) {
              print("没有更多数据了");
              isLoading = false;
              return;
            }
            tempList.insert(i, reservedList.elementAt(i));
          }
          _page++;
          print(_page);
          isLoading = false;
        });
      });
    }
  }

  _transferIntoLocalList() {
    if (myCommodityList != null) {
      reservedList = myCommodityList.reversed;
      print(reservedList);
      print(reservedList.length);
      for (int i = 0; i < 10; i++) {
        startNum = i+1;
        if (reservedList.length == 1) {
          tempList.insert(0, reservedList.elementAt(0));
          startNum = 1;
          return;
        }
        if (i == reservedList.length) {
          print("后端没有更多数据了");
          return;
        }
        tempList.insert(i, reservedList.elementAt(i));
        print(tempList[i].image);
      }
    }
  }
  
  Future<void> _deleteMyCommodity(int commodityId) async {
    Dio dio = new Dio();
    Response response = await dio.post('http://widealpha.top:8080/shop/commodity/deleteMyCommodity',
    options: Options(headers: {'Authorization':'Bearer'+LoginPageState.token}),
    queryParameters: {
      'commodityId': commodityId
    });
    print('delete');
    print(response.data.toString());
    if (response.data['code'] == 0) {
      if (response.data['data'] == true) {
        Toast.show("删除成功", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("删除失败", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  //总UI
  @override
  Widget build(BuildContext context) {
    return myCommodityList.length == 0
        ? noCommodityText()
        : myCommodityListView();
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

  _showSnack (BuildContext context, type) {
    print(type);
  }

  //有发布时的页面
  Widget myCommodityListView() {
    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            itemCount: tempList.length,
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 5),
            //separatorBuilder: (BuildContext context, int index) => new Divider(),
            itemBuilder: (context, index) {
              return Slidable(
                key: GlobalKey<MyGoodsState>(),
                controller: slidableController,
                actionPane: SlidableScrollActionPane(),
                actionExtentRatio: 0.2,
                enabled: true,
                dismissal: SlidableDismissal(
                  child: SlidableDrawerDismissal(),
                  onDismissed: (actionType) {
                    _showSnack(
                      context,
                      actionType == SlideActionType.primary
                          ? 'Dismiss Archive'
                          : 'Dismiss Delete');
                      setState(() {
                        _deleteMyCommodity(tempList[index].commodityId).then((value) {
                          setState(() {
                            tempList.removeAt(index);
                          });
                          print('remove');
                          print(tempList);
                        });
                      });
                  },
                  onWillDismiss: (actionType) {
                    return showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("提示"),
                          content: Text("确认删除这个商品吗？"),
                          actions:<Widget> [
                            FlatButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text("取消")),
                            FlatButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text("确认"))
                          ],
                        );
                      }
                    );
                  },
                ),
                child: itemWidget2(index),
                secondaryActions:<Widget> [
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    closeOnTap: false,
                    onTap: (){
                    },
                  )
                ],
              );
              /*Material(
                child: itemWidget2(index),
              );*/
            }),
    );
  }

  //刷新
  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      print("refresh");
      setState(() {
        myCommodityList.clear();
        tempList.clear();
        startNum = 0;
        _getMyCommodityData().then((value) => {
          _transferIntoLocalList()
        });
      });
    });
    Toast.show("刷新成功", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  Widget noCommodityText() {
    return Center(
      child: Text(
        "您还没有发布商品哦",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20
        ),
      ),
    );
  }



  //每个商品的窗口
  /*Widget itemWidget(int temp) {
    return InkWell(
        onTap: (){
          *//*Navigator.push(context,new MaterialPageRoute(builder: (context){
            return new TopNavigatorBar();
          }));*//*
        },//点击后进入详细页面
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget> [
              Row(
                children: [
                  Expanded(
                      child:
                      Image.network(
                        listData[temp]["image"],
                        fit: BoxFit.cover,
                      )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child:Text(
                        listData[temp]["title"],
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child:Text(
                        listData[temp]["price"],
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white,width: 1)
          ),
        )
    );
  }*/

  //每个商品的窗口（新UI）
  Widget itemWidget2(int temp) {
    return InkWell(
      onLongPress: () {},//长按删除
      //onTap: () {},
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<DarkModeModel>(create: (child) => DarkModeModel())
        ],
        child: Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
          return Container(
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:<Widget> [
                  Column(
                    children: [
                      Expanded(
                          child: SizedBox(
                            width: 125,
                            height: 84,
                            child: tempList[temp].image.isEmpty
                                ? Text("暂时没有图片哦",style: TextStyle(color: Colors.grey, fontSize: 10),textAlign: TextAlign.center,)
                                : Image.network(_imageToList(temp), fit: BoxFit.cover,)
                          ))
                    ],
                  ),
                  Column(
                    children: [
                        Container(
                          width: 200,
                          padding: EdgeInsets.only(left: 18, top: 10),
                            child: Text(
                              tempList[temp].title,
                              textAlign: TextAlign.left,
                              style: TextStyle(color: DarkModeModel.darkMode ? Colors.white : Colors.black87,fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                        ),

                      Container(
                        width: 200,
                            padding: EdgeInsets.only(left: 18,top: 15),
                            child: Text(
                              "￥"+tempList[temp].price.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(color: DarkModeModel.darkMode ? Colors.white : Colors.black87,fontSize: 12),),
                          )],
                  ),
                ],
              ),
            )
          );
        },),
      )
    );
  }

  //将所有图片放入一个list，默认加载第一张
  String _imageToList(int temp) {
    List imageList = json.decode(tempList[temp].image);
    return imageList[0];
  }

}