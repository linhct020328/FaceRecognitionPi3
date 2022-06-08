import 'package:smarthome/get_it.dart';
import 'package:smarthome/provider/helpers/shared_preferences_manager.dart';

class LocalSettingsPref {
  static const keyFirstRun = 'first-run';
  static const keyFirstSetupNotify = 'first-setup-notify';

  static bool isFirstTime() {
    var isFirstTime = locator.get<SharedPreferencesManager>().get(keyFirstRun);
    if (isFirstTime != null && !isFirstTime) {
      locator.get<SharedPreferencesManager>().set(keyFirstRun, false);
      return false;
    } else {
      locator.get<SharedPreferencesManager>().set(keyFirstRun, false);
      return true;
    }
  }

  static bool isFirstNotifySetting() {
    var isFirstTime =
        locator.get<SharedPreferencesManager>().get(keyFirstSetupNotify);
    if (isFirstTime != null && !isFirstTime) {
      locator.get<SharedPreferencesManager>().set(keyFirstSetupNotify, false);
      return false;
    } else {
      locator.get<SharedPreferencesManager>().set(keyFirstSetupNotify, false);
      return true;
    }
  }

  static void resetFirstNotifySetting() {
    locator.get<SharedPreferencesManager>().set(keyFirstSetupNotify, true);
  }
}
