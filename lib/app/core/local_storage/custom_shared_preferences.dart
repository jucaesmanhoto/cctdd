import 'package:shared_preferences/shared_preferences.dart';

abstract class CustomSharedPreferencesInterface {
  Future<SharedPreferences> get prefs;
}

class CustomSharedPreferences implements CustomSharedPreferencesInterface {
  @override
  Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();
}
