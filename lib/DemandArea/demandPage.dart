import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart'hide BuildContext;
import 'package:winter/AdapterAndHelper/buildRoteFloatingBtn.dart';
import 'package:winter/AdapterAndHelper/expandableText.dart';
import 'package:winter/AdapterAndHelper/getUsername.dart';
import 'package:winter/AdapterAndHelper/getOthersUsername.dart';
import 'package:winter/DemandArea/demandClass.dart';
import 'package:winter/Basic/login.dart';
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/headImage.dart';
import 'package:winter/AdapterAndHelper/getOthersHeadImage.dart';


class DemandPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DemandPageState();
}

class DemandPageState extends State<DemandPage> {

  List ListData = [
    {
      "headImage": "https://www.itying.com/images/flutter/1.png",
      "userName": "曹操",
      "demand": "东临碣石，以观沧海。\n水何澹澹，山岛竦峙。\n树木丛生，百草丰茂。\n秋风萧瑟，洪波涌起。\n日月之行，若出其中；\n星汉灿烂，若出其里。\n幸甚至哉，歌以咏志。\n"
  },
    {
      "headImage": "https://www.itying.com/images/flutter/1.png",
      "userName": "操曹",
      "demand": "东临碣石，以观沧海。\n水何澹澹，山岛竦峙。\n树木丛生，百草丰茂。\n秋风萧瑟，洪波涌起。\n日月之行，若出其中；\n星汉灿烂，若出其里。\n幸甚至哉，歌以咏志。\n"
    }
  ];

  //好看的加载动画
  /*Key key;
  final LinkHeaderNotifier linkNotifier = LinkHeaderNotifier();*/
  
  List<Demand> demandList = new List();
  List<Demand> tempList = new List();
  Iterable<Demand> reservedList = new List();
  String _headImageUrl;
  List<String> headImageList = new List();
  //String userName;
  int startNum = 0;
  int _page = 1;
  int itemLength;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  Widget centerContent;
  Timer _timer;
  
