import 'package:flutter/material.dart';

class AddGoods extends StatelessWidget {
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
          title: Text('发布新商品'),
        ),
        body: AddGoodsPage(),
      );
  }
}

class AddGoodsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              style: TextStyle(
                  fontSize: 20
              ),
                decoration: InputDecoration(
                  labelText: '商品标题',
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(8),
                ),
               )
        ),

        Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                  fontSize: 20
              ),
              decoration: InputDecoration(
                labelText: '商品价格',
                border: OutlineInputBorder(borderSide: BorderSide()),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(8),
              ),
            )
        ),

        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              '商品简介:',
              style: TextStyle(
                  fontSize: 22
              ),
            ) ,
          ),
        ),

         //商品简介(自动换行):
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextField(
              maxLines: null,
              style: TextStyle(
                fontSize: 20
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(8),
              ),
            ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                  fontSize: 20
              ),
              decoration: InputDecoration(
                labelText: '留一下联系方式吧',
                border: OutlineInputBorder(borderSide: BorderSide()),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(8),
              ),
            )
        ),


      ],
    );
  }
}