import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winter/Basic/login.dart';

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
  TextEditingController _age = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _introduction = TextEditingController();
  TextEditingController _sex = TextEditingController();
  TextEditingController _name = TextEditingController();
  // TextEditingController _title = TextEditingController();
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
                        '头像',
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
                          controller: _name,
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
                        '性别',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                          scrollPadding: EdgeInsets.all(0),
                          controller: _sex,
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
                          controller: _age,
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
                          controller: _location,
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
                      controller: _introduction,
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
  void _submitDetails(String title, double price, String description, String category,String imageUrl,BuildContext context) {
    Response addGoodsResponse;
    Dio().post('http://widealpha.top:8080/shop/commodity/addCommodity',
        options: Options(
            headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
        queryParameters: {
          'title': title,
          'price': price,
          'description': description,
          'category': category,
          'image':imageUrl
        }).then((value) {
      addGoodsResponse = value;
      print(addGoodsResponse);
      if (addGoodsResponse.data['code'] == 0) {
        Toast.show("商品发布成功", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else if (addGoodsResponse.data['code'] == -6) {
        Toast.show("登陆状态错误", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }  else if (addGoodsResponse.data['code'] == -8) {
        Toast.show("Token无效", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        Toast.show("未知错误", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
