import 'package:flutter/material.dart';

import 'setAccountInfo.dart';

class ChangeUserPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('修改密码'),
        ),
        body: ChangeUserPasswordPage(),
    );
  }
}

class ChangeUserPasswordPage extends StatelessWidget {
  final myTextController = TextEditingController();
  final newPwdTextController1 = TextEditingController();
  final newPwdTextController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 4),
          child: TextField(
            controller: myTextController,
            decoration: (InputDecoration(labelText: '请输入原密码')),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 4),
          child: TextField(
            controller: newPwdTextController1,
            decoration: (InputDecoration(labelText: '请输入新密码')),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: TextField(
            controller: newPwdTextController2,
            decoration: (InputDecoration(labelText: '请确认新密码')),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Center(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Text(
                    '提交',
                    style:
                        TextStyle(fontSize: 25, color: Colors.lightBlueAccent),
                  ),
                  onPressed: () {
                    if(newPwdTextController1.text==newPwdTextController2.text){


                    }else{

                    }
                  },
                ),
              )
        )
      ],
    );
  }
}
