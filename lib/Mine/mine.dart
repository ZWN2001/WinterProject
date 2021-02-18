import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'hide BuildContext;
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:winter/AdapterAndHelper/getHeadImage.dart';
import 'package:winter/Basic/login.dart';
import 'MyRelease/myReleaseTabBar.dart';
import 'PersonalInfo/showInfo.dart';
import 'SetUserInfo/setAccountInfo.dart';
import 'package:image_picker/image_picker.dart';
import '../AdapterAndHelper/cropImage.dart';

class Mine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
        elevation: 0,  //这个是去掉底部阴影的代码
      ),
      body: MinePage(),
    );
  }
}

class MinePage extends StatefulWidget {
  @override
  MinePageState createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  String _headImageUrl;
  String _username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initing....');
    if(LoginPageState.logged) {
      getHeadImages.getHeadImage(context).then((value){
        print(value);
        _headImageUrl=value;
      });
      _getUsername().then((value) {
        _username=value;
      });
      print('headImageUrl:$_headImageUrl');
      print('username:$_username');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    return Column(
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: LoginPageState.logged ? _logged() : _unlogged()),
        Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: SizedBox(
              height: 60,
              child: RaisedButton(
                color: DarkModeModel.darkMode ? Colors.black : Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child:
                            Icon(Icons.settings, color: Colors.lightBlueAccent),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          '个人信息',
                          style: TextStyle(
                              color: DarkModeModel.darkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Icon(Icons.arrow_forward_ios_sharp)),
                    ),
                  ],
                ),
                onPressed: () {
                  if (!LoginPageState.logged) {
                    Toast.show("请先登录", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ShowInfo()));
                  }
                },
              ),
            ),
          );
        }),
        Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: SizedBox(
              height: 60,
              child: RaisedButton(
                color: DarkModeModel.darkMode ? Colors.black : Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Icon(Icons.assignment_rounded,
                            color: Colors.lightBlueAccent),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          '我的发布',
                          style: TextStyle(
                              color: DarkModeModel.darkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Icon(Icons.arrow_forward_ios_sharp)),
                    ),
                  ],
                ),
                onPressed: () {
                  if (!LoginPageState.logged) {
                    Toast.show("请先登录", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyReleaseTabBar()));
                  }
                },
              ),
            ),
          );
        }),
        Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: SizedBox(
              height: 60,
              child: RaisedButton(
                color: DarkModeModel.darkMode ? Colors.black : Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Icon(Icons.admin_panel_settings,
                            color: Colors.lightBlueAccent),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          '账号设置',
                          style: TextStyle(
                              color: DarkModeModel.darkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Icon(Icons.arrow_forward_ios_sharp)),
                    ),
                  ],
                ),
                onPressed: () {
                  if (!LoginPageState.logged) {
                    Toast.show("请先登录", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SetAccountInfo()));
                  }
                },
              ),
            ),
          );
        }),
        Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: SizedBox(
              height: 60,
              child: RaisedButton(
                color: DarkModeModel.darkMode ? Colors.black : Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Icon(Icons.autorenew,
                            color: Colors.lightBlueAccent),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          '主题切换',
                          style: TextStyle(
                              color: DarkModeModel.darkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: DarkModeModel.darkMode
                              ? Icon(Icons.nights_stay_outlined)
                              : Icon(Icons.wb_sunny_outlined)),
                    ),
                  ],
                ),
                onPressed: () {
                  DarkModeModel.changeMode();
                },
              ),
            ),
          );
        }),
        Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: SizedBox(
              height: 60,
              child: RaisedButton(
                color: DarkModeModel.darkMode ? Colors.black : Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child:
                            Icon(Icons.update, color: Colors.lightBlueAccent),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          '版本更新',
                          style: TextStyle(
                              color: DarkModeModel.darkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Icon(Icons.arrow_forward_ios_sharp)),
                    ),
                  ],
                ),
                onPressed: () {
                  Toast.show("已是最新版本", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                },
              ),
            ),
          );
        }),
        Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SizedBox(
              height: 60,
              child: RaisedButton(
                color: DarkModeModel.darkMode ? Colors.black : Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Icon(Icons.all_inclusive,
                            color: Colors.lightBlueAccent),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          '我要反馈',
                          style: TextStyle(
                              color: DarkModeModel.darkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Icon(Icons.arrow_forward_ios_sharp)),
                    ),
                  ],
                ),
                onPressed: () {
                  Toast.show("好哒", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                },
              ),
            ),
          );
        })
      ],
    );
  }

  Widget _logged() {
    return Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
      return
        // Expanded(
        // // color: DarkModeModel.darkMode ? Colors.black : Colors.white,
        // child:
        Container(
          color: DarkModeModel.darkMode ? Colors.black26: Colors.blue,
            child: Row(
          children: [
            Container(
              child: GestureDetector(
                onTap: _chooseImage,
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 8, 8, 8),
                  child: ClipOval(
                      child: _headImageUrl == null
                          ? Image.asset(
                              'images/defaultHeadImage.png',
                              color: Colors.white,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              _headImageUrl,
                              fit: BoxFit.cover,
                            )),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(right: 15, bottom: 20),
                  // color: Colors.indigoAccent,
                  // child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          //TODO
                          'Hi , 亲爱的',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white
                          ),
                        ),
                        Text('账号：' + LoginPageState.account,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white
                            ),
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  // )
              ),
            ),
          ],
        ));
      // );
    });
  }

  Widget _unlogged() {
    return Column(
      children: [
        Text(
          '客官还没有登录呢！',
          style: TextStyle(fontSize: 25, color: Colors.blue),
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Text(
            '前往登录/注册',
            style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ],
    );
  }

  ///从相册选取
  Future _chooseImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return 0;
    } else {
         Navigator.push(context,
          MaterialPageRoute(builder: (context) => CropImageRoute(image)));;
    }
    setState(() {
      initState();//TODO 此处应该是局部更新
    });
  }


  Future<String> _getUsername() async {
    Response response=await Dio().post(
      'http://widealpha.top:8080/shop/user/username',
      options:
          Options(headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
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

  // Future<String> _getHeadImage() async {
  //   Response response=await Dio().post(
  //     'http://widealpha.top:8080/shop/user/headImage',
  //     options:
  //         Options(headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
  //   );
  //     print('头像：$response');
  //     if (response.data['code'] == 0) {
  //       return response.data['data'];
  //     } else if (response.data['code'] == -1) {
  //       Toast.show("您还未设置自己的头像哦", context,
  //           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  //     } else {
  //       Toast.show("获取头像失败", context,
  //           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  //     }
  // }
}
