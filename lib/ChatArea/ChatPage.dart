import 'dart:async';
import 'package:winter/AdapterAndHelper/getOthersUsername.dart';
import 'package:winter/AdapterAndHelper/headImage.dart';
import 'package:winter/AdapterAndHelper/getOthersHeadImage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart'hide BuildConhtext;
import 'package:winter/AdapterAndHelper/bubble.dart';
import 'package:path/path.dart';
import 'package:winter/AdapterAndHelper/getUsername.dart';
import 'package:winter/Basic/login.dart';


class ChatPage extends StatefulWidget {
  ChatPage({Key key, @required this.account}) : super(key: key);
  String account;
  @override
  State<StatefulWidget> createState() => new ChatPageState(targetAccount: account);
}


class ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  ChatPageState({this.targetAccount});

  //final List<ChatMessage> _messages = <ChatMessage>[];
  List<Message> _message = <Message>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;//用户是否输入字段
  String _dbName = 'localHistoryMessages';
  String _data = "none";
  String _createTableSQL = 'CREATE TABLE history_messages (id INTEGER PRIMARY KEY, senderName TEXT, userName TEXT, sheName TEXT, headImage TEXT, timestamp TEXT, text TEXT)';
  int _dbVersion = 1;
  String targetAccount;
  Timer _timer;
  String myHeadImage;
  String targetHeadImage;
  String myUsername;
  String targetUsername;

  @override
  void initState() {
    super.initState();
    _getMessageFromServerPeriodically().then((value) async {
      await HeadImage().getHeadImage(this.context).then((value){
        myHeadImage = value;
        Message.myHeadImage = value;
        print(myHeadImage);
      });
      await getOthersHeadImages.getOthersHeadImage(this.context, targetAccount).then((value) {
        targetHeadImage = value;
        Message.targetHeadImage = value;
        print(targetHeadImage);
      });
      await getUserName.getUsername(this.context).then((value){
        myUsername = value;
        Message.myUsername = value;
      });
      await getOthersUserName.getOthersUsername(this.context, targetAccount).then((value) {
        targetUsername = value;
        Message.targetUsername = value;
      });
      setState(() {});
    });

    /*_createDb(_dbName, _dbVersion, _createTableSQL).then((value){
      setState(() {
        _getHistoryMessagesFromLocal(_name, "zwn").then((value) {
          setState(() {

          });
        });
      });
    });*/
  }

  //点击发送后的处理事项
  Future <void> _handleSubmitted(String text) async {
    if (text.trim() == "") return;//每次发送后清除输入框
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    await _sendMessage(targetAccount, text).then((value) {
      setState(() {

      });
    });
   /* setState(() {
      _messages.insert(0,ChatMessage()..senderName = '$_name'..headImage = "https://www.itying.com/images/flutter/4.png"..text = '$text');
    });*/
    /*ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
          duration: new Duration(milliseconds: 300),
          vsync: this //此选项将当前窗口控件树保留在显示内存中，直到Flutter的渲染引擎完成刷新周期
      ),
    );
    message.animationController.forward();//每当将新消息添加到聊天列表中时动画应播放*/
  }

  //send message to server
  Future<void> _sendMessage(String targetAccount, String message) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post('http://widealpha.top:8080/shop/chat/sendMessage',
    options: Options(headers: {'Authorization': 'Bearer'+LoginPageState.token}),
    queryParameters: {
      'targetAccount': targetAccount,
      'message': message
    });
    String feedback = response.data.toString();
    print(feedback);
    DateTime time = DateTime.now();
    String timestamp = time.toString();
    if (response.data['code'] == 0) {
      setState(() {
       _message.insert(0,new Message(
           response.data['data'],
           LoginPageState.account,
           targetAccount,
           timestamp,
           message,
           0));
       print('send successfully');
      });
    }
    /*String time = new DateTime.now().toString();
    String sql = "INSERT INTO history_messages(userName,sheName,senderName,headImage,timestamp,text) VALUES('$_name','zwn','$_name','$imageUrl','$time','$text')";
    _add(_dbName, sql);*/
  }

  Future<void> _getMessageFromServerPeriodically() async{
    _timer = Timer.periodic(Duration(seconds: 1), (t) async {
      Response response;
      Dio dio = new Dio();
      response = await dio.post('http://widealpha.top:8080/shop/chat/messagesWithTarget',
          options: Options(headers: {'Authorization': 'Bearer'+LoginPageState.token}),
          queryParameters: {
            'targetAccount': targetAccount,
            'limit': 100
          }
      );
      String feedback = response.data.toString();
      print(feedback);
      if (response.data['code'] == 0) {
        if (response.data['data'] == null) {
          print('no info');
          return;
        } else {
          if (!mounted) {
            return;
          }
          setState(() {
            List messageJson = response.data['data'];
            print(messageJson);
            _message = messageJson.map((e) => Message.fromJson(e)).toList();
            print(_message);
            if (_message.isEmpty) {
              print("没有历史记录");
            }
          });
        }
      }
      print("get successfully");
    });

  }

  /*Future<void> _getHistoryMessagesFromLocal(String userName, String sheName) async {
    String sql = 'SELECT * FROM history_messages';
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbName);
    Database db = await openDatabase(path);
    List<Map> list = await db.rawQuery(sql);
    await db.close();
    if (list.length == 0) {
      print("no history");
      return;
    }
    int i = list.length-1;
    while (i >= 0){
      *//*print(runtimeType);
      _messages[i].senderName = list[i]['senderName'];
      print(runtimeType);
      _messages[i].headImage = list[i]['headImage'];
      _messages[i].text = list[i]['text'];
      i++;*//*
      if (list[i]['userName'] == userName && list[i]['sheName'] == sheName){
        _messages.add(ChatMessage()..senderName = list[i]['senderName']..headImage = list[i]['headImage']..text = list[i]['text']);
        print(_messages.toString());
      }
      i--;
    }
   }*/

  //不再需要资源时释放动画处理器的资源
  @override
  void dispose() {
    /*for (ChatMessage message in _messages)
      message.animationController.dispose();*/
    super.dispose();
    _timer.cancel();
  }   //被删除的动画部分

  //总UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(targetUsername ?? " "),
        /*actions:<Widget> [
          new PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem(
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children:<Widget> [
                          Text("删除历史记录"),
                          Icon(Icons.delete)
                        ],
                      ),
                      onPressed: () async {
                        bool delete = await showDeleteConfirmDialog();
                        if (delete == null) {
                          print("取消删除");
                        } else {
                          print("确认删除");
                          String sql = 'DELETE FROM history_messages where sheName = "zwn"';
                          _delete(_dbName, sql);
                          print(_data);
                          //_messages.clear();
                          //_getHistoryMessagesFromLocal(_name, "zwn");
                        }
                      },
                    )
                )
              ])
        ],*/
        //title: Text(widget.sheName),
      ),
      body: Column(
        children:<Widget> [
          new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: true,//使ListView从屏幕底部开始
                itemBuilder: (_, int index) => _message[index],
                itemCount: _message.length,
              )
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }


  //输入框
  Widget _buildTextComposer() {
    return new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
            children: <Widget> [
              new Flexible(
                  child: new TextField(
                    maxLines: null,
                    controller: _textController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    onSubmitted: _handleSubmitted,
                    decoration: new InputDecoration.collapsed(hintText: '发送消息'),
                  )
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: _isComposing ?
                        () => _handleSubmitted(_textController.text) : null
                ),
              )
            ]
        )
    );
  }

  Future<bool> showDeleteConfirmDialog() {
    return showDialog<bool>(
      context: this.context,
      builder: (context) {
          return AlertDialog(
            title: Text('提示'),
            content: Text("您要删除历史记录吗？"),
            actions:<Widget> [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("取消")),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("删除"))
            ],
          );
      }
    );
  }

  ///创建数据库db
  Future<void> _createDb(String dbName,int vers,String dbTables) async {
    //获取数据库路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    print("数据库路径：$path数据库版本$vers");
    //打开数据库
    await openDatabase(
        path,
        version:vers,
        onUpgrade: (Database db, int oldVersion, int newVersion) async{
          //数据库升级,只回调一次
          print("数据库需要升级！旧版：$oldVersion,新版：$newVersion");
        },
        onCreate: (Database db, int vers) async{
          //创建表，只回调一次
          await db.execute(dbTables);
          await db.close();
          setState(() {

          });

        }
    );
    setState(() {
      _data = "成功创建数据库db！\n数据库路径: $path \n数据库版本$vers";
    });
  }
  ///增
  _add(String dbName,String sql) async {
    //获取数据库路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    print("数据库路径：$path");

    Database db = await openDatabase(path);
    await db.transaction((txn) async {
      int count = await txn.rawInsert(sql);
    });
    await db.close();

    setState(() {
      _data = "插入数据成功！";
    });
  }
  ///删
  _delete(String dbName, String sql) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    Database db = await openDatabase(path);
    int count = await db.rawDelete(sql);
    await db.close();
    if (count > 0) {
      setState(() {
        _data = "执行删除操作完成，该sql删除条件下的数目为：$count";
      });
    } else {
      setState(() {
        _data = "无法执行删除操作，该sql删除条件下的数目为：$count";
      });
    }
  }



}

