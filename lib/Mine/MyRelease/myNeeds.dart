import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winter/DemandArea/demandClass.dart';
import 'package:winter/GoodsDetail/topNavigatorBar.dart';
import 'package:winter/Basic/login.dart';
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/expandableText.dart';
import 'package:winter/AdapterAndHelper/darkModeModel.dart';
//import 'package:provider/provider.dart';

class MyNeeds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyNeedsState();
}

class MyNeedsState extends State<MyNeeds> {

  //临时数据
  List listData = [
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

  List<Demand> myDemandList = new List();
  List<Demand> tempList = new List();
  Iterable<Demand> reservedList = new List();
  String userName;
  int startNum = 0;
  int _page = 1;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getMyDemandData().then((value) {
      _transferIntoLocalList();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        print("滑到了底部");
        _getMore();
      }
    });
  }

  Future _getMyDemandData() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post('http://widealpha.top:8080/shop/want/myWant',
    options: Options(headers: {'Authorization':'Bearer'+LoginPageState.token}));
    String feedback = response.data.toString();
    print(feedback);
    if (response.data['code'] == 0) {
      if (response.data['data'] == null) {
        print("no info");
        return;
      } else {
        setState(() {
          List demandJson = response.data['data'];
          myDemandList = demandJson.map((e) => Demand.fromJson(e)).toList();
          print(myDemandList);
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
          for (int i = startNum; i <= startNum + 6; i++) {
            startNum = i;
            if (i == myDemandList.length || i == startNum + 6) {
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
    if (myDemandList.isNotEmpty) {
      reservedList = myDemandList.reversed;
      print(reservedList);
      print(reservedList.length);
      for (int i = 0; i < 6; i++) {
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
      }
    }
  }

  Future<void> _getUserName() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post('http://widealpha.top:8080/shop/user/username',
        options: Options(headers: {'Authorization':'Bearer'+LoginPageState.token}));
    String feedback = response.data.toString();
    print(feedback);
    setState(() {
      userName = response.data['data'];
    });
  }

  Future<bool> showDeleteConfirmDialog() {
    return showDialog<bool>(
        context: this.context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('你要删除这个需求吗？'),
            actions:<Widget> [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('取消')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('删除'))
            ],
          );
        }
    );
  }

  Future<void> _deleteMyDemand(int wantId) async {
    Dio dio = new Dio();
    Response response = await dio.post('http://widealpha.top:8080/shop/want/deleteMyWant',
        options: Options(headers: {'Authorization':'Bearer'+LoginPageState.token}),
        queryParameters: {
          'wantId': wantId
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
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(context) {
    return myDemandList.isEmpty
        ? noDemandText()
        : myDemandListView();
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

  Widget noDemandText() {
    return Center(
      child: Text(
        "您还没有发布需求哦",
        style: TextStyle(
            color: Colors.grey,
            fontSize: 20
        ),
      ),
    );
  }

  Widget myDemandListView() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemCount: tempList.length,
        controller: _scrollController,
        //padding: EdgeInsets.symmetric(horizontal: 5),
        itemBuilder: (context, index) {
          return itemWidget2(index);
        }
      ));
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      print("refresh");
      setState(() {
        myDemandList.clear();
        tempList.clear();
        startNum = 0;
        _getMyDemandData().then((value) => {
          _transferIntoLocalList()
        });
      });
    });
    Toast.show("刷新成功", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  Widget itemWidget2(int temp) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (child) => DarkModeModel())
      ],
      child: InkWell(
          onLongPress: () async {
            bool delete = await showDeleteConfirmDialog();
            if (delete == null) {
              print('取消删除');
            } else {
              print('确认删除');
              _deleteMyDemand(tempList[temp].wantId).then((value) {
                setState(() {
                  tempList.removeAt(temp);
                });
              });
            }
          },
          child: Container(
            child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10),),
                  ),
                  shadowColor: Colors.grey,
                  elevation: 5,
                  clipBehavior: Clip.none,
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                      title: Text(userName ?? " "),
                      subtitle: ExpandbaleText(
                        text: tempList[temp].description,
                        maxLines: 5,
                      )
                  ),
                )

          )
      )
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
  }
  


}