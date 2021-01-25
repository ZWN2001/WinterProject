import 'package:flutter/material.dart';
import 'package:winter/AdapterAndHelper/DarkModeModel.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ChatPageState();
}

class ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;//用户是否输入字段

  //点击发送后的处理事项
  void _handleSubmitted(String text) {
    //每次发送后清除输入框
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    //发送消息后，将新消息添加到消息列表中，且为从头插入（时间顺序）
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
          duration: new Duration(milliseconds: 300),//动画运行时间
          vsync: this //此选项将当前窗口控件树保留在显示内存中，直到Flutter的渲染引擎完成刷新周期
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();//每当将新消息添加到聊天列表中时动画应播放
  }

  //不再需要资源时释放动画处理器的资源
  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  //输入框
  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
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
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("zwn"),
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

}

//表示单个聊天消息的控件
const String _name = "Ryan";
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;//动画控制器

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut
        ),
      axisAlignment: 0.0,
      child: Consumer<DarkModeModel>(builder: (context, DarkModeModel, child){
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(backgroundImage: NetworkImage("https://www.itying.com/images/flutter/4.png")),
              ),
              Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_name,
                      style: Theme.of(context).textTheme.subhead),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Text(text,
                          style: TextStyle(
                            color: DarkModeModel.darkMode ? Colors.white : Colors.black87
                          ),),
                      )
                    ],
                  ))
            ],
          ),
        );
      },),
    );
  }
}