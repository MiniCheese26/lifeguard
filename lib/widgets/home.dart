import 'dart:async';
import 'dart:collection';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeguard/alerts.dart';

import 'package:lifeguard/database_helper.dart';
import 'package:lifeguard/mining_pools.dart';
import 'package:lifeguard/widgets/action_button.dart';
import 'package:lifeguard/widgets/info.dart';
import 'package:lifeguard/widgets/widget_view.dart';

class ActiveAddress {
  MiningPool? miningPoolName;
  String address;

  ActiveAddress(this.miningPoolName, this.address);
}

class Home extends StatefulWidget {
  @override
  _HomeController createState() => _HomeController();
}

class _HomeController extends State<Home> {
  String appTitle = "No Pools";
  ActiveAddress? activeAddress;
  List<ActiveAddress>? storedAddresses;
  bool noAddressesStored = false;
  Alerts alerts = new Alerts();

  Widget build(BuildContext context) => _HomeView(this);

  @override
  void initState() {
    super.initState();
    _loadDatabaseAsync().then((_) {
      if (activeAddress != null) {
        setState(() {
          appTitle =
              miningPoolPrettyNames[activeAddress!.miningPoolName] ?? appTitle;
        });
      }

      alerts.alertRaised.subscribe((args) {
        if (args != null) {
          //enqueuedAlerts.add(args);

          final snackBar = SnackBar(
            content: Text(args.alert),
            duration: Duration(milliseconds: 2500),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    });
  }

  Future<void> _loadDatabaseAsync() async {
    final database = await DatabaseHelper.instance.database;

    if (database == null) {
      print("fuck");
      return;
    }

    final data = await database.rawQuery('SELECT * FROM saved_addresses');

    if (data.length == 0) {
      setState(() {
        noAddressesStored = true;
      });
      return;
    }

    final defaultAddress = await database
        .rawQuery("SELECT * FROM saved_addresses WHERE is_default = 1");

    setState(() {
      activeAddress = new ActiveAddress(
          EnumToString.fromString(
              MiningPool.values, defaultAddress[0]["pool"].toString()),
          defaultAddress[0]["address"].toString());
    });

    setState(() {
      storedAddresses = data
          .map((e) => new ActiveAddress(
              EnumToString.fromString(MiningPool.values, e["pool"].toString()),
              e["address"].toString()))
          .toList();
    });
  }
}

class _HomeView extends WidgetView<Home, _HomeController> {
  const _HomeView(_HomeController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              tooltip: 'Navigation Menu',
              onPressed: null,
            ),
            title: Text(
              state.appTitle,
              style: GoogleFonts.lato(),
            )),
        // body is the majority of the screen.
        body: Info(this.state.activeAddress, this.state.alerts),
        floatingActionButton:
            ActionButton(state.activeAddress, this.state.alerts));
  }
}
