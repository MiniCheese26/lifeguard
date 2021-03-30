import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lifeguard/pools.dart';
import 'package:lifeguard/widgets/home.dart';

class Address {
  final String address;
  final Pools pool;

  Address({required this.address, required this.pool});

  Map<String, dynamic> toMap() {
    return {'address': address, 'pool': pool};
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'lifeguard',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Home());
  }
}
