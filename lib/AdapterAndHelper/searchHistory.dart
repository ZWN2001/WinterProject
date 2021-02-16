import 'package:flutter/cupertino.dart';
import 'package:winter/SharedPreference/sharedPreferenceUtil.dart';

class searchHistory with ChangeNotifier{
  List<String> _history=List();
   List _recommend = ['数码产品', '二手书', '食品', '生活用品', '美妆', '其他'];
  get history =>_history;

  Future<void> initHistory() async {
    if(_history!=null) {
      _history.clear();
    }
    _history.addAll(await SharedPreferenceUtil.getHistories());
  }

   void refresh(){
    notifyListeners();
  }
}