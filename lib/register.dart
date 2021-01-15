import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:toast/toast.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RegisterPage(),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //全局KEY
  GlobalKey<FormState> registerKey = new GlobalKey<FormState>();
  var pass1Key = GlobalKey<FormFieldState>();
  var pass2Key = GlobalKey<FormFieldState>();
  var nameKey = GlobalKey<FormFieldState>();

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
      appBar: AppBar(
        title: Text("欢迎注册"),
      ),
     /*body: Padding(
       padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
       child: Form(
         key: registerKey,
         autovalidate: true,
         child: Row(
           children:<Widget> [
             new Container(
                 padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 25.0),
                 child: Image.asset('images/appIcon.png')
             ),
             _registerUserName(),
             _registerPassword1(),
             _registerPassword2(),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children:<Widget> [
                 _returnButton(),
               ],
             )
           ],
         )
       ),
     ),*/
      body: Stack(
        children:<Widget> [
          Center(
            child:Container(
              child: Flex(
                direction: Axis.vertical,
                children:<Widget> [
                  new Container(
                    padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 25.0),
                    child: Image.asset('images/appIcon.png')
                  ),
                  _registerUserName(),
                  _registerPassword1(),
                  _registerPassword2(),
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

  Widget _registerUserName() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "创建您的账号",
          border: OutlineInputBorder(borderSide: BorderSide()),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(Icons.person),
        ),
        key: nameKey,
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
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "请输入密码",
          border: OutlineInputBorder(borderSide: BorderSide()),
          fillColor: Colors.white,
          filled: true,
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
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: "请再次输入密码",
            border: OutlineInputBorder(borderSide: BorderSide()),
            fillColor: Colors.white,
            filled: true,
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
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: RaisedButton(
        child: Text(
          "完成",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.blue,
        ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        onPressed: (){
          if (nameKey.currentState.validate() && pass1Key.currentState.validate() && pass2Key.currentState.validate()){
            _getFeedBack();
            if (_backCode == 0) {
              Toast.show("注册成功", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
              Navigator.pop(context);
            }else if (_backCode == 1) {
              Toast.show("用户名已存在，起名真难", context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
            }
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

