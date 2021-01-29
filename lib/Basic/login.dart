import 'package:flutter/material.dart';
import 'package:winter/AdapterAndHelper/myHttpClient.dart';
import 'package:winter/AdapterAndHelper/user.dart';
import 'package:winter/Basic/register.dart';
import 'package:winter/SharedPreference/sharedPreferenceUtil.dart';


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  MyHttpClient myHttpClient = MyHttpClient();
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>(); //全局key
  var accountKey = GlobalKey<FormFieldState>();
  var pwdKey = GlobalKey<FormFieldState>();
  // final userNameController=TextEditingController();
  // final pwdController =TextEditingController();
  static String account = ""; //账号
  String _passWord = ""; //密码
  bool pwdShow = true; //默认不展示密码
  bool _expand = false; //是否展示历史账号
  List<User> _users = List(); //历史账号

  static bool logged=false;//登录状态

  @override
  void initState() {
    super.initState();
    _gainUsers();
  }

  //获取历史用户
  void _gainUsers() async {
    _users.clear();
    _users.addAll(await SharedPreferenceUtil.getUsers());
    //默认加载第一个账号
    if (_users.length > 0) {
      account = _users[0].account;
      _passWord = _users[0].password;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('欢迎登录'),
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: Container(
                  child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  new Container(
                      padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 25.0),
                      child: Image.asset('images/appIcon.png')),
                  _buildUsername(),
                  _buildPassword(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLoginButton(),
                      _buildAddAccount()
                    ],
                  ),
                ],
              )),
            ),
            Offstage(
              child: _buildListView(),
              offstage: !_expand,
            ),
          ],
        ),
    );
  }

  //构建账号输入框
  Widget _buildUsername() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: TextFormField(
        key: accountKey,
        decoration: InputDecoration(
          hintText: '请输入账号/学号',
          // border: OutlineInputBorder(borderSide: BorderSide()),
          contentPadding: EdgeInsets.all(8),
          fillColor: Colors.white38,
          filled: true,
          prefixIcon: Icon(Icons.person),
          suffixIcon: GestureDetector(
              onTap: () {
                if (_users.length > 1 ||
                    _users[0] != User(account, _passWord)) {
                  //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
                  setState(() {
                    _expand = !_expand;
                  });
                }
              },
              child: _expand
                  ? Icon(
                      Icons.arrow_drop_up,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    )),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "用户名不可为空";
          }
          return null;
        },
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: account,
            selection: TextSelection.fromPosition(
              TextPosition(
                affinity: TextAffinity.downstream,
                offset: account == null ? 0 : account.length,
              ),
            ),
          ),
        ),
        onChanged: (value) {
          account = value;
        },
      ),
    );
  }

  //构建密码输入框
  Widget _buildPassword() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextFormField(
        key: pwdKey,
        decoration: InputDecoration(
          hintText: '请输入密码',
          suffixIcon: IconButton(
            icon: Icon(pwdShow ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                pwdShow = !pwdShow;
              });
            },
          ),
          // border: OutlineInputBorder(borderSide: BorderSide()),
          fillColor: Colors.white38,
          filled: true,
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.all(8),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "密码不可为空";
          }
          return null;
        },
        obscureText: pwdShow,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: _passWord,
            selection: TextSelection.fromPosition(
              TextPosition(
                affinity: TextAffinity.downstream,
                offset: _passWord == null ? 0 : _passWord.length,
              ),
            ),
          ),
        ),
        onChanged: (value) {
          _passWord = value;
        },
      ),
    );
  }

//  登录按钮
  Widget _buildLoginButton(){
    return  Container(
      margin: EdgeInsets.fromLTRB(0, 30, 15.0, 0),
      child:  FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
        onPressed: (){
          if(accountKey.currentState.validate()&&pwdKey.currentState.validate()) {
            // myHttpClient.sendHttpRequest('http://106.15.192.117:8080/shop/login?userName='+userName+'?password='+_passWord);
            // if(myHttpClient.data==)
            //
            SharedPreferenceUtil.saveUser(User(account, _passWord));
            logged=true;
            Navigator.of(context).pushNamedAndRemoveUntil('MyHomePage', (Route<dynamic> route) => false);
          }
        },
        child: Text(
          '登录',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
  //注册按钮
  Widget _buildAddAccount() {
    return Container(
      margin: EdgeInsets.fromLTRB(15.0, 30, 0.0, 0),
      child: new FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Register(), maintainState: false));
        },
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
    );
  }

  //构建历史账号ListView
  Widget _buildListView() {
    if (_expand) {
      List<Widget> children = _buildItems();
      if (children.length > 0) {
        RenderBox renderObject = accountKey.currentContext.findRenderObject();
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

  //构建历史记录items
  List<Widget> _buildItems() {
    List<Widget> list2 = List();
    for (int i = 0; i < _users.length; i++) {
      if (_users[i] != User(account, _passWord)) {
        //增加账号记录
        list2.add(_buildItem(_users[i]));
        //增加分割线
        list2.add(Divider(
          color: Colors.grey,
          height: 1,
        ));
      }
    }
    if (list2.length > 0) {
      list2.removeLast(); //删掉最后一个分割线
    }
    return list2;
  }

  //构建单个历史记录item
  Widget _buildItem(User user) {
    return GestureDetector(
      child: Container(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(user.account),
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
                  _users.remove(user);
                  SharedPreferenceUtil.delUser(user);
                  //处理最后一个数据，假如最后一个被删掉，将Expand置为false
                  if (!(_users.length > 1 ||
                      _users[0] != User(account, _passWord))) {
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
          account = user.account;
          _passWord = user.password;
          _expand = false;
        });
      },
    );
  }
}
