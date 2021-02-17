import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winter/AdapterAndHelper/darkModeModel.dart';
import 'package:winter/AdapterAndHelper/searchHistory.dart';
import 'package:winter/GoodsDetail/commodityClass.dart';
import 'package:winter/GoodsDetail/topNavigatorBar.dart';
import 'package:winter/SharedPreference/sharedPreferenceUtil.dart';
import 'login.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchPageWidget(),
    );
  }
}

class SearchPageWidget extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPageWidget> {
  static final TextEditingController controller = new TextEditingController();
  bool _modelCondition = false;
  String _myModel;
  bool _isKeyword;

  ///搜索页form文字
  static String searchStr = "";
  ///中间内容
  Widget centerContent;
  ///建议
  List<String> recommend = ['数码产品', '二手书', '食品', '生活用品', '美妆', '其他'];
  ///历史
  searchHistory history = new searchHistory();

  List<Commodity> commodityList = new List();
  List<Commodity> tempList = new List();
  Iterable<Commodity> reservedList = new List();
  int startNum = 0;
  int _page = 1;
  bool isLoading = false;//是否正在加载数据
  ScrollController _scrollController = ScrollController();

  //初始化
  @override
  void initState() {
    super.initState();
    history.initHistory();
        // .then((value) {
      setState(() {
        centerContent = defaultDisplay();
      // });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("滑到了最底部");
        _getMore();
      }
    });
    print('init...搜索界面历史记录');
  }

  SearchPageState() {
    ///监听搜索页form
    print('监听中');
    controller.addListener(() {
      if (controller.text.isEmpty) {
        if (mounted) {
          setState(() {
            searchStr = "";
            //默认显示
            centerContent = defaultDisplay();
            //显示历史记录
          });
        }
      } else {
        if (mounted) {
          setState(() {
            //动态搜索
            searchStr = controller.text;
            SharedPreferenceUtil.saveHistory(searchStr);
            centerContent = realTimeSearch(searchStr);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: ChangeNotifierProvider<searchHistory>(
            create: (_) => searchHistory(),
            //可以使用child进行渲染UI，用法可以查看第一篇文章https://blog.csdn.net/Mr_Tony/article/details/111414413
            builder: (myContext, child) {
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        //iconSize: 30,
                        iconSize: 25,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          //回到原来页面
                          controller.clear();
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 0),
                            //设置 child 居中
                            alignment: Alignment(0, 0),
                            //边框设置
                            decoration: new BoxDecoration(
                              //背景
                              color: Colors.black12,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              //设置四周边框
                              border: new Border.all(
                                  width: 1, color: Colors.white12),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: TextFormField(
                                autofocus: true,
                                style: TextStyle(fontSize: 20),
                                controller: controller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '输入搜索内容...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            )),
                      ),

                      //清空按钮
                      IconButton(
                          iconSize: 25,
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            myContext.read<searchHistory>().refresh();
                            setState(() {
                              history.initHistory();
                              controller.text = "";
                            });
                          })
                    ],
                  ),
                  Container(
                    child:  centerContent,
                  ),
                ],
              );
            }),
      ),
    );
  }

  ///默认显示(推荐 + 历史记录)
  Widget defaultDisplay() {
    return ChangeNotifierProvider<searchHistory>(
        create: (_) => searchHistory(),
        //可以使用child进行渲染UI，用法可以查看第一篇文章https://blog.csdn.net/Mr_Tony/article/details/111414413
        builder: (myContext, child) {
          return Container(
            padding: const EdgeInsets.only(left: 10, right: 15),
            child: Column(
              children: [
                FlatButton(
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.youtube_searched_for),
                                    Text(
                                      '    搜索模式',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ))),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 20, 10),
                          child: _modelCondition
                              ? _modelChoosed()
                              : _modelUnChoosed(),
                        )
                      ],
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text("按关键字搜索商品"),
                                  onTap: () {
                                    setState(() {
                                      _modelCondition = true;
                                      _myModel = '按关键字搜索商品';
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                ListTile(
                                  title: Text("按ID搜索商品"),
                                  onTap: () {
                                    setState(() {
                                      _modelCondition = true;
                                      _myModel = '按ID搜索商品';
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                ListTile(
                                  title: Text("按关键字搜索需求"),
                                  onTap: () {
                                    setState(() {
                                      _modelCondition = true;
                                      _myModel = '按关键字搜索需求';
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                ListTile(
                                  title: Text("按ID搜索需求"),
                                  onTap: () {
                                    setState(() {
                                      _modelCondition = true;
                                      _myModel = '按ID搜索需求';
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ],
                            );
                          });
                    }),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "历史记录：",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      child: IconButton(
                          icon: Image(
                            image: AssetImage("images/myClear.png"),
                          ),
                          onPressed: () {
                            //TODO
                            SharedPreferenceUtil.delHistories();
                            myContext.read<searchHistory>().refresh();
                            setState(() {
                              history.history=new List();
                            });
                          }),
                    ),
                  ],
                ),
                Consumer<searchHistory>(
                  builder: (_, searchHistory, child) {
                    //最后一个参数取决于父组件的child值，该值可以决定外部不用修改
                    return Container(
                      alignment: AlignmentDirectional.topStart,
                      child: Wrap(
                        spacing: 10,
                        children: _buildData(history.history) ??
                            _buildData(recommend),
                      ),
                    );
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "推荐：",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Wrap(
                          spacing: 10,
                          children: _buildData(recommend),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _modelChoosed() {
    return Text('搜索模式：$_myModel');
  }

  Widget _modelUnChoosed() {
    return Text('搜索模式：按关键字搜索商品');
  }

  ///默认显示内容
  static List<Widget> _buildData(List<String> items) {
    return items.map((item) {
      return InkWell(
        child: Chip(
            label: Text(item),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onTap: () {
          //更新到搜索框
          controller.text = item;
        },
      );
    }).toList();
  }

  ///实时搜索url
  String realTimeSearchUrl;

  ///实时搜索列表
  Widget realTimeSearch(String key) {
    Widget widget = Expanded(
      child: Center(
        child: Text(
          "搜索中...",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );

    Response response;

    switch (_myModel) {
      case "按ID搜索商品":
        _isKeyword = false;
        print('按ID搜索商品');
        realTimeSearchUrl =
        "http://widealpha.top:8080/shop/commodity/commodity";
        Dio().post(realTimeSearchUrl,
            options: Options(
                headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
            queryParameters: {'commodityId': int.parse(key)}).then((value) {
          //赋值
          response = value;
          print('搜索结果：$response');
        }).whenComplete(() {
          List goodsData = response.data['data'];
          if (goodsData.isEmpty) {
            widget = nullResult();
          } else {
            widget = _commodityIDresult(goodsData);
          }
          if (mounted) {
            setState(() {
              //更新提示列表
              centerContent = widget;
            });
          }
        });
        break;
      case "按关键字搜索需求":
        _isKeyword = true;
        print('按关键字搜索需求');
        realTimeSearchUrl =
        "http://widealpha.top:8080/shop/want/searchCommodity";
        break;
      case "按ID搜索需求":
        _isKeyword = false;
        print('按ID搜索需求');
        realTimeSearchUrl = "http://widealpha.top:8080/shop/want/commodity";
        break;
      default:
        _isKeyword = true;
        print('按关键字搜索商品');
        realTimeSearchUrl =
        "http://widealpha.top:8080/shop/commodity/searchCommodity";
        Dio().post(realTimeSearchUrl,
            options: Options(
                headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
            queryParameters: {'key': key}).then((value) {
          response = value;
          print('搜索结果：$response');
          print('商品结果：${response.data['data']}');
        }).whenComplete(() {
          List goodsData = response.data['data'];
          if ( goodsData.isEmpty) {
            widget = nullResult();
          } else {
            widget = _commoditykeywordResult(goodsData);
          }
          if (mounted) {
            setState(() {
              //更新提示列表
              centerContent = widget;
            });
          }
        });
    }

  //   _isKeyword
  //       ? Dio().post(realTimeSearchUrl,
  //           options: Options(
  //               headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
  //           queryParameters: {'key': key}).then((value) {
  //     response = value;
  //     print('搜索结果：$response');
  //     print('商品结果：${response.data['data']}');
  //         }).whenComplete(() {
  //     List goodsData = response.data['data'];
  //     if ( goodsData.isEmpty) {
  //       widget = nullResult();
  //     } else {
  //         widget = _keywordResult(goodsData);
  //     }
  //     if (mounted) {
  //       setState(() {
  //         //更新提示列表
  //         centerContent = widget;
  //       });
  //     }
  //   })
  //       : Dio().post(realTimeSearchUrl,
  //           options: Options(
  //               headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
  //           queryParameters: {'commodityId': int.parse(key)}).then((value) {
  //           //赋值
  //           response = value;
  //           print('搜索结果：$response');
  //         }).whenComplete(() {
  //         List goodsData = response.data['data'];
  //           if (goodsData.isEmpty) {
  //             widget = nullResult();
  //           } else {
  //               widget = _IDresult(goodsData);
  //           }
  //           if (mounted) {
  //             setState(() {
  //               //更新提示列表
  //               centerContent = widget;
  //             });
  //           }
  //         });
  //   // return widget;
  }

  Widget _commodityIDresult(List goodsData) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: Card(
          child: Text('id'),
        ),
      ),
    );
  }

  Widget _commoditykeywordResult(List goodsData) {
    commodityList = goodsData.map((e) => Commodity.fromJson(e)).toList();
    return Expanded(
        child: Container(
          child:    GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 5),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              itemCount: tempList.length,
              itemBuilder: (context,index){
                return Material(
                  child: itemWidget(index),
                );
              }),
        )
    );

  }

  // _transferIntoLocalList() {
  //   if(LoginPageState.logged) {
  //     if (commodityList != null) {
  //       reservedList = commodityList.reversed;//确保时间顺序展示
  //       print(reservedList);
  //       print(reservedList.length);
  //       //每次加载10条商品信息
  //       for (int i = 0; i < 10; i++) {
  //         startNum = i+1;
  //         if (reservedList.length == 1){
  //           tempList.insert(0, reservedList.elementAt(0));
  //           startNum = 1;
  //           return;
  //         }
  //         if (i == reservedList.length - 1){
  //           print("没有更多数据");
  //           //startNum = i;
  //           return;
  //         }
  //         //tempList[i] = reservedList.elementAt(i);
  //         tempList.insert(i, reservedList.elementAt(i));
  //         print(tempList[i].image);
  //       }
  //     }
  //   }
  // }
  //将所有图片放入一个list，默认加载第一张
  String _imageToList(int temp) {
    List imageList = json.decode(tempList[temp].image);
    return imageList[0];
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
            if (i == commodityList.length || i == startNum+10) {
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

  Widget nullResult() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/nullResult.png'),
          Text(
            '没有找到相关信息呢.......',
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
