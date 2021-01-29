import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winter/AdapterAndHelper/darkModeModel.dart';
import 'changeUserPassword.dart';
import 'file:///E:/apps/winter/lib/Mine/SetUserInfo/changeUserName.dart';

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
                             Navigator.of(logoutContext)
                                 .pushNamedAndRemoveUntil('LoginPage', (
                                 Route<dynamic> route) => false);
                             // Navigator.pushReplacementNamed(logoutContext,'LoginPage');//还不行
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

}
