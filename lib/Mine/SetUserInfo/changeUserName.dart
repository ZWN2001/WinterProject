import 'package:flutter/material.dart';

class ChangeUserName extends StatelessWidget {

  TextEditingController _newUserNameController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white),
            onPressed: (){

              Navigator.of(context).pop();

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
                      controller: _newUserNameController,
                    ),
                  )
              ),
            ),

            Center(
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: FloatingActionButton(
                  backgroundColor: Colors.lightBlue,
                  child: Icon(Icons.assignment_turned_in_rounded, size: 28,),
                  onPressed: () {

                  },
                ),
              ),
            ),
          ],
        )

    );
  }
}
