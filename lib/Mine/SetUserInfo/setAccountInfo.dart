import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/darkModeModel.dart';
import 'package:winter/Basic/login.dart';
import 'changeUserName.dart';
import 'changeUserPassword.dart';

class SetAccountInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('账号设置'),
        ),
        body:SetAccountInfoPage()
      );
  }
}
class SetAccountInfoPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
 return MultiProvider(
     providers: [
     ChangeNotifierProvider<DarkModeModel>(builder: (child) => DarkModeModel())
    ],
   child:Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
   return Container(
     child: Column(
       children: [
         Container(
           margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
           child: SizedBox(
             width: 420,
             height: 80,
             child: RaisedButton(
               color: DarkModeModel.darkMode ? Colors.black : Colors.white,
               child: Text(
                 '修改用户名',
                 style: TextStyle(fontSize: 25,
                   color: DarkModeModel.darkMode
                       ? Colors.white
                       : Colors.black,),
               ),
               onPressed: () {
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => ChangeUserName()));
               },
             ),
           ),
         ),
         Container(
           margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
           child: SizedBox(
             width: 420,
             height: 80,
             child: RaisedButton(
               color: DarkModeModel.darkMode ? Colors.black : Colors.white,
               child: Text(
                 '修改密码',
                 style: TextStyle(fontSize: 25,
                   color: DarkModeModel.darkMode
                       ? Colors.white
                       : Colors.black,),
               ),
               onPressed: () {
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (buildContext) => ChangeUserPassword()));
               },
             ),
           ),
         ),
         Container(
           margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
           child: SizedBox(
             width: 420,
             height: 80,
             child: RaisedButton(
               color: DarkModeModel.darkMode ? Colors.black : Colors.white,
               child: Text(
                 '退出登录',
                 style: TextStyle(fontSize: 25,
                   color: DarkModeModel.darkMode
                       ? Colors.white
                       : Colors.black,),
               ),
               onPressed: () {
                 showDialog<Null>(
                   context: context,
                   barrierDismissible: false,
                   builder: (BuildContext logoutContext) {
                     return AlertDialog(
                       content: SingleChildScrollView(
                         child: ListBody(
                           children: <Widget>[
                             Text('确定退出吗？'),
                             Text('确定请点击确认，否则点击取消'),
                           ],
                         ),
                       ),
                       actions: <Widget>[
                         FlatButton(
                           child: Text('取消'),
                           onPressed: () {
                             Navigator.of(logoutContext).pop();
                           },
                         ),
                         FlatButton(
                           child: Text('确定'),
                           onPressed: () {
                             _logout(logoutContext);
                           },
                         ),
                       ],
                     );
                   },
                 ).then((val) {});
               },
             ),
           ),
         ),
         Expanded(
           child: Container(
             margin: EdgeInsets.fromLTRB(0, 0, 0, 90),
             child: Align(
               alignment: FractionalOffset.bottomCenter,
               child: FlatButton(
                   onPressed: () {},
                   child: Text(
                     '遇到问题了？ 戳我',
                     style: TextStyle(
                         fontSize: 15, color: Colors.lightBlueAccent),
                   )),
             ),
           ),
         ),
       ],
     ),
   );
 }
 )
 );
  }

  void _logout(BuildContext context){
    Response response;
    Dio().post('http://widealpha.top:8080/shop/user/changePassword',
        options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),
        ).then((value) {
      response = value;
      print(response);
      if (response.data['code'] == 0) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('LoginPage', (
            Route<dynamic> route) => false);
        Toast.show("退出成功", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        Toast.show("未知错误", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
