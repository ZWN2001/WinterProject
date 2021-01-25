import 'package:flutter/material.dart';
import 'dart:io';
//ByteData这里需要引入dart:typed_data文件，引入service.dart的话app里可以检索到文件个数，但是传递到后台一直是null，时间紧迫我也没抓包看是咋回事儿先这么用吧
import 'dart:typed_data';
import 'package:dio/dio.dart';
//MediaType用
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class TestPage extends StatefulWidget {
  final arguments;
  TestPage({Key key, this.arguments}) : super(key : key);
  _TestPageState createState() => _TestPageState(this.arguments);
}

class _TestPageState extends State<TestPage> {
  final arguments;
  _TestPageState(this.arguments);
  //上传图片用
  ScrollController _imgController = new ScrollController();
  List<Asset> _img = new List<Asset>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.keyboard_return),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        title: Text("上传照片"),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  this._img == null ? Expanded(
                    flex: 1,
                    child: Text(""),
                  ) : Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: ListView.builder(
                        controller: _imgController,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: this._img.length,
                        itemBuilder: (context, index){
                          return Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Colors.black26,
                                )
                            ),
                            child: AssetThumb(
                              asset: this._img[index],
                              width: 50,
                              height: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Colors.black26,
                          )
                      ),
                      child: Center(
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                    onTap: _openGallerySystem ,
                  )
                ],
              ),
              Container(
                width: double.infinity,
                height: 60,
                child: RaisedButton(
                  child: Text(
                    "提交",
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                  onPressed: () {
                    _submitData();
                  },
                ),
              ),
            ],
          )
      ),
    );
  }

  //选择文件上传
  void _openGallerySystem () async {
    List<Asset> resultList = List<Asset>();
    resultList = await MultiImagePicker.pickImages(
      //最多选择几张照片
      maxImages: 9,
      //是否可以拍照
      enableCamera: true,
      selectedAssets: _img,
      materialOptions:MaterialOptions(
          startInAllView:true,
          allViewTitle:'所有照片',
          actionBarColor:'#2196F3',
          //未选择图片时提示
          textOnNothingSelected:'没有选择照片',
          //选择图片超过限制弹出提示
          selectionLimitReachedText: "最多选择9张照片"
      ),
    );
    if (!mounted) return;
    setState(() {
      _img = resultList;
    });
  }

  //提交数据
  void _submitData () async {
    //处理图片
    List<MultipartFile> imageList = new List<MultipartFile>();
    for (Asset asset in _img) {
      //将图片转为二进制数据
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = new MultipartFile.fromBytes(
        imageData,
        //这个字段要有，否则后端接收为null
        filename: 'load_image',
        //请求contentType，设置一下，不设置的话默认的是application/octet/stream，后台可以接收到数据，但上传后是.octet-stream文件
        contentType: MediaType("image", "jpg"),
      );
      imageList.add(multipartFile);
    }

    FormData formData = new FormData.fromMap({
      //后端要用multipartFiles接收参数，否则为null
      "multipartFiles" : imageList
    });
    var res = await Dio().post("URL", data: formData);
  }
}