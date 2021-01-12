import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //全局key，用来获取form表单组件
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();
  String userName; //用户名
  String passWord; //密码
  void login() {
    var loginForm = loginKey.currentState; //读取当前Form
    if (loginForm.validate()) {
      loginForm.save();
      print('userName:' + userName + "   password:" + passWord);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '登录页',
      home: new Scaffold(
        appBar: AppBar(
          title: Text('欢迎登录'),
        ),


        body: Column(
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 25.0),
              child: new Form(
                  key: loginKey,
                  child: Column(
                    children: <Widget>[
                      new Container(

                          child: Image.asset('images/appIcon.png')
                      ),

                      Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: new TextFormField(
                            decoration: new InputDecoration(labelText: '请输入账号'),
                            onSaved: (value) {
                              userName = value;
                            },
                            onFieldSubmitted: (value) {},
                          ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: new TextFormField(
                          decoration: new InputDecoration(labelText: '请输入密码'),
                          obscureText: true,
                          onSaved: (value) {
                            passWord = value;
                          },
                        ),
                      ),
                    ],
                  )),
            ),

            //按钮
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 15.0, 0),
                  child: new FlatButton(
                    onPressed: login,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
                    child: Text(
                      '登录',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 0, 0.0, 0),
                  child: new FlatButton(
                    onPressed: login, //nded to change
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
                    child: Text(
                      '注册',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
