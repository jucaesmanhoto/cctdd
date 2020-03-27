import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesFacade {
  Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();
}