//表示单个聊天消息的控件
const String _name = "Ryan";
class Message extends StatelessWidget {
  int messageId;
  String senderAccount;
  String targetAccount;
  String timestamp;
  String message;
  int readTimes;

  Message(this.messageId, this.senderAccount, this.targetAccount,
      this.timestamp, this.message, this.readTimes);

  Message.fromJson(Map<String, dynamic> jsonMap) {
    this.messageId = jsonMap['messageId'];
    this.senderAccount = jsonMap['senderAccount'];
    this.targetAccount = jsonMap['targetAccount'];
    this.timestamp = jsonMap['timestamp'];
    this.message = jsonMap['message'];
    this.readTimes = jsonMap['readTimes'];
  }


  static String myHeadImage;
  static String targetHeadImage;
  static String myUsername;
  static String targetUsername;

  @override
  Widget build(BuildContext context) {

    Widget _sheSessionStyle() {
      return Row(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: targetHeadImage == null
                ? CircleAvatar(backgroundImage: AssetImage('images/defaultHeadImage.png'),)
                : CircleAvatar(backgroundImage: NetworkImage(targetHeadImage),)
            /*CircleAvatar(
              backgroundImage: NetworkImage(headImage),
            ),*/
          ),
          Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(targetUsername ?? " ",style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0,right: 50),
                    child: Bubble(
                      direction: BubbleDirection.left,
                      color: Colors.grey,
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ))
        ],
      );
    }

    Widget _mySessionStyle() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(myUsername ?? " ", style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0,left: 50),
                    child: Bubble(
                      direction: BubbleDirection.right,
                      color: Colors.blue,
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white)
                      ),
                    ),
                  )
                ],
              )),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: myHeadImage == null
                ? CircleAvatar(backgroundImage: AssetImage('images/defaultHeadImage.png'))
                : CircleAvatar(backgroundImage: NetworkImage(myHeadImage),)
          )
        ],
      );
    }

    return new Material(
       /* sizeFactor: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut
        ),*/
      //axisAlignment: 0.0,
      child: Consumer<DarkModeModel>(builder: (context, DarkModeModel, child){
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: LoginPageState.account == senderAccount
              ? _mySessionStyle() : _sheSessionStyle(),
          //临时代码
          /*Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,//+
            children: [
              Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,//start
                    children: [
                      Text(senderAccount,
                      style: Theme.of(context).textTheme.subhead),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0,left: 50),
                        child: Bubble(
                          direction: BubbleDirection.right,
                          color: Colors.blue,
                          child: Text(
                            message,
                            style: TextStyle(
                              color: DarkModeModel.darkMode ? Colors.white : Colors.black87
                            ),
                          ),
                        )
                      )
                    ],
                  )),
              Container(
                margin: const EdgeInsets.only(left: 16.0),//right
                child: CircleAvatar(backgroundImage: NetworkImage("https://www.itying.com/images/flutter/5.png")),
              ),
            ],
          ),*/
        );
      },),
    );
  }
}