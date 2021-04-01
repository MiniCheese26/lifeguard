import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lifeguard/alerts.dart';

class Hashrates {
  int effectiveHashrate;
  int reportedHashrate;

  Hashrates(this.effectiveHashrate, this.reportedHashrate);
}

class Shares {
  int validShares;
  int staleShares;
  int invalidShares;

  Shares(this.validShares, this.staleShares, this.invalidShares);
}

abstract class PoolApi {
  late String apiBase;
  late Map<String,String>? headers;

  Alerts alerts;

  PoolApi(this.alerts);

  Future<int> getMinerBalance(String address);
  Future<Hashrates> getHashRates(String address);
  Future<Shares> getSharesStats(String address, [String? worker]);
  Future<int> getAverageEffectiveHashrate(String address, [String? worker]);
  Future<List<String>> getWorkers(String address);
  void raiseAlert(String alertMessage, http.Response? response);

  @mustCallSuper
  bool checkApiResponse(http.Response? response) {
    if (response == null) {
      return false;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
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
      case 'post':
        return await http.post(uri, body: body, headers: headers);
      default:
        return null;
    }
  }

  Future<http.Response?> quickGet(String path) async {
    final requestUri = buildRequestUri(path);
    return await makeRequest(requestUri);
  }
}