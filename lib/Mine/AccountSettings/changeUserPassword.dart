import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winter/Basic/login.dart';

class ChangeUserPassword extends StatelessWidget {
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
        title: Text('修改密码'),
      ),
      body: ChangeUserPasswordPage(),
    );
  }
}

class ChangeUserPasswordPage extends StatelessWidget {
  GlobalKey<FormState> changePasswordnKey = new GlobalKey<FormState>(); //全局key
  var oldpwdKey = GlobalKey<FormFieldState>();
  var newpwdKey1 = GlobalKey<FormFieldState>();
  var newpwdKey2 = GlobalKey<FormFieldState>();

  final oldPwdController = TextEditingController();
  final newPwdTextController1 = TextEditingController();
  final newPwdTextController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 4),
          child: TextFormField(
            key: oldpwdKey,
            controller: oldPwdController,
            obscureText: true,
            decoration: (InputDecoration(labelText: '请输入原密码')),
            validator: (value) {
              if (value.isEmpty) {
                return "原密码不可为空";
              }
              return null;
            },
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 4),
          child: TextFormField(
            key: newpwdKey1,
            controller: newPwdTextController1,
            obscureText: true,
            decoration: (InputDecoration(labelText: '请输入新密码')),
            validator: (value) {
              if (value.isEmpty) {
                return "不可为空";
              }
              return null;
            },
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: TextFormField(
            key: newpwdKey2,
            controller: newPwdTextController2,
            obscureText: true,
            decoration: (InputDecoration(labelText: '请确认新密码')),
            validator: (value) {
              if (value.isEmpty) {
                return "不可为空";
              }
              return null;
            },
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.assignment_turned_in_rounded,
                size: 28,
              ),
              onPressed: () {
                if (oldpwdKey.currentState.validate() &&
                    newpwdKey1.currentState.validate() &&
                    newpwdKey2.currentState.validate()) {
                  if (newPwdTextController1.text !=
                      newPwdTextController2.text) {
                    Toast.show("新密码不一致", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    _commit(newPwdTextController2.text, oldPwdController.text,
                        context);
                  }
                }
              },
            ),
          ),
        )
      ],
    );
  }

  void _commit(String newPassword, String password, BuildContext context) {
    Response response;
    Dio().post('http://widealpha.top:8080/shop/user/changePassword',
        options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),
        queryParameters: {
          'newPassword': newPassword,
          'password': password
        }).then((value) {
      response = value;
      print(response);
      if (response.data['code'] == 0) {
        Toast.show("修改密码成功", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      }  else if (response.data['code'] == -6) {
        Toast.show("登陆状态错误", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else if (response.data['code'] == -7) {
        Toast.show("权限不足", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else if (response.data['code'] == -8) {
        Toast.show("Token无效", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        Toast.show("未知错误", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
