import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lifeguard/alerts.dart';
import 'package:lifeguard/pool_apis/pool_api.dart';
import 'package:http/http.dart' as http;

class FlexpoolApi extends PoolApi {
  @override
  String apiBase = 'https://flexpool.io/api/v1';

  @override
  Map<String, String>? headers = {'accept': 'application/json'};

  FlexpoolApi(Alerts alerts) : super(alerts);

  @override
  Future<int> getMinerBalance(String address) async {
    final requestUri = buildRequestUri('/miner/$address/balance');
    final response = await makeRequest(requestUri);

    if (checkApiResponse(response)) {
      final responseParsed = jsonDecode(response!.body);

      return int.parse(responseParsed["result"]);
    } else {
    }

    return -1;
  }

  @override
  bool checkApiResponse(http.Response? response) {
    if (!super.checkApiResponse(response)) {
      return false;
    }

    return jsonDecode(response!.body)["error"] == null;
  }
}
