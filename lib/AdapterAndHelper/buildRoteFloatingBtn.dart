import 'package:flutter/material.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';
import 'package:toast/toast.dart';
import 'package:winter/Basic/login.dart';
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
          if(LoginPageState.logged) {
            Navigator.of(context).pushNamed('add');
          }else{
            Toast.show("请先登录", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        }else{
          if(LoginPageState.logged) {
            Navigator.of(context).pushNamed('search');
          }else{
            Toast.show("请先登录", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        }
      },
    ),
  );
  }

}