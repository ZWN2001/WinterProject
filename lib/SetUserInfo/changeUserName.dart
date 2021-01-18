import 'package:flutter/material.dart';
import 'package:winter/SetUserInfo/SetAccountInfo.dart';

class ChangeUserName extends StatelessWidget {

  final myTextController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SetAccountInfo()));
              },
          ),
          title: Text('更改用户名'),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                  '请输入新用户名:',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.lightBlueAccent
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child:Center(
                  child:SizedBox(
                    width: 300,
                    height: 50,
                    child:   TextField(
                      controller: myTextController,



                    ),
                  )
              ),
            ),

            Container(
                  margin: EdgeInsets.only(top: 30),
                    child:FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                     child: Text(
                       '提交',
                       style: TextStyle(
                         fontSize: 25,
                         color: Colors.lightBlueAccent
                       ),
                     ),
                      onPressed: (){},
                    ),
                )
          ],
        )

    );
  }
}
