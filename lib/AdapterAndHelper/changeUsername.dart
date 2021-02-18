import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winter/Basic/login.dart';

class changeUsername {
  static void commit(String newUsername, BuildContext context) {
    Response response;
    Dio().post('http://widealpha.top:8080/shop/user/changePassword',
        options: Options(
            headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
        queryParameters: {
          'newUsername': newUsername,
        }).then((value) {
      response = value;
      print(response);
      if (response.data['code'] == 0) {
        Toast.show("修改用户名成功", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else if (response.data['code'] == -6) {
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
