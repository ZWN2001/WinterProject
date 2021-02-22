import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:winter/AdapterAndHelper/headImage.dart';
import 'package:winter/AdapterAndHelper/picker_text.dart';
import 'package:winter/Basic/login.dart';
import 'package:winter/Mine/PersonalInfo/userInfo.dart';
import 'package:winter/AdapterAndHelper/getUsername.dart';

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
  TextEditingController _ageController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  // TextEditingController _introduction = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  // TextEditingController _name = TextEditingController();
  UserInfo _userInfo=UserInfo(LoginPageState.account, '', 0, '', '', 0, '');
  String _headImageUrl;
  int _age;
  String _location;
  String _introduction;
  int _sex;
  String _name;
  String _username;
  String selectSex = '男';

  Future _getInfo(BuildContext context) async {
    Response response=await  Dio().post('http://widealpha.top:8080/shop/user/userInfo',
      options: Options(headers:{'Authorization':'Bearer '+LoginPageState.token}),);
    if (response.data['code'] == 0) {
      print('this userInfo:${response.data['data']}');
      return UserInfo.fromJson(response.data['data']);
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

  @override
  void initState() {
    super.initState();
    _getInfo(context).then((value) {
      if(mounted) {
        setState(() {
          _userInfo = value;
          _headImageUrl=_userInfo.headImage;
          _age=_userInfo.age;
          _location=_userInfo.location;
          _introduction=_userInfo.introduction;
          _sex=_userInfo.sex;
          switch(_sex){
            case 1:
              selectSex='男';
              break;
            case 0:
              selectSex='女';
              break;
            default:
              selectSex='不限';
          }

        });
      }
    });
    getUserName.getUsername(context).then((value) {
      if(mounted) {
        setState(() {
          _username=value;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    print('building.........');
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
                      child:Container(
                        child:ChangeNotifierProvider<HeadImage>(
                          create: (_) => HeadImage(),
                          builder: (myContext, child) {
                            return GestureDetector(
                                onTap:(){  HeadImage.chooseImage(context);
                                myContext.read<HeadImage>().refresh();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 30),
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: ClipOval(
                                        child:
                                        _userInfo.headImage?.toString()==null ?
                                        Image.asset(
                                          'images/defaultHeadImage.png',
                                          color: Colors.black,
                                          fit: BoxFit.cover,
                                        )
                                            : Image.network(
                                          _userInfo.headImage?.toString(),
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                  ),
                                )
                            );
                          },),
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
                        '用户名:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 40,left: 25),
                          child: TextFormField(
                            textAlign: TextAlign.right,
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: _username??' ',
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
                        '姓名:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 40,left: 45),
                          child: TextFormField(
                            textAlign: TextAlign.right,
                            scrollPadding: EdgeInsets.all(0),
                            decoration: InputDecoration(
                                helperText: '您的真实姓名'
                            ),
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: _name??'无',
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
                        '性别:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 30,left: 45),
                          alignment: Alignment.center,
                          child: _item( PickerDataType.sex, selectSex),
                          // child: TextFormField(
                          //   scrollPadding: EdgeInsets.all(0),
                            // controller: _sex,
                            // controller: TextEditingController.fromValue(
                            //   TextEditingValue(
                            //     text: '$_sex',
                            //     selection: TextSelection.fromPosition(
                            //       TextPosition(
                            //         affinity: TextAffinity.downstream,
                            //         offset: _sex == null ? 0 : _sex.toString().length,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // onChanged: (value) {
                            //   _sex = int.parse(value);
                            // },

                          //   style: TextStyle(
                          //       fontSize: 20
                          //   ),
                          // ),
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
                        '年龄:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 30,left: 45),
                          alignment: Alignment.centerRight,
                          child: _item( List.generate(200, (index) => (0 + index).toString()), _age??0, label: '岁'),
                          // child: TextFormField(
                          //   scrollPadding: EdgeInsets.all(0),
                            // controller: _age,
                            // controller: TextEditingController.fromValue(
                            //   TextEditingValue(
                            //     text: '$_age',
                            //     selection: TextSelection.fromPosition(
                            //       TextPosition(
                            //         affinity: TextAffinity.downstream,
                            //         offset: _age == null ? 0 : _age.toString().length,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // onChanged: (value) {
                            //   _age = int.parse(value);
                            // },
                          //   style: TextStyle(
                          //       fontSize: 20
                          //   ),
                          // ),
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
                        '现居:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 30,left: 45,top: 10,bottom: 10),
                          alignment: Alignment.center,
                          child: _checkLocation(),
                          // child: TextFormField(
                          //   scrollPadding: EdgeInsets.all(0),
                          //   decoration: InputDecoration(
                          //       hintText: '选择现居地'
                          //   ),
                          //   initialValue: _userInfo.location,
                          //   // controller: _location,

                            // controller: TextEditingController.fromValue(
                            //   TextEditingValue(
                            //     text: _location??'',
                            //     selection: TextSelection.fromPosition(
                            //       TextPosition(
                            //         affinity: TextAffinity.downstream,
                            //         offset: _location == null ? 0 : _location.length,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // onChanged: (value) {
                            //   _location = value;
                            // },

                          //   style: TextStyle(
                          //       fontSize: 20
                          //   ),
                          // ),
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
                    child: Container(
                      margin: EdgeInsets.only(right: 30),
                      child: TextFormField(
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                          helperText: '可添加自我介绍'
                        ),
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: _introduction??' ',
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
                HeadImage.getHeadImage(context).then((value) {
                  _headImageUrl=value;
                });
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
    // try {
      Dio().post('http://widealpha.top:8080/shop/user/changeUserInfo',
          options: Options(
              headers: {'Authorization': 'Bearer ' + LoginPageState.token}),
          queryParameters: {
            'headImage': headImageUrl,
            'age': age,
            'introduction': introduction,
            'sex': sex,
            'name': name,
            'location': location,
            'username': username
          }).then((value) {
        addGoodsResponse = value;
        print(addGoodsResponse);
        if (addGoodsResponse.data['code'] == 0) {
          Toast.show("个人信息修改成功", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          Navigator.pushReplacementNamed(context, 'showInfo');
          // setState(() {});无效
        } else if (addGoodsResponse.data['code'] == -6) {
          Toast.show("登陆状态错误", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        } else if (addGoodsResponse.data['code'] == -8) {
          Toast.show("Token无效", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        } else {
          Toast.show("未知错误", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      });
    // }
//     on DioError catch (e) {
// // //      LogUtils.print_('请求出错：' + e.toString());
// //       final NetError netError = ExceptionHandle.handleException(e);
// //       _onError(netError.code, netError.msg, fail);
// //     }
  }
  //location
  Widget _checkLocation() {
    List locations;
    if(_location==null){
      locations = ['山东省', '济南市', '历下区'];
    }else{
      String p=_location.substring(0,3);
      String c=_location.substring(6,9);
      String t=_location.substring(12,15);
      locations = [p,c,t];
    }
     locations = ['山东省', '济南市', '历下区'];
    double menuHeight = 36.0;
    Widget _headMenuView = Container(
        color: Colors.grey[700],
        height: menuHeight,
        child: Row(children: [
          Expanded(child: Center(child: MyText('省', color: Colors.white))),
          Expanded(child: Center(child: MyText('市', color: Colors.white))),
          Expanded(child: Center(child: MyText('区', color: Colors.white))),
        ]));

    Widget _cancelButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(left: 22),
      decoration:
      BoxDecoration(border: Border.all(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(4)),
      child: MyText('取消', color: Colors.white, size: 14),
    );

    Widget _commitButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(right: 22),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(4)),
      child: MyText('确认', color: Colors.white, size: 14),
    );

    // 头部样式
    Decoration addressHeadDecoration = BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)));

    Widget addressTitle = Center(child: MyText('请选择地址', color: Colors.white, size: 14));

    var pickerStyle = PickerStyle(
      menu: _headMenuView,
      menuHeight: menuHeight,
      cancelButton: _cancelButton,
      commitButton: _commitButton,
      headDecoration: addressHeadDecoration,
      title: addressTitle,
      textColor: Colors.white,
      backgroundColor: Colors.grey[800],
    );

    return InkWell(
      onTap: () {
        Pickers.showAddressPicker(
          context,
          initProvince: locations[0],
          initCity: locations[1],
          initTown: locations[2],

          pickerStyle : pickerStyle,

          addAllItem: false,
          onConfirm: (p, c, t) {
            setState(() {
              locations[0] = p;
              locations[1] = c;
              locations[2] = t;
            });
          },
        );
      },
      child: Text(spliceCityName(pname: locations[0], cname: locations[1], tname: locations[2]),
          style: TextStyle(fontSize: 18)),
    );
  }

  // 拼接城市
  String spliceCityName({String pname, String cname, String tname}) {
    if (strEmpty(pname)) return '不限';
    StringBuffer sb = StringBuffer();
    sb.write(pname);
    if (strEmpty(cname)) return sb.toString();
    sb.write(' - ');
    sb.write(cname);
    if (strEmpty(tname)) return sb.toString();
    sb.write(' - ');
    sb.write(tname);
    _location=sb.toString();
    return sb.toString();
  }
  /// 字符串为空
  bool strEmpty(String value) {
    if (value == null) return true;
    return value.trim().isEmpty;
  }

  Widget _item( var data, var selectData, {String label}) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: ListTile(
            onTap: () => _onClickItem(data, selectData, label: label),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              MyText(selectData.toString() ?? '暂无', color: Colors.black, rightpadding: 0,size: 20,),
            ]),
          ),
        ),
      ],
    );
  }

  void _onClickItem(var data, var selectData, {String label}) {
    Pickers.showSinglePicker(
      context,
      data: data,
      selectData: selectData,
      pickerStyle: DefaultPickerStyle(),
      suffix: label,
      onConfirm: (p) {
        print('longer >>> 返回数据：$p');
        print('longer >>> 返回数据类型：${p.runtimeType}');
        setState(() {
          if (data == PickerDataType.sex) {
            selectSex = p;
            switch(selectSex) {
              case '男':
                _sex=1;
                break;
              default:
                _sex=0;
                break;
            }
          }else{
            _age=int.parse(p);
          }
        });
      },
    );
  }
}
