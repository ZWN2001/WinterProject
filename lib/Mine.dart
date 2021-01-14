import 'package:flutter/material.dart';
import 'package:winter/SetUserInfo/SetAccountInfo.dart';
import 'package:winter/main.dart';

class Mine extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
          return MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 50, 20, 8),
                      child:Card(
                        child: ListTile(
                          title: Text(
                            'Hi , 亲爱的'+LoginPageState.userName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25.0
                            ),
                          ),
                          subtitle: Text(
                              '享你所想',
                              textAlign: TextAlign.center
                          ),
                        ),
                      )
                  ),

                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child:   SizedBox(
                              width: 365,
                              height: 60,
                              child:RaisedButton.icon(
                                padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                label: Text(
                                  '个人信息',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                                color: Colors.white,
                                icon: Icon(Icons.settings,color: Colors.lightBlueAccent),
                                onPressed:(){ print('pressed');},
                              ),
                            ),
                          ),

                  Container(
                      child: Column(
                        children: [

                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child:   SizedBox(
                              width: 365,
                              height: 60,
                              child:RaisedButton.icon(
                                padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                label: Text(
                                  '我的发布',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                                color: Colors.white,
                                icon: Icon(Icons.assignment_rounded
                                    ,color: Colors.lightBlueAccent),
                                onPressed:(){ print('pressed');},
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child:  SizedBox(
                              width: 365,
                              height: 60,
                              child:RaisedButton.icon(
                                padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                label: Text(
                                  '账号安全',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                                color: Colors.white,
                                icon: Icon(Icons.admin_panel_settings,color: Colors.lightBlueAccent),
                                onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>SetAccountInfo()));},
                              ),
                            ) ,
                          ),

                          Container(
                            margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child:SizedBox(
                              width: 365,
                              height: 60,
                              child:RaisedButton.icon(
                                padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                label: Text(
                                  '我的卡包',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                                color: Colors.white,
                                icon: Icon(Icons.account_balance_wallet,color: Colors.lightBlueAccent),
                                onPressed:(){ print('pressed');},
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child:  SizedBox(
                              width: 365,
                              height: 60,
                              child:RaisedButton.icon(
                                  padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                  label: Text(
                                    '主题切换',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                  ),
                                  color: Colors.white,
                                  icon: Icon(Icons.autorenew,color: Colors.lightBlueAccent),
                                  onPressed:(){}
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child:   SizedBox(
                              width: 365,
                              height: 60,
                              child:RaisedButton.icon(
                                padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                label: Text(
                                  '版本更新',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                                color: Colors.white,
                                icon: Icon(Icons.update,color: Colors.lightBlueAccent),
                                onPressed:(){ print('pressed');},
                              ),
                            ),
                          ),

                        ],
                      )
                  ),
                ],
              ),
            ),
          );
  }
}