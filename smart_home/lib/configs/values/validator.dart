

class AppValidator{
  static String checkValidator(String value) {
    if (value.length == 0) {
      return 'Đây là trường bắt buộc';
    }
    return null;
  }
}

class Validation {
  static bool validationEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(value))
      return true;
    else
      return false;
  }

  static bool validationStrongPassword(String value) {
//    Pattern pattern =
//        '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*]).{6,}\$';
//    RegExp regExp = new RegExp(pattern);
    // if (regExp.hasMatch(value)) return true;
    if(value.length >= 6) return true;
    return false;
  }

  static bool validationPhone(String value) {
    Pattern pattern = r'0[0-9]{9}';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(value)) return true;
    return false;
  }

  static String injectionFilter(String value) {
    bool flag = false;
    do {
      print(value);
      Pattern pattern = r'\$where|\$group|\$eq|\$lt|\$lte|\$gt|\$gte|\$ne';
      RegExp regExp = new RegExp(pattern);
      flag = regExp.hasMatch(value);
      if(flag == true) {
        String injection = regExp.stringMatch(value);
        value = value.replaceAll(injection, '');
      }

    } while(flag == true);
    return value;
  }
}