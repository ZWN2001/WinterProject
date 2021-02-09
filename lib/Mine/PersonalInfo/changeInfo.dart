import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('修改个人资料'),
      ),
      body: myInfo(),
    );
  }
}

class myInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Card(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '用户名',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                          scrollPadding: EdgeInsets.all(0),
                          // controller: _price,
                          style: TextStyle(
                              fontSize: 20
                          ),
                        )
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '姓名',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                          scrollPadding: EdgeInsets.all(0),
                          // controller: _price,
                          style: TextStyle(
                              fontSize: 20
                          ),
                        )
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '年龄',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                          scrollPadding: EdgeInsets.all(0),
                          // controller: _price,
                          style: TextStyle(
                              fontSize: 20
                          ),
                        )
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '现居',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                          scrollPadding: EdgeInsets.all(0),
                          // controller: _price,
                          style: TextStyle(
                              fontSize: 20
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15),
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    '自我介绍:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                    child: TextFormField(
                      scrollPadding: EdgeInsets.all(0),
                      // controller: _price,
                      style: TextStyle(
                          fontSize: 20
                      ),
                    )
                ),
              ],
            ),
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
    );
  }
}
