import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  String _userName = "";//用户名
  String _password = "";//密码
  bool pwdShow = false;// 默认不显示密码

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      child: TextField(
        key: registerKey,
        decoration: InputDecoration(
          labelText: "创建您的账号",
          border: OutlineInputBorder(borderSide: BorderSide()),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(Icons.person),
        ),
      ),
    );
  }

  Widget _registerPassword1() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        decoration: InputDecoration(
          labelText: "请输入密码",
          border: OutlineInputBorder(borderSide: BorderSide()),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.all(8),
          suffixIcon: IconButton(
            icon: Icon(
              pwdShow ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: (){
              setState(() {
                pwdShow = !pwdShow;
              });
            },
          )
        ),
        obscureText: true,
      ),
    );
  }

  Widget _registerPassword2() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextField(
        decoration: InputDecoration(
            labelText: "请再次输入密码",
            border: OutlineInputBorder(borderSide: BorderSide()),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(Icons.lock),
            contentPadding: EdgeInsets.all(8),
            suffixIcon: IconButton(
              icon: Icon(
                pwdShow ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: (){
                setState(() {
                  pwdShow = !pwdShow;
                });
              },
            )
        ),
        obscureText: true,
      ),
    );
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
          Navigator.pop(context);
        },
      ),
    );
  }
}

