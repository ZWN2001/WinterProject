import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:winter/ChatArea/ChatPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import './imageShowServer.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart';
import 'commodityClass.dart';
import 'package:winter/Basic/login.dart';

class DetailPage extends StatefulWidget {
  DetailPage({this.commodityId});
  final int commodityId;
  @override
  State<StatefulWidget> createState() => DetailPageState(commodityId: this.commodityId);
}

class DetailPageState extends State<DetailPage> {
  
  DetailPageState({this.commodityId});
  final int commodityId;
  String price = " ";
  String title = " ";
  String description = " ";
  Commodity thisCommodity;
  List imageList = [];
  int imageListLength = 1;

  @override
  void initState() {
    super.initState();
    _getDetailData().then((value) {
      _imageToList();
    });
  }

  Future _getDetailData() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post('http://widealpha.top:8080/shop/commodity/commodity',
    queryParameters: {'commodityId': commodityId},
    options: Options(headers: {'Authorization': 'Bearer'+LoginPageState.token}));
    String feedback = response.data.toString();
    print(feedback);
    if (response.data['code'] == 0) {
      if (response.data['data'] == null) {
        print("no info");
        return;
      } else {
        setState(() {
          thisCommodity = new Commodity(
              response.data['data']['commodityId'],
              response.data['data']['title'],
              response.data['data']['description'],
              response.data['data']['price'],
              response.data['data']['category'],
              response.data['data']['image'],
              response.data['data']['account']);
          print(thisCommodity.account);
        });
        price = thisCommodity.price.toString();
        title = thisCommodity.title;
        description = thisCommodity.description;
      }
    }
  }

  void _imageToList() {
    if (thisCommodity.image.isNotEmpty) {
      imageList = json.decode(thisCommodity.image);
      imageListLength = imageList.length;
      print('有图');
    } else {
      print("无图");
    }
  }
  
  
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(5.0),
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
          Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
             return Container(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Text(title,
                         maxLines: 3,
                         style: TextStyle(
                           color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                           fontSize: 16,
                          ),),
                        );
          }),
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
                        Text(price,style: TextStyle(
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
                                LoginPageState.account == thisCommodity.account
                                    ? Toast.show("你怎么能和自己聊天", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM)
                                    : Navigator.push(context, MaterialPageRoute(builder: (context) {
                                       return new ChatPage(account: thisCommodity.account.toString());
                                    }));
                                }//跳至聊天
                            )
                        )
                      ],
                    )),
              ],
            ),
          ),
          Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
            return Container(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Row(
                children:<Widget> [
                  Expanded(
                      child: Divider(
                        height: 10,
                        color:DarkModeModel.darkMode ? Colors.white : Colors.black87,
            //indent: 120,
            )),
                  Expanded(child: Text("详细介绍",
                    style: TextStyle(
                      color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
            ),
                    textAlign: TextAlign.center,)),
                  Expanded(
                      child: Divider(
                        height: 1,
                        color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
            //indent: 120,
            ))
            ],
            ),
    );
          }),
         Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
            return Container(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Text(description,style: TextStyle(
                color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
              ),),
          );}
         )],
      ),
    );
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
      child: imageList.length == 0
      ? Text("wutu")
      :  Image.network(
        imageList[index],
        fit: BoxFit.contain,),

    );
    /*(Image.network(
    piclist[index],
    fit: BoxFit.contain,));*/
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


