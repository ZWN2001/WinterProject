import 'package:flutter/material.dart';
import 'package:winter/SetUserInfo/changeUserName.dart';
import 'package:winter/SetUserInfo/changeUserPassword.dart';

class SetAccountInfo extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () {
              Navigator.of(buildContext).pop();
            },
          ),
          title: Text('账号设置'),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: SizedBox(
                width: 420,
                height: 80,
                child: RaisedButton(
                  color: Colors.white,
                  child: Text(
                    '修改用户名',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                        buildContext,
                        MaterialPageRoute(
                            builder: (context) => ChangeUserName()));
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: SizedBox(
                width: 420,
                height: 80,
                child: RaisedButton(
                  color: Colors.white,
                  child: Text(
                    '修改密码',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                        buildContext,
                        MaterialPageRoute(
                            builder: (buildContext) => ChangeUserPassword()));
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: SizedBox(
                width: 420,
                height: 80,
                child: RaisedButton(
                  color: Colors.white,
                  child: Text(
                    '退出登录',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  onPressed: () {
                    showDialog<Null>(
                      context: buildContext,
                      barrierDismissible: false,
                      builder: (BuildContext logoutContext) {
                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('确定退出吗？'),
                                Text('确定请点击确认，否则点击取消'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('取消'),
                              onPressed: () {
                                Navigator.of(logoutContext).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('确定'),
                              onPressed: () {
                                Navigator.of(logoutContext).pushNamedAndRemoveUntil('LoginPage', (Route<dynamic> route) => false);
                                // Navigator.pushReplacementNamed(logoutContext,'LoginPage');//还不行
                              },
                            ),
                          ],
                        );
                      },
                    ).then((val) {
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 90),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        '遇到问题了？ 戳我',
                        style: TextStyle(
                            fontSize: 15, color: Colors.lightBlueAccent),
                      )),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
