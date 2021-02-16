import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart'hide BuildContext;
import 'package:winter/AdapterAndHelper/bubble.dart';
import 'package:path/path.dart';

class ChatPage extends StatefulWidget {
  ChatPage(
      {this.messages, this.userName, this.sheName, this.headImage, this.sheHeadImage});
  final String messages;
  final String userName;
  final String sheName;//对方的用户名
  final String headImage;
  final String sheHeadImage;
  @override
  State<StatefulWidget> createState() => new ChatPageState();
}


class ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;//用户是否输入字段
  String _dbName = 'localHistoryMessages';
  String _data = "none";
  String _createTableSQL = 'CREATE TABLE history_messages (id INTEGER PRIMARY KEY, senderName TEXT, userName TEXT, sheName TEXT, headImage TEXT, timestamp TEXT, text TEXT)';
  int _dbVersion = 1;

  @override
  void initState() {
    super.initState();
    _createDb(_dbName, _dbVersion, _createTableSQL).then((value){
      setState(() {
        _getHistoryMessagesFromLocal(_name, "zwn").then((value) {
          setState(() {

          });
        });
      });
    });
    /*setState(() {
      _getHistoryMessages();
    });*/
  }

  //点击发送后的处理事项
  void _handleSubmitted(String text) {
    //每次发送后清除输入框
    if (text.trim() == "") return;
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    _sendMessage(text: text, imageUrl: "https://www.itying.com/images/flutter/4.png");
    //发送消息后，将新消息添加到消息列表中，且为从头插入（时间顺序）
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
          duration: new Duration(milliseconds: 300),
          vsync: this //此选项将当前窗口控件树保留在显示内存中，直到Flutter的渲染引擎完成刷新周期
      ),        //被删除的动画部分
    );
    setState(() {
      //_messages.insert(0, message);
      //_getHistoryMessages();
      _messages.insert(0,ChatMessage()..senderName = '$_name'..headImage = "https://www.itying.com/images/flutter/4.png"..text = '$text');
    });
    message.animationController.forward();//每当将新消息添加到聊天列表中时动画应播放*/   //被删除的动画部分
  }

  void _sendMessage({String text, String imageUrl}) {
    String time = new DateTime.now().toString();
    String sql = "INSERT INTO history_messages(userName,sheName,senderName,headImage,timestamp,text) VALUES('$_name','zwn','$_name','$imageUrl','$time','$text')";
    _add(_dbName, sql);
  }

  Future<void> _getHistoryMessagesFromLocal(String userName, String sheName) async {
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
      /*print(runtimeType);
      _messages[i].senderName = list[i]['senderName'];
      print(runtimeType);
      _messages[i].headImage = list[i]['headImage'];
      _messages[i].text = list[i]['text'];
      i++;*/
      if (list[i]['userName'] == userName && list[i]['sheName'] == sheName){
        _messages.add(ChatMessage()..senderName = list[i]['senderName']..headImage = list[i]['headImage']..text = list[i]['text']);
        print(_messages.toString());
      }
      i--;
    }
   }

  //不再需要资源时释放动画处理器的资源
  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }   //被删除的动画部分

  //总UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("zwn"),//暂时
        actions:<Widget> [
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
                          _messages.clear();
                          _getHistoryMessagesFromLocal(_name, "zwn");
                        }
                      },
                    )
                )
              ])
        ],
        //title: Text(widget.sheName),
      ),
      body: Column(
        children:<Widget> [
          new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: true,//使ListView从屏幕底部开始
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
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
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController, this.senderName, this.userName, this.headImage, this.sheName});
  String text;
  final AnimationController animationController;//动画控制器
  String senderName;
  final String userName;
  String headImage;
  String sheName;

  @override
  Widget build(BuildContext context) {

    Widget _sheSessionStyle() {
      return Row(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(headImage),
            ),
          ),
          Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(senderName,style: Theme.of(context).textTheme.subhead),
                  Container(
                    //TODO
                    margin: const EdgeInsets.only(top: 5.0,right: 50),
                    child: Bubble(
                      direction: BubbleDirection.left,
                      color: Colors.blue,
                      child: Text(
                        text,
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
                  Text(senderName, style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Bubble(
                      direction: BubbleDirection.left,
                      color: Colors.blue,
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.white)
                      ),
                    ),
                  )
                ],
              )),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(headImage),
            ),
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
          child:
              //正确代码
         // userName == senderName
           // ? _mySessionStyle() : _sheSessionStyle(),
          //临时代码
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,//+
            children: [
              Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,//start
                    children: [
                      Text(senderName,
                      style: Theme.of(context).textTheme.subhead),
                      Container(
                        //TODO
                        margin: const EdgeInsets.only(top: 5.0,left: 50),
                        child: Bubble(
                          direction: BubbleDirection.right,
                          color: Colors.blue,
                          child: Text(
                            text,
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
                child: CircleAvatar(backgroundImage: NetworkImage(headImage)),
              ),
            ],
          ),
        );
      },),
    );
  }
}