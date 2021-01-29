import 'package:flutter/material.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';
class buildRoteFloatingBtn extends StatelessWidget{
  Widget build(BuildContext context) {
  return  Positioned(
    right: 33,
    bottom: 33,
    //悬浮按钮
    child: RoteFloatingButton(
      //菜单图标组
      iconList: [
        Icon(Icons.add),
        Icon(Icons.search),
      ],
      //点击事件回调
      clickCallback: (int index){
        if(index==0){
          Navigator.of(context).pushNamed('add');
        }else{
          Navigator.of(context).pushNamed('search');
        }
      },
    ),
  );
  }

}