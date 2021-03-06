import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/user.dart';
import 'package:winter/SharedPreference/sharedPreferenceUtil.dart';


class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RegisterPage();
  }
}

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var pass1Key = GlobalKey<FormFieldState>();
  var pass2Key = GlobalKey<FormFieldState>();
  var accountKey = GlobalKey<FormFieldState>();
  var userNameKey = GlobalKey<FormFieldState>();

  String _account = "";
  String _userName = "";//用户名
  String _password1 = "";//密码
  String _password2 = "";//确认密码
  int _backCode;
  bool pwdShow = true;// 默认不显示密码

  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("欢迎注册"),
      ),
      body: Stack(
        children:<Widget> [
          Center(
            child:Container(
              child: Flex(
                direction: Axis.vertical,
                children:<Widget> [
                  new Container(
                    padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 25.0),
                    child: Image.asset('images/appIcon.png')
                  ),
                  Card(
                    child: Column(
                      children: [
                        _registerAccount(),
                        _registerUserName(),
                        _registerPassword1(),
                        _registerPassword2(),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget> [
                      _returnButton(),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _registerAccount() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 15),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          hintText: "创建账号/使用学号",
          // border: OutlineInputBorder(borderSide: BorderSide()),
          // fillColor: Colors.white,
          // filled: true,
          prefixIcon: Icon(Icons.person),
        ),
        key: accountKey,
        validator: (value) {
          if (value.isEmpty) {
            return "账号不可为空";
          } else {
            for (int i = 0; i < value.length; i++) {
              if (value[i] == " "){
                return "账号不能含有空格";
              }
            }
            return null;
          }
        },
        onChanged: (value) {
          _account = value;
        },
      ),
    );
  }

  Widget _registerUserName() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
      child: TextFormField(
        key: userNameKey,
        decoration: InputDecoration(
          hintText: "设置用户名/昵称",
          // border: OutlineInputBorder(borderSide: BorderSide()),
          // fillColor: Colors.white,
          // filled: true,
          prefixIcon: Icon(Icons.accessibility_new),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "用户名不可为空";
          }
          return null;
        },
        onChanged: (value) {
          _userName = value;
        },
      ),
    );
  }

  Widget _registerPassword1() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "设置密码",
          // border: OutlineInputBorder(borderSide: BorderSide()),
          // fillColor: Colors.white,
          // filled: true,
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.all(8),
          suffixIcon: IconButton(
            icon: Icon(
              pwdShow ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: (){
              setState(() {
                pwdShow = !pwdShow;
              });
            },
          )
        ),
        obscureText: pwdShow,
        controller: _password1Controller,
        key: pass1Key,
        validator: (value) {
          if (value.isEmpty) {
            return "密码不可为空";
          }
          return null;
        },
        onChanged: (value) {
          _password1 = value;
        },
      ),
    );
  }

  Widget _registerPassword2() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 15),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: "请确认密码",
            // border: OutlineInputBorder(borderSide: BorderSide()),
            // fillColor: Colors.white,
            // filled: true,
            prefixIcon: Icon(Icons.lock),
            contentPadding: EdgeInsets.all(8),
            suffixIcon: IconButton(
              icon: Icon(
                pwdShow ? Icons.visibility_off : Icons.visibility,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: (){
                setState(() {
                  pwdShow = !pwdShow;
                });
              },
            )
        ),
        obscureText: pwdShow,
        key: pass2Key,
        controller: _password2Controller,
        onChanged: (value) {
          _password2 = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return "请再次输入密码";
          }else if (_password2 != _password1){
            return "两次密码不相同";
          }
          return null;
        },
      ),
    );
  }

  _getFeedBack() async
  {
    var url = 'http://106.15.192.117:8080/shop/register?userName='+_userName+'&password='+_password2;
    var httpClient = new HttpClient();

    int result;
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
       result = data['code'];
    }else {
       print("Error") ;
    }
    if (!mounted) return;
    setState(() {
      _backCode = result;
    });
  }

  Widget _returnButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: FlatButton(
        child: Text(
          "完成",
        style: TextStyle(
          fontSize: 25.0,
          color: Colors.blue,
        ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        onPressed: () async {
          SharedPreferenceUtil.saveUsername(_userName);
          Response response;
          String feedback;
          Dio dio = Dio();
          //dio.options.baseUrl = "http://widealpha.top:8080/shop";
          if (userNameKey.currentState.validate() && accountKey.currentState.validate() && pass1Key.currentState.validate() && pass2Key.currentState.validate()){
            //postHttp('http://widealpha.top/shop/user/register?account='+_account+'&password='+_password2+'&username='+_userName);
            //response = await dio.post("/user/register",data: {"account": _account, "password": _password2, "username": _userName});
            response = await dio.post(
              'http://widealpha.top:8080/shop/user/register',
              queryParameters: {
                'account': _account,
                'password': _password2,
                'username': _userName,
              }
            );
            feedback = response.data.toString();
              print(feedback);
              if (response.data['code'] == 0) {
                SharedPreferenceUtil.saveUser(User(_account,_password2));
                Toast.show("注册成功！", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.of(context).pop();
              } else {
                Toast.show("注册失败，换个账号吧", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
            ;
          }
        },
      ),
    );
  }

  /*String validatePassword1(String value) {
    if (value.length == 0) {
      return "密码不可为空";
    }else if (value.length < 6) {
      return "密码长度不可少于六位";
    }
    return null;
  }

  String validatePassword2(String value) {
    var password = pass1Key.currentState.value;
    if (value.length == 0) {
      return "密码不可为空";
    }else if (value != password) {
      return "两次密码不同";
    }
    return null;
  }*/
}

