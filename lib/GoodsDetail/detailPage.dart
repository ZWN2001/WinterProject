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