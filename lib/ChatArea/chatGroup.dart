import 'package:flutter/material.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart';
import 'package:winter/ChatArea/ChatPage.dart';

class ChatGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ChatGroupState();
}

class ChatGroupState extends State<ChatGroup> {

  List ListData = [
    {
      "headImage": "https://www.itying.com/images/flutter/7.png",
      "userName": "zwn",
      "lastMessage": "吃了吗？"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('聊天列表'),
      ),
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: ListData.length,
                itemBuilder: (context, index){
                  return Material(
                    child: itemWidget(index),
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget itemWidget(int index) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return new ChatPage();
        }));
      },
      child: Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          height: 55,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //padding: Ed,
                child: ClipOval(
                  clipper: _MyClipper(),
                  child: Image.network(ListData[index]["headImage"],
                  fit: BoxFit.fill,),
                ),
              ),
              Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ListData[index]["userName"],
                        style: TextStyle(
                            color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                            fontSize: 23)),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                        child: Text(ListData[index]["lastMessage"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                            fontSize: 12,)),
                      ),
                    ],
                  )),
            ],
          ),
        );
      },),
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