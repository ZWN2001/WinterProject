import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeModel with ChangeNotifier {
  //夜间模式
  bool _darkMode;
  static const String STORE_KEY = 'darkMode';
  SharedPreferences _prefs;
  bool get darkMode => _darkMode;

  DarkModeModel() {
    _init();
  }

  void _init() async {
    this._prefs = await SharedPreferences.getInstance();
    bool localMode = this._prefs.getBool(STORE_KEY);
    print('init.........................');
    print('现在的状态为:$localMode');
    if(localMode==null){
      this._prefs.setBool(STORE_KEY,false);
      _darkMode=false;
    } else{
      _darkMode=localMode;
    }
  }

  void changeMode() async {
    SharedPreferences prefs = this._prefs ?? SharedPreferences.getInstance();
      _darkMode = !_darkMode;
      await prefs.setBool(STORE_KEY, darkMode);
      print('状态更改为:$darkMode');
      notifyListeners();
  }
}