  @override
  void initState() {
    super.initState();
    centerContent = _loadingText();
    /*getUserName.getUsername(context).then((value) {
      print(value);
      userName = value;
    });*/
    _getDemandData().then((value) async {
      _transferIntoLocalList();
      itemLength = tempList.length;
      await _getHeadImageList(tempList).then((value) {
        print('headImageList.........................');
        print(headImageList.toString());
        if (demandList.isEmpty) {
          setState(() {
            centerContent = noDemandText();
          });
        } else {
          setState(() {
            centerContent = demandListView();
          });
        }
      });
    }).then((value) async {

        //sleep(Duration(seconds: 1));
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("滑到了最底部");
        _getMore();
      }
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        print('setState');
        print(headImageList);
      });
    });
  }
  
  Future _getDemandData() async {
    if (LoginPageState.logged) {
      Response response;
      Dio dio = new Dio();
      response = await dio.post('http://widealpha.top:8080/shop/want/allWant',
          options: Options(headers: {'Authorization': 'Bearer' + LoginPageState.token}));
      String feedback = response.data.toString();
      print(feedback);
      if (response.data['code'] == 0) {
        if (response.data['data'] == null) {
          print("no info");
          return;
        } else {
          setState(() {
            List demandJson = response.data['data'];
            demandList = demandJson.map((e) => Demand.fromJson(e)).toList();
            print(demandList);
          });
        }
      }
    }

  }

  _transferIntoLocalList() {
    if (LoginPageState.logged) {
      if (demandList.isNotEmpty) {
        reservedList = demandList.reversed;
        print(reservedList);
        print(reservedList.length);
        for (int i = 0; i < 8; i++) {
          startNum = i+1;
          if (reservedList.length == 1) {
            tempList.insert(0, reservedList.elementAt(0));
            startNum = 1;
            return;
          }
          if (i == reservedList.length) {
            startNum = i;
            print("没有更多数据");
            return;
          }
          tempList.insert(i, reservedList.elementAt(i));
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
          for (int i = startNum; i <= startNum+8; i++) {
            print('i');
            print(i);
            startNum = i;
            if(i > reservedList.length){
              print('超长');
              return;
            }
            if (i == demandList.length || i == startNum+8) {
              print("没有更多数据了");
              isLoading = false;
              return;
            }
            tempList.insert(i, reservedList.elementAt(i));
          }
          _page++;
          isLoading = false;
          print(_page);
        });
      }).whenComplete(() {
        itemLength = tempList.length;
        _getHeadImageList(tempList);
        setState(() {
          centerContent = demandListView();
          print('change');
        });
      });
    }
  }

  Future<void> _getHeadImageList(List<Demand> demandList) async {
    print('demandList准备');
    print(demandList);
    demandList.forEach((element) {
      if (LoginPageState.account == element.account) {
        HeadImage.getHeadImage(context).then((value) {
            setState(() {
              print(value);
              print('mine');
              headImageList.add(value);
              setState(() {
              });
            });
        });
      } else {
         getOthersHeadImages.getOthersHeadImage(context, element.account).then((value)  {
          setState(() {
            print('not mine');
            print(value);
            headImageList.add(value);
            setState(() {
            });
          });
        });
      }
    });
    print('获取头像成功');
    print(headImageList);
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('查看需求'),
      ),
      body:Stack(
        children: [
          centerContent,
          buildRoteFloatingBtn(),
        ],
      ),
    );
  }

  Widget noDemandText() {
    return Center(
      child: Text(
        "暂时没有发布需求",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20
        ),
      ),
    );
  }

  Widget demandListView() {
    return EasyRefresh(
        header: DeliveryHeader(),
        firstRefresh: false,//默认加载
        onRefresh: () async {
          print("下拉刷新-----");
          _onRefresh();
        },
        onLoad: () async {
          print("上拉加载-----");
          _getMore();
        },
        child:  ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          itemCount: tempList.length,
          itemBuilder: (context, index){
            return Material(
              child: itemWidget(index),
              //color: Colors.grey,
            );
          })
    );
  }
  Widget _loadingText() {
    return  Center(
      child: LoadingBumpingLine.circle(
        size: 50,
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      print("refresh");
      setState(() {
        demandList.clear();
        tempList.clear();
        headImageList.clear();
        startNum = 0;
        _getDemandData().then((value) {
          _transferIntoLocalList();
        }).whenComplete(() {
          itemLength = tempList.length;
          _getHeadImageList(tempList);
          if (demandList.isEmpty) {
            setState(() {
              centerContent = noDemandText();
            });
          } else {
            setState(() {
              centerContent = demandListView();
            });
          }
        });
      });
    });
    Toast.show("刷新成功", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }


  Widget itemWidget(int index) {
    return InkWell(
      onTap: (){},
      child: Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
        return Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          color: !DarkModeModel.darkMode ? Colors.white : Colors.black87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget> [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      child: Row (
                        children: [
                          SizedBox(
                            // flex: 2,
                            height: 60,
                            width: 60,
                            child: ClipOval(
                              child: headImageList.isEmpty || headImageList[index] == null
                                  ? Image.asset(
                                'images/defaultHeadImage.png',
                                color: Colors.grey,
                                fit: BoxFit.scaleDown,)
                                  : Image.network(
                                headImageList[index],
                                fit: BoxFit.cover,)
                            ),
                          ),
                          Expanded(
                              // flex: 9,
                              child: ListTile(
                                title: Text(tempList[index].account,
                                style: TextStyle(
                                  color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                                ),),
                                subtitle: Text("id."+tempList[index].wantId.toString()),
                              )
                             /* Text(
                                tempList[index].account,
                                style: TextStyle(
                                  color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                                  //color: Colors.white,
                                  fontSize: 17,
                                ),
                              )*/)
                        ],
                      ),
                    ),
                    /*child: ClipOval(
                      child: Image.network(ListData[index]["headImage"],
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                      ),
                    ),*/
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(55, 5, 5, 0),
                          child: ExpandbaleText(
                            text: tempList[index].description,
                            maxLines: 3,
                            style: TextStyle(fontSize: 15, color: DarkModeModel.darkMode ? Colors.white : Colors.black87),
                          )
                      ))
                ],
              ),
              Divider(
                color: Colors.grey,
                indent: 40,
              )
            ],
          ),
        );
      }),
    );

  }

}

class _MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTRB(0, 0, 45, 45);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}