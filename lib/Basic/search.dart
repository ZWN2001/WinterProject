import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/darkModeModel.dart';
import 'package:winter/AdapterAndHelper/expandableText.dart';
import 'package:winter/AdapterAndHelper/searchHistory.dart';
import 'package:winter/ChatArea/ChatPage.dart';
import 'package:winter/DemandArea/demandClass.dart';
import 'package:winter/GoodsDetail/commodityClass.dart';
import 'package:winter/GoodsDetail/detailPage.dart';
import 'package:winter/GoodsDetail/imageShowServer.dart';
import 'package:winter/GoodsDetail/topNavigatorBar.dart';
import 'package:winter/SharedPreference/sharedPreferenceUtil.dart';
import 'login.dart';

class SearchPageWidget extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPageWidget> {
  static final TextEditingController controller = new TextEditingController();
  bool _modelCondition = false;
  bool isCommodity=true;
  String _myModel;
  ///搜索页form文字
  static String searchStr = "";
  ///中间内容
  Widget centerContent;
  ///建议
  List<String> recommend = ['数码产品', '二手书', '食品', '生活用品', '美妆', '其他'];
  ///历史
  SearchHistory history = new SearchHistory();

  List<Demand> demandList = new List();
  List<Commodity> commodityList = new List();
  // List tempList = new List();
  Iterable reservedList = new List();
  int startNum = 0;
  int _page = 1;
  bool isLoading = false;//是否正在加载数据
  ScrollController _scrollController = ScrollController();
  ///实时搜索url
  String realTimeSearchUrl='';
  // String _headImageUrl;
  List imageList=new List();
  //单个商品
  Commodity _commodity=Commodity(0, '', '', 0, '', '', '');
  //单个需求
  Demand _demand=Demand(0, '', '', '');

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
    print('init...搜索界面历史记录');
    controller.text='';
  }


  SearchPageState() {
    ///监听搜索页form
    print('监听中');
    controller.addListener(() {
      if (controller.text.isEmpty) {
        if (mounted) {
          setState(() {
            searchStr = "";
            controller.text='';
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
        child:Column(
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
                          Navigator.of(context).pop();
                        },
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 0),
                            alignment: Alignment(0, 0),
                            decoration: new BoxDecoration(
                              color: Colors.black12,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
                    ChangeNotifierProvider<SearchHistory>(
                        create: (_) => SearchHistory(),
                        builder: (myContext, child) {
                          return IconButton(
                          iconSize: 25,
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            myContext.read<SearchHistory>().refresh();
                            setState(() {
                              history.initHistory();
                              controller.text = "";
                              centerContent=defaultDisplay();
                            });
                          });
                        }),
                    ],
                  ),
                      Container(
                        child: centerContent,
                      ),
                ],
              )
      ),
    );
  }

  ///默认显示(推荐 + 历史记录)
  Widget defaultDisplay() {
    return ChangeNotifierProvider<SearchHistory>(
        create: (_) => SearchHistory(),
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
                              ? _modelChosed()
                              : _modelUnChosed(),
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
                            myContext.read<SearchHistory>().refresh();
                            setState(() {
                              history.history=new List();
                            });
                          }),
                    ),
                  ],
                ),
                Consumer<SearchHistory>(
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

  Widget _modelChosed() {
    return Text('搜索模式：$_myModel');
  }

  Widget _modelUnChosed() {
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

    switch (_myModel) {
      case "按ID搜索商品":
        print('按ID搜索商品');
        isCommodity=true;
        realTimeSearchUrl = "http://widealpha.top:8080/shop/commodity/commodity";
        _getCommodityIDResult(widget,key,realTimeSearchUrl);
        break;
      case "按关键字搜索需求":
        print('按关键字搜索需求');
        isCommodity=false;
        realTimeSearchUrl =
        "http://widealpha.top:8080/shop/want/searchWant";
        _getKeywordResult(widget, key, realTimeSearchUrl,isCommodity);
        break;
      case "按ID搜索需求":
        print('按ID搜索需求');
        isCommodity=false;
        realTimeSearchUrl = "http://widealpha.top:8080/shop/want/want";
       _getDemandsIDResult(widget, key, realTimeSearchUrl);
        break;
      default:
        print('按关键字搜索商品');
        isCommodity=true;
        realTimeSearchUrl = "http://widealpha.top:8080/shop/commodity/searchCommodity";
        _getKeywordResult(widget, key, realTimeSearchUrl, isCommodity);
    }
  }

  //判定是否为数字
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  void _getCommodityIDResult(Widget widget,String key,String realTimeSearchUrl){
    Response response;
    if(isNumeric(key)) {
      Dio().post(realTimeSearchUrl,
          options: Options(
              headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
          queryParameters: {'commodityId': int.parse(key)}).then((value) {
        //赋值
        response = value;
        print('搜索结果：$response');
      }).whenComplete(() {
        var Data = response.data['data'];
        if (Data.isEmpty) {
          widget = nullResult();
        } else {
          widget = _commodityIDResult(Data) ;
        }
        if (mounted) {
          setState(() {
            //更新提示列表
            centerContent = widget;
          });
        }
        return widget;
      });
    }else{
      Toast.show("请输入正确的ID", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      centerContent = nullResult();
    }
  }
  void _getDemandsIDResult(Widget widget,String key,String realTimeSearchUrl){
    Response response;
    if(isNumeric(key)) {
      Dio().post(realTimeSearchUrl,
          options: Options(
              headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
          queryParameters: {'wantId': int.parse(key)}).then((value) {
        //赋值
        response = value;
        print('搜索结果：$response');
      }).whenComplete(() {
        var Data = response.data['data'];
        if (Data.isEmpty) {
          widget = nullResult();
        } else {
          widget = _needsIDresult(Data);
        }
        if (mounted) {
          setState(() {
            //更新提示列表
            centerContent = widget;
          });
        }
        return widget;
      });
    }else{
      Toast.show("请输入正确的ID", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      centerContent = nullResult();
    }
  }
  void _getKeywordResult(Widget widget,String key,String realTimeSearchUrl,bool isCommodity){
    Response response;
    Dio().post(realTimeSearchUrl,
        options: Options(
            headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
        queryParameters: {'key': key}).then((value) {
      //赋值
      response = value;
      print('搜索结果：$response');
    }).whenComplete(() {
      List Data = response.data['data'];
      if (Data.isEmpty) {
        widget = nullResult();
      } else {
        widget = isCommodity?_commodityKeywordResult(Data):_needsKeywordresult(Data);
      }
      if (mounted) {
        setState(() {
          //更新提示列表
          centerContent = widget;
        });
      }return widget;
    });
  }

   //按ID搜索商品
  Widget _commodityIDResult(var goodsData) {
    _commodity=Commodity.fromJson(goodsData);
    _IdImageToList();
    return  Expanded(
        // padding: EdgeInsets.all(5.0),
        child: ListView(
          children:<Widget> [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              child: imageList.length == 0
                  ? Center(child: Text("卖家没有上传图片"))
                  : Swiper(
                itemBuilder: swiperBuilder,
                itemCount: imageList.length,
                pagination: new SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.black54,
                      activeColor: Colors.white,
                    )
                ),
                controller: new SwiperController(),
                scrollDirection: Axis.horizontal,
                onTap: (index){},
              ),
            ),
            // Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
            //   return
                Container(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Text(_commodity.title,
                  maxLines: 3,
                  style: TextStyle(
                    // color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),),
              ),
            // }),
            Container(
              //height: 40,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Row(
                children:<Widget> [
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Text("价格：￥"),
                          Text(_commodity.price.toString(),style: TextStyle(
                              color: Colors.red,
                              fontSize: 18
                          ),)
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:<Widget> [
                          Icon(Icons.message, size: 18,),
                          RichText(
                              text: TextSpan(
                                  text: " 联系卖家",
                                  style: TextStyle(fontSize: 18, color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      LoginPageState.account == _commodity.account
                                          ? Toast.show("你怎么能和自己聊天", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM)
                                          : Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return new ChatPage(account: _commodity.account.toString());
                                      }));
                                    }//跳至聊天
                              )
                          )
                        ],
                      )),
                ],
              ),
            ),
            // Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
            //   return
                Container(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Row(
                  children:<Widget> [
                    Expanded(
                        child: Divider(
                          height: 10,
                          // color:DarkModeModel.darkMode ? Colors.white : Colors.black87,
                          //indent: 120,
                        )),
                    Expanded(child: Text("详细介绍",
                      style: TextStyle(
                        // color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,)),
                    Expanded(
                        child: Divider(
                          height: 1,
                          // color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                          //indent: 120,
                        ))
                  ],
                ),
              ),
            // }),
            // Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
            //   return
        Container(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Text(_commodity.description,style: TextStyle(
                  // color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                ),),
              ),
  // })
  ],
        ),
    );
  }

  void _IdImageToList() {
    if (_commodity.image.isNotEmpty) {
      imageList = json.decode(_commodity.image);
    } else {
      print("无图");
    }
  }

  Widget swiperBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ImageShowServerWidget(
            initialIndex: index,
            photoList: imageList,
          );
        }));
      },
      child: Image.network(
        imageList[index],
        fit: BoxFit.contain,),
    );
    /*(Image.network(
    piclist[index],
    fit: BoxFit.contain,));*/
  }
