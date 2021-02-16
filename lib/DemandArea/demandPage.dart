import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart'hide BuildContext;
import 'package:winter/AdapterAndHelper/buildRoteFloatingBtn.dart';
import 'package:winter/AdapterAndHelper/expandableText.dart';
import 'package:winter/DemandArea/demandClass.dart';
import 'package:winter/Basic/login.dart';
import 'package:toast/toast.dart';


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
  
  List<Demand> demandList = new List();
  List<Demand> tempList = new List();
  Iterable<Demand> reservedList = new List();
  int startNum = 0;
  int _page = 1;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDemandData().then((value) {
      _transferIntoLocalList();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("滑到了最底部");
        _getMore();
      }
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
          if (i == reservedList.length-1) {
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
            startNum = i;
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
      });
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
    return Scaffold(
      appBar: AppBar(
        title: Text('查看需求'),
      ),
      body:Stack(
        children: [
          demandList.length == 0
          ? noDemandText()
          : demandListView(),
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
    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          itemCount: ListData.length,
          itemBuilder: (context, index){
            return Material(
              child: itemWidget(index),
              //color: Colors.grey,
            );
          })
    );
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      print("refresh");
      setState(() {
        demandList.clear();
        tempList.clear();
        startNum = 0;
        _getDemandData().then((value) {
          _transferIntoLocalList();
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
                          Expanded(
                            flex: 1,
                            child: ClipOval(
                              clipper: _MyClipper(),
                              child: Image.network(ListData[index]["headImage"],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: Text(
                                ListData[index]["userName"],
                                style: TextStyle(
                                  color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                                  //color: Colors.white,
                                  fontSize: 17,
                                ),
                              ))
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
                            text: ListData[index]["demand"],
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