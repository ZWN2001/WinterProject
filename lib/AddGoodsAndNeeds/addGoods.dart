import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
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
  bool _imageCondition = false; //是否传入照片
  bool _categoryCondition = false; //是否传入分类
  String category;
  TextEditingController _title=TextEditingController();
  TextEditingController _price=TextEditingController();
  TextEditingController _description=TextEditingController();
  TextEditingController _contact=TextEditingController();

  GlobalKey<FormState> addGoodsKey = new GlobalKey<FormState>();
  var titleKey = GlobalKey<FormFieldState>();
  var priceKey = GlobalKey<FormFieldState>();
  var contactKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              key: titleKey,
              controller: _title,
              style: TextStyle(
                  fontSize: 20
              ),
              decoration: InputDecoration(
                labelText: '商品标题',
                border: OutlineInputBorder(borderSide: BorderSide()),
                contentPadding: EdgeInsets.all(8),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "起个标题啊拜托";
                }
                return null;
              },
            )
        ),

        Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              key: priceKey,
              controller: _price,
              style: TextStyle(
                  fontSize: 20
              ),
              decoration: InputDecoration(
                labelText: '商品价格',
                border: OutlineInputBorder(borderSide: BorderSide()),
                contentPadding: EdgeInsets.all(8),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "价格不可为空哦";
                }
                return null;
              },
            )
        ),

        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              '商品简介（可为空）:',
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
            controller: _description,
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
              key: contactKey,
               controller: _contact,
              style: TextStyle(
                  fontSize: 20
              ),
              decoration: InputDecoration(
                labelText: '留一下联系方式吧',
                contentPadding: EdgeInsets.all(8),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "忘记留联系方式啦！";
                }
                return null;
              },
            )
        ),


        Row(
          children: [
            Expanded(
              child: Center(
                child: FlatButton(
                  // color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(
                            Icons.add_a_photo_outlined, size: 30, color: Colors.lightBlue,),
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
                       _imageCondition ? _imageUploaded() : _imageUnUploaded()
                               ],
                            )
                        )
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage()));
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
                              _categoryCondition ? _categoryChoosed() : _categoryUnChoosed()
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
                                  _categoryCondition=true;
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
                                  _categoryCondition=true;
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
                                  _categoryCondition=true;
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
                                  _categoryCondition=true;
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
                                  _categoryCondition=true;
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
                                  _categoryCondition=true;
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
                if(_categoryCondition==false){
                  Toast.show("选择分类啊喂", context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                }else{
                  if(titleKey.currentState.validate()&&priceKey.currentState.validate()&&contactKey.currentState.validate()){
                    Navigator.of(context).pop();
                  }
                }
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
            fontSize: 17,
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
