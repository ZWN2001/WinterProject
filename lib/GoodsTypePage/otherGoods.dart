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

class OtherGoods extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new OtherGoodsState();
}

class OtherGoodsState extends State<OtherGoods> {

  List<Commodity> commodityList = new List();
  List<Commodity> otherGoodsList = new List();
  List<Commodity> tempList = new List();
  Iterable<Commodity> reservedList = new List();
  int startNum = 0;
  int _page = 1;
  bool isLoading = false;//是否正在加载数据
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getCommodityData().then((value) => {
      _transferIntoLocalList()
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("滑到了最底部");
        _getMore();
      }
    });
  }

  Future _getCommodityData() async {
    if(LoginPageState.logged) {
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
          setState(() {
            List commodityJson = response.data['data'];
            print("标记");
            print(commodityJson);
            commodityList = commodityJson.map((e) => Commodity.fromJson(e)).toList();
            print(commodityList);
            commodityList.forEach((element) {
              if (element.category == "其他"){
                otherGoodsList.add(element);
              }
            });
            print("digital");
            print(otherGoodsList);
          });
        }
      }
    }
  }

  _transferIntoLocalList() {
    if(LoginPageState.logged) {
      if (otherGoodsList.isNotEmpty) {
        reservedList = otherGoodsList.reversed;//确保时间顺序展示
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
          if (i == reservedList.length - 1){
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
            if (i == otherGoodsList.length || i == startNum+10) {
              print("没有更多数据了");
              isLoading = false;
              return;
            }
            tempList.insert(i, reservedList.elementAt(i));
          }
          _page++;
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return otherGoodsList.length == 0
        ? noCommodityText()
        : commodityGridView();
  }

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

  Widget noCommodityText() {
    return Center(
      child: Text("暂时还没有商品哦",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),),
    );
  }


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
                    Expanded(
                        child:Text(
                          tempList[temp].title,
                          textAlign: TextAlign.start,
                          maxLines: 1,
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
                          tempList[temp].price.toString(),
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

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      print("refresh");
      setState(() {
        commodityList.clear();
        tempList.clear();
        startNum = 0;
        _getCommodityData().then((value) => {
          _transferIntoLocalList()
        });
      });
    });
    Toast.show("刷新成功", context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  String _imageToList(int temp) {
    List imageList = json.decode(tempList[temp].image);
    return imageList[0];
  }

}
