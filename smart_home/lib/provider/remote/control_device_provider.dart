import 'dart:convert';

import 'package:http/http.dart';
import 'package:smarthome/configs/constants/url_constants.dart';

class ControlDeviceProvider {
  final Client client;

  ControlDeviceProvider(this.client);

  Future<bool> sendRPCDeviceRequest(String token, String method, dynamic params,
      {String id = "3e85b630-28a4-11eb-85ee-f936949cce2a"}) async {
    try {
      var response = await client.post("${URLConstants.rpcOneWay}/$id",
          headers: {
            "Content-Type": "application/json",
            "X-Authorization": "Bearer $token"
          },
          body: jsonEncode({"method": method, "params": params}));
      print(response.body);
      if (response.statusCode == 200) {
//        var jsonResponse = jsonDecode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw e;
    }
  }
}
