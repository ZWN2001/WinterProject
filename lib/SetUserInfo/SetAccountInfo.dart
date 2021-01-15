
import 'package:flutter/material.dart';
import 'package:winter/BottomNavigation/BottomNavigationBar.dart';
import 'package:winter/SetUserInfo/ChangeUserName.dart';
import 'package:winter/SetUserInfo/ChangeUserPassword.dart';
import '../Main.dart';


class SetAccountInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white),
            onPressed: (){Navigator.pop(context, MaterialPageRoute(builder: (context)=>MyHomePage()));},
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
                    style:TextStyle(
                    fontSize: 25,
                      color: Colors.black
                  ) ,
                  ),
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeUserName()));},
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 12,20, 0),
              child: SizedBox(
                width: 420,
                height: 80,
                child: RaisedButton(
                  color: Colors.white,
                  child: Text(
                    '修改密码',
                    style:TextStyle(
                        fontSize: 25,
                        color: Colors.black
                    ) ,
                  ),
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeUserPassword()));},
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 12,20, 0),
              child: SizedBox(
                width: 420,
                height: 80,
                child: RaisedButton(
                  color: Colors.white,
                  child: Text(
                    '退出登录',
                    style:TextStyle(
                        fontSize: 25,
                        color: Colors.black
                    ) ,
                  ),
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));},
                ),
              ),
            ),

            Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 90),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: FlatButton(
                        onPressed:(){},
                        child: Text(
                          '遇到问题了？ 戳我',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.lightBlueAccent
                          ),
                        )
                    ),
                  ),
                ),
            ),

          ],
        ),
      ),
    );
  }
}