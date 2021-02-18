import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:winter/Basic/login.dart';

class getHeadImages{
  static Future<String> getHeadImage(BuildContext context) async {
    Response response=await Dio().post(
      'http://widealpha.top:8080/shop/user/headImage',
      options:
      Options(headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
    );
    print('头像：$response');
    if (response.data['code'] == 0) {
      return response.data['data'];
    } else if (response.data['code'] == -1) {
      Toast.show("您还未设置自己的头像哦", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      Toast.show("获取头像失败", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}