//按关键词搜索商品
  Widget _commodityKeywordResult(List goodsData) {
    print('_commodityKeywordResult');
    commodityList = goodsData.map((e) => Commodity.fromJson(e)).toList();
    // _transferIntoLocalList(commodityList);
    return Expanded(
      child: Container(
     margin: EdgeInsets.only(top: 20),
      child:GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          itemCount: commodityList.length,
          itemBuilder: (context,index){
            return Material(
              child: commodityItemWidget(index),
            );
          }),
      ),

    );
  }
  //按ID搜索需求
  Widget _needsIDresult(var needsData) {
    _demand=Demand.fromJson(needsData);
    return InkWell(
        onTap: (){
          LoginPageState.account == _demand.account
              ? Toast.show("你怎么能和自己聊天", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM)
              : Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new ChatPage(account: _demand.account.toString());
          }));
        },//TODO
        child:
        // Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
        //   return
            Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            // color: !DarkModeModel.darkMode ? Colors.white : Colors.black87,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget> [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 30),
                        height: 60,
                        child: Row (
                          children: [
                            // SizedBox(
                            //   // flex: 2,
                            //   height: 60,
                            //   width: 60,
                            //   child: ClipOval(
                            //       child:  _headImageUrl == null
                            //           ? Image.asset(
                            //         'images/defaultHeadImage.png',
                            //         color: Colors.grey,
                            //         fit: BoxFit.scaleDown,)
                            //           : Image.network(
                            //         _headImageUrl,
                            //         fit: BoxFit.cover,)
                            //   ),
                            // ),
                            Expanded(
                                // flex: 9,
                                child: ListTile(
                                  title: Text(_demand.account,
                                    style: TextStyle(
                                      // color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                                    ),),
                                  subtitle: Text("id."+_demand.wantId.toString()),
                                )
                             )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(45, 5, 5, 0),
                            child: ExpandbaleText(
                              text: _demand.description,
                              maxLines: 3,
                              // style: TextStyle(fontSize: 15, color: DarkModeModel.darkMode ? Colors.white : Colors.black87),
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
          ),
        // }),
    );
  }

  //按关键词搜索需求
  Widget _needsKeywordresult(List needsData) {
    demandList = needsData.map((e) => Demand.fromJson(e)).toList();
    // _transferIntoLocalList(demandList);
    return Expanded(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              itemCount: demandList.length,
              itemBuilder: (context, index){
                return Material(
                  child: demandItemWidget(index),
                  //color: Colors.grey,
                );
              })
    );
  }


  //将所有图片放入一个list，默认加载第一张
  String _keywordImageToList(int temp) {
    List imageList = json.decode(commodityList[temp].image);
    return imageList[0];
  }

  //每个商品的窗口
  Widget commodityItemWidget(int index) {
    return InkWell(
        onTap: (){
          Navigator.push(context,new MaterialPageRoute(builder: (context){
            return new TopNavigatorBar(commodityId: commodityList[index].commodityId);
          }));
        },//点击后进入详细页面
        child:MultiProvider(
          providers: [
            ChangeNotifierProvider<DarkModeModel>(create: (child) => DarkModeModel())
          ],
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
                            commodityList[index].image.isEmpty
                                ? Text("暂时没有图片哦", style: TextStyle(color: Colors.grey, fontSize: 10),textAlign: TextAlign.center)
                                : Image.network(_keywordImageToList(index), fit: BoxFit.cover,),
                          )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child:Text(
                            commodityList[index].title,
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
                            commodityList[index].price.toString(),
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
          })
    )
    );
  }
  
  //每个需求的窗口
  Widget demandItemWidget(int index) {
    return InkWell(
      onTap: (){
    LoginPageState.account == demandList[index].account
    ? Toast.show("你怎么能和自己聊天", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM)
        : Navigator.push(context, MaterialPageRoute(builder: (context) {
    return new ChatPage(account: demandList[index].account.toString());
    }));
    },
      child:
      // Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
      //   return
          Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          // color: !DarkModeModel.darkMode ? Colors.white : Colors.black87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget> [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 30),
                      height: 60,
                      child: Row (
                        children: [
                          // Expanded(
                          //   flex: 2,
                          //   child: ClipOval(
                          //       child: _headImageUrl == null
                          //           ? Image.asset(
                          //         'images/defaultHeadImage.png',
                          //         color: Colors.grey,
                          //         fit: BoxFit.scaleDown,)
                          //           : Image.network(
                          //         _headImageUrl,
                          //         fit: BoxFit.cover,)
                          //   ),
                          // ),
                          Expanded(
                              // flex: 9,
                              child: ListTile(
                                title: Text(demandList[index].account,
                                  style: TextStyle(
                                    // color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                                  ),),
                                subtitle: Text("id."+demandList[index].wantId.toString()),
                              )
                           )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(45, 5, 5, 0),
                          child: ExpandbaleText(
                            text: demandList[index].description,
                            maxLines: 3,
                            // style: TextStyle(fontSize: 15, color: DarkModeModel.darkMode ? Colors.white : Colors.black87),
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
        ),
      // }),
    );
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
