import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:winter/Basic/login.dart';

import 'cropImage.dart';

class HeadImage with ChangeNotifier{
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
  static Future chooseImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return 0;
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CropImageRoute(image)));;
    }
  }
  void refresh(){
    notifyListeners();
  }
}