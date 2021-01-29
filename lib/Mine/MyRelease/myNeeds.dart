import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winter/GoodsDetail/topNavigatorBar.dart';

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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
        });
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