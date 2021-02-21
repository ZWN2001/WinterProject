import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/getUsername.dart';
import 'package:winter/Basic/login.dart';
class AddNeeds extends StatelessWidget{
  TextEditingController _needsController=TextEditingController();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Align(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Container(
             margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
               child:TextField(
                 textAlign: TextAlign.center,
                 controller: _needsController,
                 maxLines: null,
                 style: TextStyle(
                     fontSize: 20,
                     textBaseline: TextBaseline.alphabetic
                 ),
                 decoration: InputDecoration(
                   hintText: '描述一下你的需求',
                   hintStyle: TextStyle(
                   ),
                   contentPadding: EdgeInsets.all(8),
                 ),
               ),
           ),
           Container(
             margin: EdgeInsets.only(top: 50,bottom: 40),
             child: FloatingActionButton(
               backgroundColor: Colors.lightBlue,
               child: Icon(Icons.assignment_turned_in_rounded, size: 28,),
               onPressed: () {
                 if(_needsController.text.isEmpty){
                   Toast.show("需求描述为空", context,
                       duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                 }else{
                   _submit(_needsController.text, context);
                   Navigator.of(context).pop();
                 }
               },
             ),
           ),
         ],
       ) ,
     ),
   );
  }
  void _submit( String description,BuildContext context) {
    String username;
    getUserName.getUsername(context).then((value) {
      username=value;
    });
    Response response;
    Dio().post('http://widealpha.top:8080/shop/want/addWant',
        options: Options(
            headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
        queryParameters: {
          'title': username,
          'description': description,
        }).then((value) {
      response = value;
      print('需求发布:$response');
      if (response.data['code'] == 0) {
        Toast.show("需求发布成功", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if (response.data['code'] == -6) {
        Toast.show("登陆状态错误", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }  else if (response.data['code'] == -8) {
        Toast.show("Token无效", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        Toast.show("未知错误", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}