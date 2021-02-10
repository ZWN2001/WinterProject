import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winter/Basic/login.dart';
import 'package:winter/Mine/PersonalInfo/userInfo.dart';
import 'changeInfo.dart';

class ShowInfo extends StatelessWidget {
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
        title: Text('个人资料'),
      ),
      body: myInfo(),
    );
  }
}

class ShowInfoPage extends StatefulWidget{
  @override
  MyInfoState createState() => new MyInfoState();
}

Future<void> _getInfo(BuildContext context, UserInfo userInfo) async {
  Response response=await  Dio().post('http://widealpha.top:8080/shop/user/changePassword',
      options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),);
    if (response.data['code'] == 0) {
       userInfo=response.data['data'];
    }  else if (response.data['code'] == -6) {
      Toast.show("登陆状态错误", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else if (response.data['code'] == -8) {
      Toast.show("Token无效", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      Toast.show("未知错误", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
}
class MyInfoState extends State<ShowInfoPage> {
  String _account;
  String _headImage;
  int _age;
  String _location;
  String _introduction;
  int _sex;
  String _name;
  UserInfo userInfo;
  @override
  void initState() {
    // TODO: implement initState
    _getInfo(context, userInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Card(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 0, 15),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '用户名',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    // Expanded(child: Text()),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 0, 15),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '账号',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(child: Text(userInfo.account)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 0, 15),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '姓名',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(child: Text(userInfo.name)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 0, 15),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '年龄',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(child: Text('${userInfo.age}')),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 0, 15),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '现居',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(child: Text(userInfo.location)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 15, 0, 15),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15),
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    '自我介绍:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(child: Text(userInfo.introduction)),
              ],
            ),
          ),
        ),
        Center(
            child: SizedBox(
          width: width * 4 / 5,
          child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  '修改个人信息',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangeInfo()));
              },
            ),
          ),
        )),
      ],
    );
  }
}
