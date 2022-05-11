import 'dart:convert';

import 'package:http/http.dart';
import 'package:smarthome/configs/constants/url_constants.dart';
import 'package:smarthome/model/acccount.dart';
import 'package:smarthome/model/token.dart';

class AuthenticationProvider {
  Client client;

  AuthenticationProvider(this.client);

  Future<Token> login(Account account) async {
    try {
      var response = await client.post(URLConstants.login,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(account.toJson()));
      print(URLConstants.login);
      print(response.body);
      print(account.toJson());
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return Token.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }
}
