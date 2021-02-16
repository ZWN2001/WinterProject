import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/cropImage.dart';
import 'package:winter/Basic/login.dart';
import 'package:winter/Mine/PersonalInfo/userInfo.dart';

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

class myInfo extends StatefulWidget{
  @override
  myInfoState createState() => myInfoState();
}
class myInfoState extends State<myInfo> {
  // TextEditingController _age = TextEditingController();
  // TextEditingController _location = TextEditingController();
  // TextEditingController _introduction = TextEditingController();
  // TextEditingController _sex = TextEditingController();
  // TextEditingController _name = TextEditingController();
  UserInfo _userInfo;
  String _headImageUrl;
  int _age;
  String _location;
  String _introduction;
  int _sex;
  String _name;
  String _username;

  Future<UserInfo> _getInfo(BuildContext context) async {
    Response response=await  Dio().post('http://widealpha.top:8080/shop/user/userInfo',
      options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),);
    print(response);
    if (response.data['code'] == 0) {
      print('this userInfo:${response.data['data']}');
      return response.data['data'].map((e) =>UserInfo.fromJson(e));
    }  else if (response.data['code'] == -6) {
      Toast.show("登陆状态错误", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return null;
    } else if (response.data['code'] == -8) {
      Toast.show("Token无效", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return null;
    } else {
      Toast.show("未知错误", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return null;
    }
  }
  ///从相册选取
  Future _chooseImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return 0;
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CropImageRoute(image)));;
    }
    setState(() {
      initState();//TODO 此处应该是局部更新
    });
  }

  @override
  void initState() {
    super.initState();
    _getInfo(context).then((value) {
      _userInfo=value;
    });
    _getHeadImage(context).then((value){
      print(value);
      _headImageUrl=value;
    });
    //TODO :INIT
    _age=_userInfo.age;
  }
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Card(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              //头像
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
                          child: GestureDetector(
                            onTap: _chooseImage,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(30, 8, 8, 8),
                              child: ClipOval(
                                  child: _headImageUrl == null
                                      ? Image.asset(
                                    'images/defaultHeadImage.png',
                                    color: Colors.white,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.network(
                                    _headImageUrl,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              //用户名
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
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: _username,
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                  affinity: TextAffinity.downstream,
                                  offset:  _username== null ? 0 : _username.length,
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _username= value;
                          },
                          style: TextStyle(
                              fontSize: 20
                          ),
                        )
                    ),
                  ],
                ),
              ),
              //姓名
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
                          // controller: _name,
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: _name,
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                  affinity: TextAffinity.downstream,
                                  offset: _name == null ? 0 : _name.length,
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _name = value;
                          },
                          style: TextStyle(
                              fontSize: 20
                          ),
                        )
                    ),
                  ],
                ),
              ),
              //性别
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
                          // controller: _sex,
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: '$_sex',
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                  affinity: TextAffinity.downstream,
                                  offset: _sex == null ? 0 : _sex.toString().length,
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _sex = int.parse(value);
                          },
                          style: TextStyle(
                              fontSize: 20
                          ),
                        )
                    ),
                  ],
                ),
              ),
              //年龄
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
                          // controller: _age,
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: '$_age',
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                  affinity: TextAffinity.downstream,
                                  offset: _age == null ? 0 : _age.toString().length,
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _age = int.parse(value);
                          },
                          style: TextStyle(
                              fontSize: 20
                          ),
                        )
                    ),
                  ],
                ),
              ),
              //现居
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
                          // controller: _location,
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: _location,
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                  affinity: TextAffinity.downstream,
                                  offset: _location == null ? 0 : _location.length,
                                ),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _location = value;
                          },
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
        //自我介绍
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
                      // controller: _introduction,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _introduction,
                          selection: TextSelection.fromPosition(
                            TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _introduction == null ? 0 : _introduction.length,
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        _introduction = value;
                      },
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
                _submitDetails(_headImageUrl, _age, _introduction, _sex, _name, _location, _username);
              },
            ),
          ),
        ),
      ],
    );
  }
  void _submitDetails(String headImageUrl, int age, String introduction, int sex,String name,String location,String username) {
    Response addGoodsResponse;
    Dio().post('http://widealpha.top:8080/shop/user/changeUserInfo',
        options: Options(
            headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
        queryParameters: {
          'headImage':headImageUrl,
          'age':age,
          'introduction':introduction,
          'sex':sex,
          'name':name,
          'location':location,
          'username':username
        }).then((value) {
      addGoodsResponse = value;
      print(addGoodsResponse);
      if (addGoodsResponse.data['code'] == 0) {
        Toast.show("个人信息修改成功", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Navigator.pop(context);
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
  Future<String> _getHeadImage(BuildContext context) async {
    Response response=await Dio().post(
      'http://widealpha.top:8080/shop/user/headImage',
      options:
      Options(headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
    );
    print('头像：$response');
    if (response.data['code'] == 0) {
      return response.data['data'];
    } else{
      return null;
    }
  }
}
