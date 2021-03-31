import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lifeguard/alerts.dart';

enum RequestTypes {
 GET,
 POST
}

abstract class PoolApi {
  late String apiBase;
  late Map<String,String>? headers;

  Alerts alerts;

  PoolApi(this.alerts);

  Future<int> getMinerBalance(String address);

  @mustCallSuper
  bool checkApiResponse(http.Response? response) {
    if (response == null) {
      return false;
    }

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Uri buildRequestUri(String path, [Map<String, String>? parameters]) {
    if (!path.startsWith('/')) {
      path = '/' + path;
    }

    var url = apiBase + path;

    if (parameters != null) {
      if (path.endsWith('/')) {
        path = path.substring(0, path.length - 1);
      }

      var urlParameters = '?';

      parameters.forEach((key, value) {
        urlParameters += '$key=$value';
      });

      url += urlParameters;
    }

    return Uri.parse(url);
  }

  Future<http.Response?> makeRequest(Uri uri, [String type = 'get', Object? body]) async {
    switch (type.toLowerCase()) {
      case 'get':
        return await http.get(uri, headers: headers);
        break;
      case 'post':
        return await http.post(uri, body: body, headers: headers);
        break;
      default:
        return null;
    }
  }
}