import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winter/Home.dart';
import 'package:winter/SharedPreference/SharedPreferenceUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SharedPreference/User.dart';

void main() => runApp(MaterialApp(home:LoginPage()));

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //全局key，用来获取form表单组件
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();

  TextEditingController _unameController = TextEditingController();

  String userName; //用户名
  String passWord; //密码
  bool pwdShow = false;//默认不展示密码
  bool _expand = false; //是否展示历史账号
  List<User> _users = new List(); //历史账号


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('欢迎登录'),
        ),

        body: Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 25.0),
              child: new Form(
                  key: loginKey,
                  child: Column(
                    children: <Widget>[
                      new Container(
                          child: Image.asset('images/appIcon.png')
                      ),

                      _buildUsername(),

                      // Container(
                      //     margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      //     child: new TextFormField(
                      //       controller: _unameController, //设置controller
                      //
                      //       // initialValue: getText(true),
                      //
                      //       decoration: new InputDecoration(
                      //         labelText: '请输入账号',
                      //         prefixIcon: Icon(Icons.person),
                      //       ),
                      //
                      //       onChanged: (value) {
                      //          userName=value  ;
                      //       },
                      //
                      //     ),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      //   child: new TextFormField(
                      //
                      //     // initialValue:getText(false),
                      //
                      //     decoration: new InputDecoration(
                      //         labelText: '请输入密码',
                      //         prefixIcon: Icon(Icons.lock),
                      //         suffixIcon: IconButton(
                      //           icon: Icon(
                      //               pwdShow ? Icons.visibility_off : Icons.visibility),
                      //           onPressed: () {
                      //             setState(() {
                      //               pwdShow = !pwdShow;
                      //             }
                      //             );
                      //           },
                      //         )
                      //     ),
                      //     obscureText:  pwdShow,
                      //
                      //     onChanged: (value){
                      //       passWord = value;
                      //     },
                      //
                      //   ),
                      // ),
                    ],
                  )),
            ),

            //按钮
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget> [
                new Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 15.0, 0),
                  child: new FlatButton(
                    onPressed: (){
                      login();
                      add();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
                    child: Text(
                      '登录',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 0, 0.0, 0),
                  child: new FlatButton(
                    onPressed: login,                            //need to change
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
                    child: Text(
                      '注册',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
  }


  ///构建账号输入框
  Widget _buildUsername() {
    return  Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child:
      TextField(
      key: loginKey,
      decoration: InputDecoration(
        labelText: '请输入账号',
        border: OutlineInputBorder(borderSide: BorderSide()),
        contentPadding: EdgeInsets.all(8),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.person),
        suffixIcon: GestureDetector(
          onTap: () {
            if (_users.length > 1 || _users[0] != User(userName, passWord)) {
              //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
              setState(() {
                _expand = !_expand;
              });
            }
          },
          child: _expand
              ? Icon(
            Icons.arrow_drop_up,
            color: Colors.red,
          )
              : Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
        ),
      ),
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: userName,
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream,
              offset: userName == null ? 0 : userName.length,
            ),
          ),
        ),
      ),
      onChanged: (value) {
        userName = value;
      },
      ),
    );
  }

  ///构建密码输入框
  Widget _buildPassword() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        decoration: InputDecoration(
          labelText: '请输入密码',
            suffixIcon: IconButton(
              icon: Icon(
                  pwdShow ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  pwdShow = !pwdShow;
                }
                );
              },
            ),
          border: OutlineInputBorder(borderSide: BorderSide()),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.all(8),
        ),
        obscureText:  pwdShow,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: passWord,
            selection: TextSelection.fromPosition(
              TextPosition(
                affinity: TextAffinity.downstream,
                offset: passWord == null ? 0 : passWord.length,
              ),
            ),
          ),
        ),
        onChanged: (value) {
          passWord = value;
        },
      ),
    );
  }





  ///构建历史账号ListView
  Widget _buildListView() {
    if (_expand) {
      List<Widget> children = _buildItems();
      if (children.length > 0) {
        RenderBox renderObject = loginKey.currentContext.findRenderObject();
        final position = renderObject.localToGlobal(Offset.zero);
        double screenW = MediaQuery.of(context).size.width;
        double currentW = renderObject.paintBounds.size.width;
        double currentH = renderObject.paintBounds.size.height;
        double margin = (screenW - currentW) / 2;
        double offsetY = position.dy;
        double itemHeight = 30.0;
        double dividerHeight = 2;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: ListView(
            itemExtent: itemHeight,
            padding: EdgeInsets.all(0),
            children: children,
          ),
          width: currentW,
          height: (children.length * itemHeight +
              (children.length - 1) * dividerHeight),
          margin: EdgeInsets.fromLTRB(margin, offsetY + currentH, margin, 0),
        );
      }
    }
    return null;
  }

  ///构建历史记录items
  List<Widget> _buildItems() {
    List<Widget> list = new List();
    for (int i = 0; i < _users.length; i++) {
      if (_users[i] != User(userName, passWord)) {
        //增加账号记录
        list.add(_buildItem(_users[i]));
        //增加分割线
        list.add(Divider(
          color: Colors.grey,
          height: 2,
        ));
      }
    }
    if (list.length > 0) {
      list.removeLast(); //删掉最后一个分割线
    }
    return list;
  }

  ///构建单个历史记录item
  Widget _buildItem(User user) {
    return GestureDetector(
      child: Container(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(user.username),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.highlight_off,
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  SharedPreferenceUtil.delUser(user);
                  _users.remove(user);
                  //处理最后一个数据，假如最后一个被删掉，将Expand置为false
                  if (!(_users.length > 1 ||
                      _users[0] != User(userName, passWord))) {
                    //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
                    _expand = false;
                  }
                });
              },
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          userName = user.username;
          passWord = user.password;
          _expand = false;
        });
      },
    );
  }
  //登录
  void login() {
    var loginForm = loginKey.currentState; //读取当前Form
    if (loginForm.validate()) {
      loginForm.save();

      //提交信息
      SharedPreferenceUtil.saveUser(User(userName, passWord));
      SharedPreferenceUtil.addNoRepeat(_users, User(userName,passWord));

      Navigator.push(context, MaterialPageRoute(builder: (context)=>new MyApp()));
    }
  }

  ///获取历史用户
  void _gainUsers() async {
    _users.clear();
    _users.addAll(await SharedPreferenceUtil.getUsers());
    //默认加载第一个账号
    if (_users.length > 0) {
      userName = _users[0].username;
      passWord = _users[0].password;
    }
  }
  void add() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userName', userName);
      prefs.setString('passWord', passWord);

  }
  // String getText(bool isAccount) async {
  //
  //   if(isAccount){
  //     return prefs.getString('userName');
  //   }else{
  //     return prefs.getString('passWord');
  //   }
  // }
}
