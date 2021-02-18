import 'package:flutter/cupertino.dart';
import 'package:winter/SharedPreference/sharedPreferenceUtil.dart';

class SearchHistory with ChangeNotifier{
  List<String> history=List();
   List<String> _recommend = ['数码产品', '二手书', '食品', '生活用品', '美妆', '其他'];
  // get getHistory =>_history;
  // set setHistory(List history) =>_history;

  Future<void> initHistory() async {
    if(history!=null) {
      history.clear();
    }
    history.addAll(await SharedPreferenceUtil.getHistories());
  }

   void refresh(){
    notifyListeners();
  }
}