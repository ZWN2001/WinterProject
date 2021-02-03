import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winter/SharedPreference/sharedPreferenceUtil.dart';
import '../AdapterAndHelper/httpUtil.dart';
import 'dart:async';

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

  ///建议
  static List<String> recommend = ['数码产品', '二手书', '食品', '生活用品', '美妆', '其他'];
  ///历史 暂时使用本地默认数据
  static List<String> _history = List() ;

  void _getHistories() async{
    if(_history!=null) {
      _history.clear();
    }
    _history.addAll(await SharedPreferenceUtil.getHistories());
  }

  //初始化
  @override
  void initState() {
    // TODO: implement initState
    _getHistories();
    setState(() {
      centerContent=defaultDisplay();
    });
    print('init...搜索界面历史记录');
    super.initState();
  }

  ///搜索页form文字
  static String searchStr = "";
  ///中间内容
  Widget centerContent;

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
      } else {
        if(mounted) {
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

  ///默认显示(推荐 + 历史记录)
   Widget defaultDisplay(){
    return Container(
      padding: const EdgeInsets.only(left: 10,right: 15),
      child: Column(
        children: [
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
                          SharedPreferenceUtil.delHistories();
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
  String realTimeSearchUrl = "http://192.168.0.121:8091/article/test/";
  ///参数
  String paramStr = "qwe";


  ///实时搜索列表
  Widget realTimeSearch(String key){
    //http请求
    Future future = get(realTimeSearchUrl, paramStr);
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
    future.then((value){
      //赋值
      list = value;
    }).whenComplete((){
      widget = Container(
          child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (c, i) {
              return Container(
                child: Row(
                  children: <Widget>[
                    //图标
                    Container(
                      padding: const EdgeInsets.only(top: 5, left: 25, bottom: 5.0,),
                      child: Icon(
                        Icons.search,
                        color: Colors.black12,
                        size: 25.0,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 25,
                        bottom: 5.0,
                      ),
                      child: Text(
                        i == 0 ? key : list[i],
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1.0, color: Colors.black12),
            itemCount: list == null ? 0 : list.length,
          )
      );
      if(mounted) {
        setState(() {
          //更新提示列表
          centerContent = widget;
        });
      }
    });
    return widget;
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