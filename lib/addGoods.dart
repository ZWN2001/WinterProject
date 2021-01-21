import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  var imageFile;

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


         Row(
           children: [
             Expanded(
                 child:  Center(
                   child: FlatButton(
                     // color: Colors.white,
                     child:Container(
                       margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                       child:Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Container(
                             child: Icon(Icons.add_a_photo_outlined,size: 30,color: Colors.lightBlue,),
                           ),
                           Container(
                             child: Text('添加图片',
                               style: TextStyle(
                                   fontSize: 20,
                                   color: Colors.grey
                               ),
                             ),
                           )
                         ],
                       ),
                     ),
                     onPressed:(){
                       showModalBottomSheet(
                           context: context,
                           builder: (BuildContext context){
                             return new Column(
                               mainAxisSize: MainAxisSize.min,
                               children: <Widget>[
                                 new ListTile(
                                   leading: new Icon(Icons.photo_camera),
                                   title: new Text("拍照"),
                                   onTap: () async {
                                     imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
                                     Navigator.pop(context);
                                   },
                                 ),
                                 new ListTile(
                                   leading: new Icon(Icons.photo_library),
                                   title: new Text("从图库选择"),
                                   onTap: () async {
                                     imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                                     Navigator.pop(context);
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

             Expanded(
               child:  Center(
                 child: FlatButton(
                   // color: Colors.white,
                   child:Container(
                     margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                     child:Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Container(
                           child: Icon(Icons.add_box_outlined,size: 30,color: Colors.lightBlue,),
                         ),
                         Container(
                           child: Text('选择分类',
                             style: TextStyle(
                                 fontSize: 20,
                                 color: Colors.grey
                             ),
                           ),
                         )
                       ],
                     ),
                   ),
                   onPressed:(){
                     showModalBottomSheet(
                         context: context,
                         builder: (BuildContext context){
                           return  Column(
                             mainAxisSize: MainAxisSize.min,
                             children: <Widget>[
                                ListTile(
                                 leading:  Icon(Icons.photo_camera),
                                 title:  Text("数码产品"),
                                 onTap: ()  {
                                   Navigator.pop(context);
                                 },
                               ),
                                ListTile(
                                 leading:  Icon(Icons.photo_library),
                                 title:  Text("二手书"),
                                 onTap: ()  {
                                   Navigator.pop(context);
                                 },
                               ),
                               ListTile(
                                 leading:  Icon(Icons.photo_library),
                                 title:  Text("食品"),
                                 onTap: () {
                                   Navigator.pop(context);
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

        Center(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: FloatingActionButton(
            backgroundColor: Colors.lightBlue,
            child: Icon(Icons.assignment_turned_in_rounded,size: 28,),
              onPressed: (){

              },
          ),
        ),
        )


      ],
    );
  }
}
