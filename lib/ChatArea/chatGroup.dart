import 'dart:ffi';
import 'package:loading_animations/loading_animations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart'hide BuildContext;
import 'package:winter/ChatArea/ChatPage.dart';
import 'package:winter/Basic/login.dart';
import 'package:winter/ChatArea/chatTargetClass.dart';
import 'package:winter/AdapterAndHelper/getOthersUsername.dart';
import 'package:winter/AdapterAndHelper/getOthersHeadImage.dart';


class ChatGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ChatGroupState();
}

class ChatGroupState extends State<ChatGroup> {

  // List ListData = [
  //   {
  //     "headImage": "https://www.itying.com/images/flutter/7.png",
  //     "userName": "zwn",
  //     "lastMessage": "吃了吗？",
  //     "timeStamp": "2021-01-27 9:16:11.65"
  //   }
  // ];

  List<dynamic> chatAccountList = new List();
  List<dynamic> tempList1 = new List();
  List<ChatTargetUnit> chatTargetUnit = new List();
  Message singleMessage ;
  List<Message> unreadMessage = new List();
  int length = 0;
  String targetAccount = " ";
  String targetUsername = " ";
  String targetHeadImage = " ";
  String lastMessage = " ";
  String timestamp = " ";
  String _dbName = 'chatTargetAccountsList';
  String _data = 'none';
  String _createTableSQL = 'CREATE TABLE chat_target_accounts_list (myAccount TEXT PRIMARY KEY, targetAccount TEXT)';
  int _dbVersion = 1;


  @override
  void initState() {
    super.initState();
    _createDb(_dbName, _dbVersion, _createTableSQL).then((value) async {
      await _getChatAccountList().whenComplete(() async {
        await _getUnreadMessage().then((value) {
          _addUnreadMessageAccountToList(unreadMessage);
        });
      });
      await _getTargetAccountListFromLocal().whenComplete(() {
        _getChatTargetInfo();
      });
    }).whenComplete(() {
      setState(() {
        length = chatAccountList.length;
        print('..........................................................');
        print(length);
      });
    });
   /* _getChatAccountList().then((value) {
      _getChatTargetInfo();
    });
    _getUnreadMessage().then((value) {
      _addUnreadMessageAccountToList(unreadMessage);
    });*/
    setState(() {});
  }

  //1、获取自己主动发起聊天的对象account，然后把它们存入数据库
  //获取所有发过信息的目标
  Future<void> _getChatAccountList() async {
    Dio dio = new Dio();
    Response response = await dio.post('http://widealpha.top:8080/shop/chat/allTargetAccounts',
    options: Options(headers: {'Authorization': 'Bearer'+LoginPageState.token}));
    String feedback = response.data.toString();
    print("feedback");
    print(feedback);
    //chatAccountList = response.data['data'];
    tempList1 = response.data['data'];
    print(tempList1);
    //length = tempList1.length;
    print(tempList1.length);
    tempList1.forEach((element) {
      String sql = "INSERT OR IGNORE INTO chat_target_accounts_list(myAccount, targetAccount) VALUES('${LoginPageState.account}','$element')";
      _add(_dbName, sql);
    });

  }

  //5、根据chatAccountList获取具体信息
  //获取目标们的信息
  Future<void> _getChatTargetInfo() async {
    print('chatAccountList............................................');
    print(chatAccountList);
    for (int i = 0; i < chatAccountList.length; i++) {
      /*targetAccount = chatAccountList[i];
      getOthersUserName.getOthersUsername(context, chatAccountList[i]).then((value) {
        setState(() {
          targetUsername = value;
        });
      });
      getOthersHeadImages.getOthersHeadImage(context, chatAccountList[i]).then((value) {
        setState(() {
          targetHeadImage = value;
        });
      });
      _getLastMessage(chatAccountList[i]).then((value) {
        setState(() {
          lastMessage = value;
        });
      });
      _getTimestamp(chatAccountList[i]).then((value) {
        setState(() {
          timestamp = value;
        });
      });*/
      await getOthersHeadImages.getOthersHeadImage(this.context, chatAccountList[i]).then((value) {
        setState(() {
          targetHeadImage = value;
        });
      });
      await getOthersUserName.getOthersUsername(this.context, chatAccountList[i]).then((value) {
        setState(() {
          targetUsername = value;

        });
      });
      requestToServer(chatAccountList[i]).then((value) {
        setState(() {
          targetAccount = singleMessage.targetAccount;
          lastMessage = singleMessage.message;
          timestamp = singleMessage.timestamp;
          print("targetAccount");
          print(targetAccount);
          if (mounted) {
            setState(() {
              chatTargetUnit.add(new ChatTargetUnit(targetAccount, targetUsername, targetHeadImage, lastMessage, timestamp));
            });
          }
          print("getChatTargetInfo");
          print(chatTargetUnit);
        });
      });

    }
  }

