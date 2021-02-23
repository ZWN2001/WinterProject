import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:winter/Basic/login.dart';
//MediaType用
import 'package:http_parser/http_parser.dart';
import 'package:winter/Mine/mine.dart';

import 'headImage.dart';

class CropImageRoute extends StatefulWidget {
  CropImageRoute(this.image);

  File image; //原始图片路径

  @override
  _CropImageRouteState createState() => new _CropImageRouteState();
}

class _CropImageRouteState extends State<CropImageRoute> {
  double baseLeft; //图片左上角的x坐标
  double baseTop; //图片左上角的y坐标
  double imageWidth; //图片宽度，缩放后会变化
  double imageScale = 1; //图片缩放比例
  Image imageView;
  final cropKey = GlobalKey<CropState>();



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        body: Container(
          height: height,
          width: width,
          margin: EdgeInsets.only(top: 25),
          child: Column(
            children: <Widget>[
              Container(
                height: height * 0.8,
                child: Crop.file(
                  widget.image,
                  key: cropKey,
                  aspectRatio: 1,
                  alwaysShowGrid: true,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child:
                ChangeNotifierProvider<HeadImage>(
                  create: (_) => HeadImage(),
                  builder: (myContext, child) {
                    return
                      Consumer<HeadImage>(
                      builder: (_, headImage, child) {
                        return FloatingActionButton(
                          backgroundColor: Colors.lightBlue,
                          child: Icon(Icons.assignment_turned_in_rounded,
                            size: 28,),
                          onPressed: ()  {
                             _crop(widget.image);
                             myContext.read<HeadImage>().refreshHeadImage(context);
                          },
                        );
                      },);
                  },),
              ),
            ],
          ),
        ));
  }

  Future<void> _crop(File originalFile) async {
    final crop = cropKey.currentState;
    final area = crop.area;
    print('originalFile:$originalFile');
    if (area == null) {
      //裁剪结果为空
      print('裁剪不成功');
    }
    await ImageCrop.requestPermissions().then((value) async {
      if (value) {
        ImageCrop.cropImage(
          file: originalFile,
          area: crop.area,
        ).then((value) async {
          MultipartFile myfile = await MultipartFile.fromFile(value.path,filename: 'headImage',contentType:MediaType("image", "jpg"));
          print('MultipartFile:$myfile');
          FormData formData = FormData.fromMap({
            "image": myfile
          });
          print(formData);
          upload(formData);
        });
      }
      // else {
      //   MultipartFile myfile = await MultipartFile.fromFile(originalFile.path, filename: 'headImage',contentType:MediaType("image", "jpg"));
      //   upload(myfile);
      // }
    });
  }

  ///上传头像
  Future<void> upload(FormData file) async {
    Response response;
    response=await Dio().post('http://widealpha.top:8080/shop/user/changeHeadImage',
        options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),
        // queryParameters: {
        //   'image': file
        // },
      data: file
    );
    print('头像上传：$response');
    if (response.data['code'] == 0) {
      Toast.show("头像上传成功", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      Navigator.of(context).pop();
      // myContext.read<HeadImage>().refresh();
    }  else {
      Toast.show("图片上传失败，请重试", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
