
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winter/AdapterAndHelper/searchHistory.dart';
import '../AdapterAndHelper/user.dart';

///数据库相关的工具
class SharedPreferenceUtil {
  static const String ACCOUNT_NUMBER = "account_number";
  static const String ACCOUNT = "account";
  static const String PASSWORD = "password";

  ///删掉单个账号
  static void delUser(User user) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<User> accountList = await getUsers();
    accountList.remove(user);
    saveUsers(accountList, sp);
    print('removed');
  }

  //保存账号，如果重复，就将最近登录账号放在第一个
  static void saveUser(User user) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<User> accountList = await getUsers();
    addNoRepeat(accountList, user);
    saveUsers(accountList, sp);
    print('已保存账号');
  }

  //去重并维持次序
  static void addNoRepeat(List<User> users, User user) {
    if (users.contains(user)) {
      users.remove(user);
    }
    users.insert(0, user);
  }

  ///获取已经登录的账号列表
  static Future<List<User>> getUsers() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<User> accountList =List();
    int num = sp.getInt(ACCOUNT_NUMBER) ?? 0;
    for (int i = 0; i < num; i++) {
      String account = sp.getString("$ACCOUNT$i");
      String password = sp.getString("$PASSWORD$i");
      accountList.add(User(account, password));
    }
    print('当前列表保存的用户数：$num');
    print(accountList);
    return accountList;
  }

  ///保存账号列表
  static saveUsers(List<User> users, SharedPreferences sp){
    sp.clear();
    int size = users.length;
    for (int i = 0; i < size; i++) {
      sp.setString("$ACCOUNT$i", users[i].account);
      sp.setString("$PASSWORD$i", users[i].password);
    }
    sp.setInt(ACCOUNT_NUMBER, size);
  }

  ///改密码
  static changePassword(String oldPassword,String newPassword) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<User> list = await getUsers();
    int size = list.length;
    int i;
    for (i = 0; i < size; i++) {
      if(oldPassword==sp.getString("$PASSWORD$i")){
        break;
      }
      break;
    }
    sp.setString("$PASSWORD$i",newPassword);
  }

  //查找界面的一些操作
  static const String HISTORY = "history";
  static const String HISTORY_NUMBER = "history_number";

  static void saveHistory(String history) async {
    SharedPreferences historySP = await SharedPreferences.getInstance();
    List<String> historiesList = await getHistories();
    addWithoutRepeat(historiesList, history);
    saveHistories(historiesList, historySP);
    print('已保存历史记录$history');
  }
  //去重并维持次序
  static void addWithoutRepeat(List<String> historiesList, String history) {
    if (historiesList.contains(history)) {
      historiesList.remove(history);
    }
    historiesList.insert(0, history);
  }
  ///保存历史记录列表
  static saveHistories(List<String> historiesList, SharedPreferences sp){
    sp.clear();
    int size = historiesList.length;
    for (int i = 0; i < size; i++) {
      sp.setString("$HISTORY$i", historiesList[i]);
    }
    sp.setInt(HISTORY_NUMBER, size);
    print('历史记录列表保存完成,长度为$size');
    print('打印当前列表');
    print(historiesList);
  }
  //删列表
  static void delHistories() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> historiesList = await getHistories();
    historiesList.clear();
    saveHistories(historiesList, sp);
    print('已经清除所有历史记录');
  }

  ///获取已经登录的账号列表
  static Future<List<String>> getHistories() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> historiesList =List();
    int num = sp.getInt(HISTORY_NUMBER) ?? 0;
    for (int i = 0; i < num; i++) {
      String history = sp.getString("$HISTORY$i");
      historiesList.add(history);
    }
    print('当前列表保存的历史记录数：$num');
    return historiesList;
  }

  static const String USERNAME='username';
  static saveUsername(String username) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(USERNAME, username);
  }

  static Future<String> getUsername() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(USERNAME)??'';
  }

}