import 'dart:async';

import 'package:event/event.dart';
import 'package:stack/stack.dart';

class AlertEventArgs extends EventArgs {
  String alert;

  AlertEventArgs(this.alert);
}

class Alerts {
  Stack<String> _alerts = Stack();
  Event<AlertEventArgs> _alertEvent = Event<AlertEventArgs>();
  final _duration = Duration(milliseconds: 5000);

  void push(String alert) {
    _alerts.push(alert);
  }

  void subscribe(StreamController sc) {
    _alertEvent.subscribeStream(sc.sink);
  }

  Future run() async {
    new Timer.periodic(_duration, (_) {
      if (_alerts.isNotEmpty) {
        _alertEvent.broadcast(new AlertEventArgs(_alerts.pop()));
      }
    });
  }
}