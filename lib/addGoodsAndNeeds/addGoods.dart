import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:winter/test.dart';

class AddGoods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: AddGoodsPage(),
      );
  }
}
class AddGoodsPage extends StatefulWidget{
  @override
  _AddGoodsPageState createState() => _AddGoodsPageState();
}

class _AddGoodsPageState extends State<AddGoodsPage> {

  var imageFile;
  bool imageCondition = false; //是否传入照片
  bool categoryCondition = false; //是否传入分类
  String category;

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
            ),
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
                contentPadding: EdgeInsets.all(8),
              ),
            )
        ),


        Row(
          children: [
            Expanded(
              child: Center(
                child: FlatButton(
                  // color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(
                            Icons.add_a_photo_outlined, size: 30, color: Colors
                              .lightBlue,),
                        ),
                        Container(
                          child: Column(
                     children: [
                       Text('添加图片',
                         style: TextStyle(
                             fontSize: 20,
                             color: Colors.grey
                         ),
                       ),
                       imageCondition ? _imageUploaded() : _imageUnUploaded()
                               ],
                            )
                        )
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TestPage()));
                  },
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: FlatButton(
                  // color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(
                            Icons.add_box_outlined, size: 30, color: Colors
                              .lightBlue,),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text('选择分类',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey
                                ),
                              ),
                              categoryCondition ? _categoryChoosed() : _categoryUnChoosed()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.android),
                                title: Text("数码产品"),
                                onTap: () {
                                  categoryCondition=true;
                                  setState(() {
                                    category = '数码产品';
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.book),
                                title: Text("二手书"),
                                onTap: () {
                                  categoryCondition=true;
                                  setState(() {
                                    category = '二手书';
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.food_bank_outlined),
                                title: Text("食品"),
                                onTap: () {
                                  categoryCondition=true;
                                  setState(() {
                                    category = '食品';
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.accessibility_new),
                                title: Text("生活用品"),
                                onTap: () {
                                  categoryCondition=true;
                                  setState(() {
                                    category = '生活用品';
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.auto_fix_high),
                                title: Text("美妆"),
                                onTap: () {
                                  categoryCondition=true;
                                  setState(() {
                                    category = '美妆';
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.assessment_outlined),
                                title: Text("其他"),
                                onTap: () {
                                  categoryCondition=true;
                                  setState(() {
                                    category = '其他';
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ],
                          );
                        }
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     Container(
        //         margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
        //         child: imageCondition ? _imageUploaded() : _imageUnUploaded()
        //     ),
        //     Container(
        //         margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
        //         child: categoryCondition
        //             ? _categoryChoosed()
        //             : _categoryUnChoosed()
        //     )
        //   ],
        // ),

        Center(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              child: Icon(Icons.assignment_turned_in_rounded, size: 28,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _imageUploaded() {
    return Text(
        '图片已上传',
        style: TextStyle(
            fontSize: 20,
            color: Colors.indigoAccent
        ),
      );
  }

  Widget _imageUnUploaded() {
    return Text(
        '图片未上传',
        style: TextStyle(
            fontSize: 20,
            color: Colors.indigoAccent
        ),
    );
  }

  Widget _categoryChoosed() {
    return Text(
        '所选分类：$category',
        style: TextStyle(
            fontSize: 20,
            color: Colors.indigoAccent
        ),
    );
  }

  Widget _categoryUnChoosed() {
    return Text(
        '未选择分类',
        style: TextStyle(
            fontSize: 20,
            color: Colors.indigoAccent
        ),
    );
  }
}
