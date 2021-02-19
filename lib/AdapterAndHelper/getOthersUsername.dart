import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:winter/Basic/login.dart';

class getOthersUserName{
  static Future<String> getOthersUsername(BuildContext context, String targetAccount) async {
    Response response=await Dio().post(
      'http://widealpha.top:8080/shop/user/othersUsername',
      options:
      Options(headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
      queryParameters: {
        'account': targetAccount
      }
    );
    print('用户名：$response');
    if (response.data['code'] == 0) {
      print(response.data['data'].toString());
      return response.data['data'].toString();
    } else if (response.data['code'] == -1) {
      Toast.show("您还未设置自己的用户名哦", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      Toast.show("获取用户名失败", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}