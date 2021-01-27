import 'package:flutter/material.dart';
import 'AdapterAndHelper/httpUtil.dart';
import 'dart:async';

class SearchPageWidget extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPageWidget>{

  static final TextEditingController controller = new TextEditingController();

  ///搜索页form文字
  static String searchStr = "";

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
            centerContent = realTimeSearch(searchStr);
          });
        }
      }
    });
  }

  ///建议
  static List<String> recommend = ['java', 'c/c++', 'mysql', 'redis', 'html', 'golang', 'python', '卧槽', '666666'
  ];
  ///历史 暂时使用本地默认数据
  static List<String> history = ['李四','网吧','啊啊','22','33','44','55','66','77','88'];


  ///中间内容
  Widget centerContent = defaultDisplay();

  ///默认显示(推荐 + 历史记录)
  static Widget defaultDisplay(){
    return Container(
      padding: const EdgeInsets.only(left: 15,right: 15),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.bottomStart,
                            child:Text(
                              "历史记录：",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),

                          Align(
                            alignment:AlignmentDirectional.topEnd,
                            child:  IconButton(
                              padding: EdgeInsets.all(0),
                                icon: Image(
                                  image: AssetImage("images/myClear.png"),
                                ),
                                onPressed: () {

                                }
                            ),
                          ),
                        ],
                      ),
                    Container(
                      child: Wrap(
                        spacing: 10,
                        children: defaultData(history),
                      ),
                    ),
                  ],
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
                    children: defaultData(recommend),
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
  static List<Widget> defaultData(List<String> items){
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
    Widget widget = Container(child: Text("搜索中..."),);
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
      setState(() {
        //更新提示列表
        centerContent = widget;
      });
    });
    return widget;
  }


  @override
  Widget build(BuildContext context) {
    //屏幕宽度
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return  Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: 40),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      //iconSize: 30,
                      iconSize: width * 1/15,
                      icon: Icon(Icons.arrow_back),
                      onPressed: (){
                        //回到原来页面
                        controller.clear();
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 0),
                      //设置 child 居中
                      alignment: Alignment(0, 0),
                      height: width * 1/9,
                      width: width*3/4,
                      //边框设置
                      decoration: new BoxDecoration(
                        //背景
                        color: Colors.black12,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        //设置四周边框
                        border: new Border.all(width: 1, color: Colors.white12),
                      ),
                      child:  TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5),
                          border: InputBorder.none,
                          hintText: '输入搜索内容...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    //清空按钮
                    IconButton(
                        iconSize: width*1/15,
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