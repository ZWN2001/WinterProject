import 'package:flutter/material.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart';
import 'package:winter/AdapterAndHelper/expandableText.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: ListData.length,
      itemBuilder: (context, index){
        return Material(
          child: itemWidget(index),
          //color: Colors.grey,
        );
      },
    );
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