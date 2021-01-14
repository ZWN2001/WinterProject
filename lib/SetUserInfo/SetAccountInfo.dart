import 'package:flutter/material.dart';
class SetAccountInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('账号信息设置'),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 30,0, 0),
              child: SizedBox(
                width: 420,
                height: 80,
                child: RaisedButton(
                  color: Colors.white,
                  child: Text(
                    '修改账号',
                    style:TextStyle(
                    fontSize: 25,
                      color: Colors.black
                  ) ,
                  ),
                  onPressed: (){},
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(0, 12,0, 0),
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
                  onPressed: (){},
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