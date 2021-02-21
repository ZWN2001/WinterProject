import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/getUsername.dart';
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
      body: ShowInfoPage(),
    );
  }
}

class ShowInfoPage extends StatefulWidget{
  @override
  MyInfoState createState() => new MyInfoState();
}

Future _getInfo(BuildContext context) async {
  Response response=await  Dio().post('http://widealpha.top:8080/shop/user/userInfo',
      options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),);
  print(response);
  if (response.data['code'] == 0) {
    print('this userInfo:${response}');
       return UserInfo.fromJson(response.data['data']);
    }  else if (response.data['code'] == -6) {
      Toast.show("登陆状态错误", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return null;
    } else if (response.data['code'] == -8) {
      Toast.show("Token无效", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return null;
    } else {
      Toast.show("未知错误", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return null;
    }
}
class MyInfoState extends State<ShowInfoPage> {
  String _username;
  UserInfo _userInfo=UserInfo(LoginPageState.account, '', 0, '', '', 0, '');
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getUserName.getUsername(context).then((value) {
      _username=value;
    });
    _getInfo(context).then((value) {
      if(mounted) {
        setState(() {
          _userInfo = value;
        });
      }
    });
    print('userInfo:$_userInfo');
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
                        '头像',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 30),
                          alignment: Alignment.centerRight,
                          child: ClipOval(
                              child:
                              _userInfo.headImage?.toString()==null ?
                              Image.asset(
                                'images/defaultHeadImage.png',
                                color: Colors.black,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                _userInfo.headImage?.toString(),
                                fit: BoxFit.cover,
                              )
                          ),
                        )
                    ),
                  ],
                ),
              ),
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
                    Expanded(
                      child:Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 30),
                        child: Text(
                            _username?.toString()??'未设置',
                          style: TextStyle(fontSize: 20),
                        )
                    ),
                    )
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
                    Expanded(
                      child:Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 30),
                        child: Text(
                          LoginPageState.account,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
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
                    Expanded(
                      child:Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 30),
                        child: Text(
                          _userInfo.name?.toString()??'未设置',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
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
                    Expanded(
                      child:Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 30),
                        child: Text(
                          '${_userInfo.age?.toString()??'未设置'}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
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
                    Expanded(
                      child:Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 30),
                        child: Text(
                          _userInfo.location?.toString()??'未设置',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 15, 0, 15),
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
                Expanded(
                  child:Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 26),
                    child: Text(
                      _userInfo.introduction?.toString()??'未设置',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
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
                Navigator.pushReplacementNamed(context,'changeInfo');
              },
            ),
          ),
        )),
      ],
    );
  }
}
