import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winter/search.dart';
import 'dart:async';
import 'AdapterAndHelper/DarkModeModel.dart';
import 'AddGoodsAndNeeds/TabBarForAdd.dart';
import 'home.dart';
import 'logIn.dart';

void main() => runApp(Splash());

class Splash extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider<DarkModeModel>(builder: (child) => DarkModeModel())
    ],
    child: Consumer<DarkModeModel>(
    builder: (context, DarkModeModel, child) {
    return MaterialApp(


       routes: {
         //命名路由
         'MyHomePage':(context)=>MyHomePage(),
         'LoginPage':(context)=>LoginPage(),
         'add':(context)=>TabBarForAdd(),
         'search':(context)=>SearchPageWidget(),
         'home':(context)=>Home(),
       },
       theme: DarkModeModel.darkMode
           ? ThemeData.dark()
           : ThemeData(
         primarySwatch: Colors.blue,
       ),


       home:Scaffold(
         body: SplashPage(),
       )
    );
    },
    ),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashPage>{

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child:  Container(
                  margin: EdgeInsets.only(left: 15,right: 15),
                  child:  Image.asset(
                    "images/splash.png",
                  ),
                ),
              ),

              Align(
                  alignment: Alignment.bottomCenter,
                  child:  Container(
                    margin: EdgeInsets.only(bottom: 15,top: 10),
                    child: Container(
                      child:Column(
                        children: [
                          Image.asset(
                            "images/appIcon.png",
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child:  Text(
                              'Developed by : zwn & whc',
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ],
          // ],
        // ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDown();
  }

  // 倒计时
  void countDown() {
    var _duration = new Duration(seconds: 3);
    new Future.delayed(_duration, newHomePage);
  }
  void newHomePage() {
    Navigator.pushReplacementNamed(context, 'home');
  }
}