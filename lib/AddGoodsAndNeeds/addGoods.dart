import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
//ByteData这里需要引入dart:typed_data文件，引入service.dart的话app里可以检索到文件个数，但是传递到后台一直是null，时间紧迫我也没抓包看是咋回事儿先这么用吧
import 'dart:typed_data';
import 'package:dio/dio.dart';
//MediaType用
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:winter/Basic/login.dart';
import 'package:winter/GoodsTypePage/allGoods.dart';
import 'package:winter/tradeInfo.dart';
import 'package:winter/Basic/home.dart';

class AddGoods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddGoodsPage(),
    );
  }
}

class AddGoodsPage extends StatefulWidget {
  final arguments;

  AddGoodsPage({Key key, this.arguments}) : super(key: key);

  _AddGoodsPageState createState() => _AddGoodsPageState(this.arguments);
}

class _AddGoodsPageState extends State<AddGoodsPage> {
  bool _categoryCondition = false; //是否传入分类
  String _category;
  double _price;
  TextEditingController _title = TextEditingController();
  TextEditingController _myPrice = TextEditingController();
  TextEditingController _description = TextEditingController();

  // GlobalKey<FormState> addGoodsKey = new GlobalKey<FormState>();
  var titleKey = GlobalKey<FormFieldState>();
  var priceKey = GlobalKey<FormFieldState>();

  final arguments;
  _AddGoodsPageState(this.arguments);

  //上传图片用
  ScrollController _imgController = new ScrollController();
  List<Asset> _img = new List<Asset>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title.text='';
    _myPrice.text='';
    _description.text='';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        //标题&价格
        Card(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              //标题
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 20, 5),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '商品标题',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                      key: titleKey,
                      controller: _title,
                      style: TextStyle(fontSize: 15),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "起个标题啊拜托";
                        }
                        return null;
                      },
                    )),
                  ],
                ),
              ),
              //价格
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 20, 5),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        '商品价格',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      key: priceKey,
                      controller: _myPrice,
                      style: TextStyle(fontSize: 15),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "价格不可为空哦";
                        }else if(double.parse(_myPrice.text)<0){
                          return '价格不可为负哦';
                        }
                        return null;
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        //商品简介(自动换行):
        Card(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    '商品简介（可为空嗷）:',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 20, 10),
                child: TextField(
                  controller: _description,
                  maxLines: null,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
            ],
          ),
        ),

        //分类
        Card(
          margin: EdgeInsets.only(top: 10),
          child: FlatButton(
            // color: Colors.white,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 20, 10, 20),
              child: Row(
                children: [
                  Container(
                      child: Row(
                    children: [
                      Icon(
                        Icons.add_box_outlined,
                        size: 30,
                        color: Colors.lightBlue,
                      ),
                      Text(
                        '   选择分类',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ],
                  )),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: _categoryCondition
                          ? _categoryChoosed()
                          : _categoryUnChoosed(),
                    ),
                  ),
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
                            _categoryCondition = true;
                            setState(() {
                              _category = '数码产品';
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.book),
                          title: Text("二手书"),
                          onTap: () {
                            _categoryCondition = true;
                            setState(() {
                              _category = '二手书';
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.food_bank_outlined),
                          title: Text("食品"),
                          onTap: () {
                            _categoryCondition = true;
                            setState(() {
                              _category = '食品';
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.accessibility_new),
                          title: Text("生活用品"),
                          onTap: () {
                            _categoryCondition = true;
                            setState(() {
                              _category = '生活用品';
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.auto_fix_high),
                          title: Text("美妆"),
                          onTap: () {
                            _categoryCondition = true;
                            setState(() {
                              _category = '美妆';
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.assessment_outlined),
                          title: Text("其他"),
                          onTap: () {
                            _categoryCondition = true;
                            setState(() {
                              _category = '其他';
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ),

        //添加图片
        Card(
          margin: EdgeInsets.only(top: 10),
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      this._img == null
                          ? Expanded(
                              flex: 1,
                              child: Text(""),
                            )
                          : Expanded(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: ListView.builder(
                                  controller: _imgController,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: this._img.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          border: Border.all(
                                            style: BorderStyle.solid,
                                            color: Colors.black26,
                                          )),
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
                              )),
                          child: Center(
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        onTap: _openGallerySystem,
                      )
                    ],
                  ),
                ],
              )),
        ),
        //提交 按钮
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.assignment_turned_in_rounded,
                size: 28,
              ),
              onPressed: () async {
                if (_categoryCondition == false) {
                  Toast.show("选择分类啊喂", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                } else {
                  if (titleKey.currentState.validate() &&
                      priceKey.currentState.validate()) {
                    String _imageUrl;
                    _submitImages().then((value) {
                      _imageUrl=value;
                    });
                    _submitDetails(_title.text, double.parse(_myPrice.text),
                        _description.text, _category,_imageUrl);
                    //Navigator.of(context).pop(1);
                    AllGoods().createElement();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => new MyHomePage()), (route) => false);
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  //分类状态
  Widget _categoryChoosed() {
    return Text(
      '所选分类：$_category',
      style: TextStyle(fontSize: 17, color: Colors.grey),
    );
  }

  Widget _categoryUnChoosed() {
    return Text(
      '未选择分类',
      style: TextStyle(fontSize: 20, color: Colors.grey),
    );
  }

  //选择文件上传
  void _openGallerySystem() async {
    List<Asset> resultList = List<Asset>();
    resultList = await MultiImagePicker.pickImages(
      //最多选择几张照片
      maxImages: 9,
      //是否可以拍照
      enableCamera: true,
      selectedAssets: _img,
      materialOptions: MaterialOptions(
          startInAllView: true,
          allViewTitle: '所有照片',
          actionBarColor: '#2196F3',
          //未选择图片时提示
          textOnNothingSelected: '没有选择照片',
          //选择图片超过限制弹出提示
          selectionLimitReachedText: "最多选择9张照片"),
    );
    if (!mounted) return;
    setState(() {
      _img = resultList;
    });
  }

  //提交数据
  Future<String> _submitImages() async {
    List<String> imageList=List();
    //处理图片
    // List<MultipartFile> imageList = new List<MultipartFile>();
    for (Asset asset in _img) {
      //将图片转为二进制数据
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = new MultipartFile.fromBytes(
        imageData,
        //这个字段要有，否则后端接收为null
        filename: 'load_image',
        // //请求contentType，设置一下，不设置的话默认的是application/octet/stream，后台可以接收到数据，但上传后是.octet-stream文件
        contentType: MediaType("image", "jpg"),
      );
      Response addImagesResponse = await Dio().post(
        'http://widealpha.top:8080/treehole/article/uploadImage',
        options: Options(
            headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
        queryParameters: {
          "image": multipartFile
        },
      );
      print('商品图片:$addImagesResponse');
      if (addImagesResponse.data['code'] == 0) {
        imageList.add(addImagesResponse.data['data']);
      } else {
      }
    }
    print('图片列表： ${imageList.toString()}');
    return imageList.toString();
  }

  void _submitDetails(String title, double price, String description, String category,String imageUrl) {
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