  Future<void> requestToServer(String targetAccount) async {
    Dio dio = new Dio();
    Response response = await dio.post('http://widealpha.top:8080/shop/chat/messagesWithTarget',
        options: Options(headers: {'Authorization': 'Bearer'+LoginPageState.token}),
        queryParameters: {
          'targetAccount': targetAccount,
          'limit': 1
        });
    String feedback = response.data.toString();
    print("getLastMessage");
    print(feedback);
    if (response.data['code'] == 0) {
      if (response.data['data'].toString().isNotEmpty) {
        setState(() {
          List messageListJson = response.data['data'];
          List<Message> messageList = messageListJson.map((e) => Message.fromJson(e)).toList();
          print("messageList...............................");
          print(messageList);
          singleMessage = new Message(
              messageList[0].messageId,
              messageList[0].senderAccount != LoginPageState.account
              ? messageList[0].targetAccount
              : messageList[0].senderAccount,
              messageList[0].targetAccount == LoginPageState.account
              ? messageList[0].senderAccount
              : messageList[0].targetAccount,
              messageList[0].timestamp,
              messageList[0].message,
              messageList[0].readTimes
          );
          print(singleMessage);
        });
      }
    }
  }

  //2、加载未读消息，放入list：unreadMessage
  Future<void> _getUnreadMessage() async {
    Dio dio = new Dio();
    Response response = await dio.post('http://widealpha.top:8080/shop/chat/unreadMessage',
    options: Options(headers: {'Authorization': 'Bearer'+LoginPageState.token}));
    print('unreadMessage');
    print(response.data.toString());
    if (response.data['code'] == 0) {
      if (response.data['data'] != null) {
        setState(() {
          List messageListJson = response.data['data'];
          unreadMessage = messageListJson.map((e) => Message.fromJson(e)).toList();
        });
      }
    }
  }

  //3、将获取到的未读消息的发送者账号提取出来并检验，如果不重复就保存到数据库里
  _addUnreadMessageAccountToList(List<Message> unreadMessage) {
    unreadMessage.forEach((element) {
      if (tempList1.contains(element.senderAccount)) {
        print("重复");
      } else {
        //chatAccountList.add(element.senderAccount);
        String sql = "INSERT INTO chat_target_accounts_list(myAccount, targetAccount) VALUES('${element.targetAccount}','${element.senderAccount}')";
        _add(_dbName, sql);
      }
    });
    print("全部账号");
    //print(chatAccountList);
  }


