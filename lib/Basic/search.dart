import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winter/SharedPreference/sharedPreferenceUtil.dart';
import 'dart:async';
import 'login.dart';

class SearchPage extends StatelessWidget{
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

class SearchPageState extends State<SearchPageWidget>{

  static final TextEditingController controller = new TextEditingController();
  bool _modelCondition=false;
  String _myModel;
  bool _isKeyword;
  ///搜索页form文字
  static String searchStr = "";
  ///中间内容
  Widget centerContent;
  ///建议
  static List<String> recommend = ['数码产品', '二手书', '食品', '生活用品', '美妆', '其他'];
  ///历史 暂时使用本地默认数据
  static List<String> _history = List() ;

  Future<void> _getHistories() async{
    if(_history!=null) {
      _history.clear();
    }
    _history.addAll(await SharedPreferenceUtil.getHistories());
  }

  //初始化
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _getHistories().then((value) {
      setState(() {
        centerContent=defaultDisplay();
      });
    });
    print('init...搜索界面历史记录');
  }

  SearchPageState() {
    ///监听搜索页form
    print('监听中');
    controller.addListener(() {
      if (controller.text.isEmpty) {
        if(mounted) {
        setState(() {
          searchStr = "";
          //默认显示
          centerContent = defaultDisplay();
          //显示历史记录
        });
      }
      }
      else {
        if(mounted) {
          setState(() {
            //动态搜索
            searchStr = controller.text;
            SharedPreferenceUtil.saveHistory(searchStr);
               centerContent=realTimeSearch(searchStr);
          });
        }
      }
    });
  }

  ///默认显示(推荐 + 历史记录)
   Widget defaultDisplay(){
    return Container(
      padding: const EdgeInsets.only(left: 10,right: 15),
      child: Column(
        children: [
          FlatButton(
            child:Row(
              children: [
                Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child:Row(
                        children: [
                          Icon(Icons.youtube_searched_for),
                          Text(
                              '搜索模式',
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                        ],
                      )
                    )
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 20, 10),
                  child: _modelCondition?_modelChoosed():_modelUnChoosed(),
                )
              ],
            ),
            onPressed: (){
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
                              _modelCondition=true;
                              _myModel = '按关键字搜索商品';
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          title: Text("按ID搜索商品"),
                          onTap: () {
                            setState(() {
                              _modelCondition=true;
                              _myModel = '按ID搜索商品';
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          title: Text("按关键字搜索需求"),
                          onTap: () {
                            setState(() {
                              _modelCondition=true;
                              _myModel = '按关键字搜索需求';
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          title: Text("按ID搜索需求"),
                          onTap: () {
                            setState(() {
                              _modelCondition=true;
                              _myModel = '按ID搜索需求';
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    );
                  });
            }
          ),

            Row(
              children: [
                Expanded(
                  child:Text(
                    "历史记录：",
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                Container(
                  child:  IconButton(
                      icon: Image(
                        image: AssetImage("images/myClear.png"),
                      ),
                      onPressed: () {
                        //TODO
                        SharedPreferenceUtil.delHistories();
                        setState(() {
                          initState();
                        });
                      }
                  ),
                ),
              ],
            ),

                    Container(
                      alignment: AlignmentDirectional.topStart,
                      child: Wrap(
                        spacing: 10,
                        children: _history==null?_buildData(recommend):_buildData(_history),
                      ),
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
                  child:   Wrap(
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
  }
  Widget _modelChoosed(){
    return Text('搜索模式：$_myModel');
}
  Widget _modelUnChoosed(){
    return Text('搜索模式：按关键字搜索商品');
  }

  ///默认显示内容
  static List<Widget> _buildData(List<String> items){
      return items.map((item) {
        return InkWell(
          child: Chip(
              label: Text(item),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
          onTap: () {
            //更新到搜索框
            controller.text = item;
          },
        );
      }).toList();
  }

  ///实时搜索结果
  static List list  = new List();
  ///实时搜索url
  String realTimeSearchUrl;

  ///实时搜索列表
  Widget realTimeSearch(String key) {
    switch (_myModel){
      case "按ID搜索商品":
        _isKeyword=false;
      realTimeSearchUrl = "http://widealpha.top:8080/shop/commodity/commodity";
      break;
      case "按关键字搜索需求":
        _isKeyword=true;
      realTimeSearchUrl = "http://widealpha.top:8080/shop/want/searchCommodity";
      break;
      case "按ID搜索需求":
        _isKeyword=false;
        realTimeSearchUrl = "http://widealpha.top:8080/shop/want/commodity";
        break;
      default:
        _isKeyword=true;
        realTimeSearchUrl ="http://widealpha.top:8080/shop/commodity/searchCommodity";
    }
    Widget widget = Expanded(
      child: Center(
        child: Text(
            "搜索中...",
          style: TextStyle(
            fontSize: 20
          ),
        ),
      ),
    );

    Response response;
   _isKeyword? Dio().post(
        realTimeSearchUrl,
        options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),
        queryParameters: {
        'key':key
        }
    ): Dio().post(
       realTimeSearchUrl,
       options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),
       queryParameters: {
         'commodityId':int.parse(key)
       }
   ).then((value){
      //赋值
      response= value;
      print(response);
          }).whenComplete((){
      if(response.data['data']==null){
        widget=nullResult();
      }else {
        if(_isKeyword){
          widget=_keywordResult(response);
        }else{
          widget=_IDresult(response);
        }
      }
      if(mounted) {
        setState(() {
          //更新提示列表
          centerContent = widget;
        });
      }
    });
    // return widget;
  }
  void _getRealtimeResult()async{
    //dio请求
    Response response = await Dio().post(
        realTimeSearchUrl,
        options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),
        queryParameters: {

        }
    );
  }
  Widget _IDresult(Response response){
    Map goodsData=response.data['data'];
    return Container(
      margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: Card(
        child: Text('id'),
      ),
    );
  }
  Widget _keywordResult(Response response){
    Map goodsData=response.data['data'];
    return Container(
        margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
    child: Card(
      child: Text('keyword'),
    ),
    );
  }
  Widget nullResult(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/nullResult.png'),
          Text(
            '没有找到相关信息呢.......',
            style: TextStyle(
              fontSize: 20
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: 40),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      //iconSize: 30,
                      iconSize: 25,
                      icon: Icon(Icons.arrow_back),
                      onPressed: (){
                        //回到原来页面
                        controller.clear();
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                        child:   Container(
                          margin: EdgeInsets.only(left: 0),
                          //设置 child 居中
                          alignment: Alignment(0, 0),
                          //边框设置
                          decoration: new BoxDecoration(
                            //背景
                            color: Colors.black12,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            //设置四周边框
                            border: new Border.all(width: 1, color: Colors.white12),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: TextFormField(
                              autofocus: true,
                              style: TextStyle(
                                fontSize: 20
                              ),
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
                          )
                        ),
                    ),

                    //清空按钮
                    IconButton(
                        iconSize:25,
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            controller.text = "";
                          });
                        }
                    )
                  ],
                ),
                centerContent,
              ],
            ),
          ),
    );

  }

}