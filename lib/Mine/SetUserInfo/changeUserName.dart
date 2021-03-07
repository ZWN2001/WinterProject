import 'package:flutter/material.dart';
import 'package:winter/AdapterAndHelper/changeUsername.dart';
import 'package:winter/SharedPreference/sharedPreferenceUtil.dart';
class ChangeUserName extends StatelessWidget {

  TextEditingController _newUserNameController=TextEditingController();
  var usernameKey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white),
            onPressed: (){
              Navigator.of(context).pop();
              },
          ),
          title: Text('更改用户名'),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                  '请输入新用户名:',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.lightBlueAccent
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child:Center(
                  child:SizedBox(
                    width: 300,
                    height: 50,
                    child:TextFormField(
                      key: usernameKey,
                      controller: _newUserNameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "用户名不可为空";
                        }else if(value.length>6){
                          return "用户名长度不能大于六";
                        }
                        return null;
                      },
                    ),
                  )
              ),
            ),

            Center(
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: FloatingActionButton(
                  backgroundColor: Colors.lightBlue,
                  child: Icon(Icons.assignment_turned_in_rounded, size: 28,),
                  onPressed: () {
                    if(usernameKey.currentState.validate()){
                      SharedPreferenceUtil.saveUsername(_newUserNameController.text);
                      changeUsername.commit(_newUserNameController.text, context);
                    }
                  },
                ),
              ),
            ),
          ],
        )
    );
  }

  // void _commit(String newUsername, BuildContext context) {
  //   Response response;
  //   Dio().post('http://widealpha.top:8080/shop/user/changePassword',
  //       options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),
  //       queryParameters: {
  //         'newUsername': newUsername,
  //       }).then((value) {
  //     response = value;
  //     print(response);
  //     if (response.data['code'] == 0) {
  //       Toast.show("修改用户名成功", context,
  //           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  //       Navigator.of(context).pop();
  //     }  else if (response.data['code'] == -6) {
  //       Toast.show("登陆状态错误", context,
  //           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  //     } else if (response.data['code'] == -7) {
  //       Toast.show("权限不足", context,
  //           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  //     } else if (response.data['code'] == -8) {
  //       Toast.show("Token无效", context,
  //           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  //     } else {
  //       Toast.show("未知错误", context,
  //           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  //     }
  //   });
  // }
}