  //4、获取数据库信息，将数据库里的账号转存到chatAccountList中
  Future<void> _getTargetAccountListFromLocal() async {
    String sql = 'SELECT * FROM chat_target_accounts_list WHERE myAccount = ${LoginPageState.account}';
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbName);
    Database db = await openDatabase(path);
    List<Map> list = await db.rawQuery(sql);
    print('list,,,,,,,,,,,,.............');
    print(list);
    //await db.close();
    if (list.length == 0) {
      print('no history');
      return;
    }
    int i = list.length - 1;
    while (i >= 0) {
      chatAccountList.add(list[i]['targetAccount']);
      print(chatAccountList);
      i--;
      print('i......');
      print(i);
    }
    print('#4');
    print(chatAccountList);
  }


  /*Future<String> _getLastMessage(String targetAccount) async {
    Dio dio = new Dio();
    Response response = await dio.post('http://widealpha.top:8080/shop/chat/messagesWithTarget',
    options: Options(headers: {'Authorization': 'Bearer'+LoginPageState.token}),
    queryParameters: {
      'targetAccount': targetAccount,
      'limit': 1
    });
    String feedback = response.data.toString();
    print("getLastMessage");
    print(feedback);
    if (response.data['code'] == 0) {
      if (response.data['data'] != null) {
        setState(() {
          List messageListJson = response.data['data'];
          List<Message> messageList = messageListJson.map((e) => Message.fromJson(e)).toList();
          singleMessage = new Message(
            messageList[0].messageId,
            messageList[0].senderAccount,
            messageList[0].targetAccount,
            messageList[0].timestamp,
            messageList[0].message,
            messageList[0].readTimes
          );
          print(singleMessage);
        });
      }
    }
  }*/

  /*Future<String> _getTimestamp(String targetAccount) async {
    Dio dio = new Dio();
    Response response = await dio.post('http://widealpha.top:8080/shop/chat/messagesWithTarget',
        options: Options(headers: {'Authorization': 'Bearer'+LoginPageState.token}),
        queryParameters: {
          'targetAccount': targetAccount,
          'limit': 1
        });
    String feedback = response.data.toString();
    print("getTimestamp");
    print(feedback);
    return response.data['data']['timestamp'];
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('聊天列表'),
      ),
      body: length == 0
          ? noChatListText()
          : hasChatList()
      /*Column(
        children: [
          Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: chatTargetUnit.length,
                itemBuilder: (context, index){
                  return Material(
                    child: itemWidget(index),
                  );
                },
              ))
        ],
      ),*/
    );
  }

  Widget hasChatList() {
    return Column(
      children: [
        Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: chatTargetUnit.length,
              itemBuilder: (context, index){
                return Material(
                  child: itemWidget(index),
                );
              },
            ))
      ],
    );
  }

  Widget noChatListText() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text("暂时还没有聊天记录",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),),
          LoadingBumpingLine.circle(
            size: 40,
            backgroundColor: Colors.blue,
          ),
        ],
      ),

    );
  }

  Widget itemWidget(int index) {
    return InkWell(
      onTap: (){
        Navigator.push(this.context, MaterialPageRoute(builder: (context){
          return new ChatPage(account: chatTargetUnit[index].targetAccount ?? " ");
        }));
      },
      child: Consumer<DarkModeModel>(builder: (context, DarkModeModel, child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          height: 55,
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: chatTargetUnit[index].targetHeadImage == null
                ? AssetImage('images/defaultHeadImage.png')
                : NetworkImage(chatTargetUnit[index].targetHeadImage),
              ),
              /*Container(
                //padding: Ed,
                child: ClipOval(
                  clipper: _MyClipper(),
                  child: Image.network(ListData[index]["headImage"],
                  fit: BoxFit.fill,),
                ),
              ),*/
              Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(" " + chatTargetUnit[index].targetUsername,
                              style: TextStyle(
                                  color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                                  fontSize: 22)),
                          Text(readableTime(chatTargetUnit[index].timestamp),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Theme.of(context).hintColor
                          ),),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                        child: Text("  " + chatTargetUnit[index].lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: DarkModeModel.darkMode ? Colors.white : Colors.black87,
                            fontSize: 12,)),
                      ),
                    ],
                  )),
            ],
          ),
        );
      },),
    );
  }

  Future<void> _createDb(String dbName, int version, String dbTables) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    print("数据库路径：$path数据库版本$version");
    await openDatabase(
        path,
        version: version,
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          print("数据库需要升级！旧版：$oldVersion,新版：$newVersion");
        },
        onCreate: (Database db, int version) async {
          await db.execute(dbTables);
          //await db.close();
          setState(() {});
        }
    );
    setState(() {
      _data = "成功创建数据库db！\n数据库路径: $path \n数据库版本$version";
    });
  }

  _add(String dbName, String sql) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    print("数据库路径：$path");
    Database db = await openDatabase(path);
    await db.transaction((txn) async {
      int count = await txn.rawInsert(sql);
    });
    //await db.close();
    setState(() {
      _data = "插入数据成功";
    });
  }
}

class _MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTRB(0, 0, 45, 45);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }


}

//将时间标准化显示
String readableTime(String timestamp) {
  List<String> timeList = timestamp.split("T");
  List<String> times = timeList[1].split(":");
  String time;
  if (new DateTime.now().toString().split(" ")[0] == timeList[0]) {
    if (int.parse(times[0]) < 6) {
      time = "凌晨${times[0]}:${times[1]}";
    } else if (int.parse(times[0]) < 12) {
      time = "上午${times[0]}:${times[1]}";
    } else if (int.parse(times[0]) == 12) {
      time = "中午${times[0]}:${times[1]}";
    } else {
      time =
      "下午${(int.parse(times[0])- 12).toString().padLeft(2,'0')}:${times[1]}";
    }
  } else {
    time = timeList[0];
  }
  return time;
}