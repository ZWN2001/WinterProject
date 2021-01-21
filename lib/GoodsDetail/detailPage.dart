import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import './imageShowServer.dart';

class DetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: ListView(
        children:<Widget> [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: Swiper(
              itemBuilder: swiperBuilder,
              itemCount: 6,
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
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Text("商品简介(简单介绍有什么）,商品简介(简单介绍有什么）,商品简介(简单介绍有什么）【最多三行】",
              maxLines: 3,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),),
          ),
          Container(
            //height: 40,
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Row(
              children:<Widget> [
                Expanded(
                  flex: 1,
                    child: Row(
                      children: [
                        Text("价格："),
                        Text('￥100000000000000',style: TextStyle(
                          color: Colors.red,
                          fontSize: 18
                        ),)
                      ],
                    )),
                /*Expanded(
                  flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:<Widget> [
                        Text("发布人："),
                        ClipOval(
                          child: Image.network(
                              "https://www.itying.com/images/flutter/7.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text("发布人的用户名")
                      ],
                    )),*/
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Row(
              children:<Widget> [
                Expanded(
                    child: Divider(
                      height: 10,
                      color: Colors.white,
                      //indent: 120,
                    )),
                Expanded(child: Text("详细介绍",
                  style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,)),
                Expanded(
                    child: Divider(
                      height: 1,
                      color: Colors.white,
                      //indent: 120,
                    ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Text("详细介绍自己要卖什么，为什么卖，产品质量怎么样之类的"),
          )
        ],
      ),
    );
  }
}

List<String> picList = [
  "https://www.itying.com/images/flutter/1.png",
  "https://www.itying.com/images/flutter/2.png",
  "https://www.itying.com/images/flutter/3.png",
  "https://www.itying.com/images/flutter/4.png",
  "https://www.itying.com/images/flutter/5.png",
  "https://www.itying.com/images/flutter/6.png",
];


Widget swiperBuilder(BuildContext context, int index) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ImageShowServerWidget(
          initialIndex: index,
          photoList: picList,
        );
      }));
    },
    child: Image.network(
      picList[index],
      fit: BoxFit.contain,),
  );
  /*(Image.network(
    piclist[index],
    fit: BoxFit.contain,));*/
}