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
import 'package:winter/AdapterAndHelper/breakWord.dart';


class DigitalProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DigitalProductState();
}

class DigitalProductState extends State<DigitalProduct> {

  List<Commodity> commodityList = new List();
  List<Commodity> digitalProductList = new List();
  List<Commodity> tempList = new List();
  Iterable<Commodity> reservedList = new List();
  int startNum = 0;
  int _page = 1;
  bool isLoading = false;//是否正在加载数据
  ScrollController _scrollController = ScrollController();
  int itemLength;
  Widget centerContent;

  @override
  void initState() {
    super.initState();
    centerContent = loadingText();
    _getCommodityData().then((value) => {
      _transferIntoLocalList()
    }).whenComplete(() {
      itemLength = tempList.length;
      if (digitalProductList.isEmpty) {
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
              if (element.category == "数码产品"){
                digitalProductList.add(element);
              }
            });
            print("digital");
            print(digitalProductList);
          });
        }
      }
    }
  }

  _transferIntoLocalList() {
    if(LoginPageState.logged) {
      if (digitalProductList.isNotEmpty) {
        reservedList = digitalProductList.reversed;//确保时间顺序展示
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
            if (i == digitalProductList.length || i == startNum+10) {
              print("没有更多数据了");
              isLoading = false;
              return;
            }
            tempList.insert(i, reservedList.elementAt(i));
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return centerContent;
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
            itemCount: itemLength,
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

  Widget loadingText() {
    return Center(
      child: Text(
        "加载中...",
        style: TextStyle(fontSize: 20),
      ),
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
                              ? Center(child: Text("暂时没有图片哦", style: TextStyle(color: Colors.grey, fontSize: 10),textAlign: TextAlign.center),)
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
                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                      width: 160,
                      child: Text(
                        BreakWord.breakWord(tempList[temp].title),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.0,
                          color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('￥',textAlign: TextAlign.start,style: TextStyle(fontSize: 9, color: Colors.red),),
                    ),
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
          if (digitalProductList.isEmpty) {
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

  String _imageToList(int temp) {
    List imageList = json.decode(tempList[temp].image);
    return imageList[0];
  }

}
