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
    final response = await quickGet('/miner/$address/balance');

    if (checkApiResponse(response)) {
      final responseParsed = jsonDecode(response!.body);

      return int.parse(responseParsed["result"]);
    } else {
      raiseAlert('Failed to get mining balance', response);
    }

    return -1;
  }

  @override
  Future<Hashrates> getHashRates(String address, [String? worker]) async {
    var response;

    if (worker == null || worker.isEmpty) {
      response = await quickGet('/miner/$address/current');
    } else {
      response = await quickGet('/miner/$address/$worker/current');
    }

    if (checkApiResponse(response)) {
      final responseParsed = jsonDecode(response!.body);

      return new Hashrates(int.parse(responseParsed["effective_hashrate"]),
          int.parse(responseParsed["reported_hashrate"]));
    } else {
      raiseAlert('Failed to get current mining hashrate', response);
    }

    return new Hashrates(-1, -1);
  }

  @override
  Future<Shares> getSharesStats(String address, [String? worker]) async {
    var response;

    if (worker == null || worker.isEmpty) {
      response = await quickGet('/miner/$address/stats');
    } else {
      response = await quickGet('/miner/$address/$worker/stats');
    }

    if (checkApiResponse(response)) {
      final responseParsed = jsonDecode(response!.body);

      final validShares = int.parse(responseParsed["daily"]["valid_shares"]);
      final staleShares = int.parse(responseParsed["daily"]["stale_shares"]);
      final invalidShares = int.parse(responseParsed["daily"]["invalid_shares"]);

      return new Shares(validShares, staleShares, invalidShares);
    } else {
      raiseAlert('Failed to get current shares stats', response);
    }

    return new Shares(-1, -1, -1);
  }

  @override
  Future<int> getAverageEffectiveHashrate(String address, [String? worker]) async {
    var response;

    if (worker == null || worker.isEmpty) {
      response = await quickGet('/miner/$address/stats');
    } else {
      response = await quickGet('/miner/$address/$worker/stats');
    }
    
    if (checkApiResponse(response)) {
      final responseParsed = jsonDecode(response!.body);
      
      return int.parse(responseParsed["daily"]["effective_hashrate"]);
    } else {
      raiseAlert('Failed to get average effective hashrate', response);
    }
    
    return -1;
  }

  @override
  Future<List<String>> getWorkers(String address) async {
    final response = await quickGet('/miner/$address/workers');

    if (checkApiResponse(response)) {
      final responseParsed = jsonDecode(response!.body)["result"] as List;

      return responseParsed.map((e) => e["name"].toString()).toList();
    } else {
      raiseAlert('Failed to get workers', response);
    }

    return List.empty();
  }

  @override
  bool checkApiResponse(http.Response? response) {
    if (!super.checkApiResponse(response)) {
      return false;
    }

    return jsonDecode(response!.body)["error"] == null;
  }

  @override
  void raiseAlert(String alertMessage, http.Response? response) {
    if (response == null) {
      alerts.raiseAlert(new AlertEventArgs(alertMessage));
    } else {
      final responseParsed = jsonDecode(response.body)["error"];

      alerts.raiseAlert(new AlertEventArgs('$alertMessage - $responseParsed'));
    }
  }
}
