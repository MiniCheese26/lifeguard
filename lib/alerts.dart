import 'package:event/event.dart';

class AlertEventArgs extends EventArgs {
  String alert;

  AlertEventArgs(this.alert);
}

class Alerts {
  final Event<AlertEventArgs> alertRaised = Event<AlertEventArgs>();

  void raiseAlert(AlertEventArgs alertEventArgs) {
    alertRaised.broadcast(alertEventArgs);
  }
}