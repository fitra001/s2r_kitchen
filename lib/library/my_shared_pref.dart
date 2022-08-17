import 'package:s2r_kitchen/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  static const String keyValue = "value";
  static const String keyModel = "model";
  static const String login = "login";

  Future<SharedPreferences> getPreferences() async => await SharedPreferences.getInstance();

  setValue(String value) async {
    (await getPreferences()).setString(keyValue, value);
  }

  Future<String?> getValue() async => (await getPreferences()).getString(keyValue);

  setModel(User user) async {
    (await getPreferences()).setString(keyModel, userToJson(user));
  }

  Future<User?> getModel() async {
    var data = (await getPreferences()).getString(keyModel);
    if(data != null) return userSharedFromJson(data);
    return null;
  }
  
  setLogin(bool value) async {
    (await getPreferences()).setBool(login, value);
  }

  Future<bool> getLogin() async =>  (await getPreferences()).getBool(login) ?? false;
  
  Future<bool> clearAllData() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove(keyValue);
    sharedPref.remove(keyModel);
    setLogin(false);
    return true;
  }
}