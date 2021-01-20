import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:winter/SetUserInfo/SetAccountInfo.dart';
import 'package:winter/logIn.dart';

class Mine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MinePage(),
    );
  }
}

class MinePage extends StatefulWidget {
  @override
  MinePageState createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  // Color wordColor, backColor;
  //
  // void _setWordState() {
  //   setState(() {
  //     return Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
  //       wordColor = DarkModeModel.darkMode ? Colors.black : Colors.white;
  //     });
  //   });
  // }
  //
  // void _setbackColorState() {
  //   setState(() {
  //     return Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
  //       backColor = DarkModeModel.darkMode ? Colors.white : Colors.grey;
  //     });
  //   });
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _setbackColorState();
  //   _setWordState();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(20, 50, 20, 8),
            child: LoginPageState.logged ? _logged() : _unlogged(context)),

        Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: SizedBox(
              height: 60,
              child: RaisedButton(
                color:DarkModeModel.darkMode ? Colors.grey : Colors.white,
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
                          style: TextStyle(color: DarkModeModel.darkMode ? Colors.white : Colors.black, fontSize: 20),
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
                onPressed: () {},
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
                color: DarkModeModel.darkMode ? Colors.grey : Colors.white,
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
                          style: TextStyle(color: DarkModeModel.darkMode ? Colors.white : Colors.black, fontSize: 20),
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
                onPressed: () {},
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
                color: DarkModeModel.darkMode ? Colors.grey : Colors.white,
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
                          style: TextStyle(color: DarkModeModel.darkMode ? Colors.white : Colors.black, fontSize: 20),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetAccountInfo()));
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
                color: DarkModeModel.darkMode ? Colors.grey : Colors.white,
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
                          style: TextStyle(color: DarkModeModel.darkMode ? Colors.white : Colors.black, fontSize: 20),
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
                color: DarkModeModel.darkMode ? Colors.grey : Colors.white,
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
                          style: TextStyle(color: DarkModeModel.darkMode ? Colors.white : Colors.black, fontSize: 20),
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
                color: DarkModeModel.darkMode ? Colors.grey : Colors.white,
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
                          style: TextStyle(color: DarkModeModel.darkMode ? Colors.white : Colors.black, fontSize: 20),
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
                onPressed: () {},
              ),
            ),
          );
        })
      ],
    );
  }

  Widget _logged() {
    return Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
      return Card(
        color: DarkModeModel.darkMode ? Colors.grey : Colors.white,
        child: ListTile(
          title: Text(
            'Hi , 亲爱的' + LoginPageState.userName,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0, color: DarkModeModel.darkMode ? Colors.white : Colors.black),
          ),
          subtitle: Text('享你所想',
              style: TextStyle(color: DarkModeModel.darkMode ? Colors.white : Colors.black), textAlign: TextAlign.center),
        ),
      );
    }
    );
  }


  Widget _unlogged(BuildContext context) {
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
            Navigator.pushReplacementNamed(context, 'LoginPage');
          },
        ),
      ],
    );
  }
}
