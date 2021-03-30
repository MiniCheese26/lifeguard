import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lifeguard/database_helper.dart';
import 'package:lifeguard/widgets/action_button.dart';
import 'package:lifeguard/widgets/info.dart';
import 'package:lifeguard/widgets/widget_view.dart';

class ActiveAddress {
  String miningPoolName;
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

  Widget build(BuildContext context) => _HomeView(this);

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.database.then((database) {
      if (database == null) {
        print("fuck");
        return;
      }

      database.rawQuery('SELECT * FROM saved_addresses').then((data) {
        if (data.length == 0) {
          setState(() {
            noAddressesStored = true;
          });
          return;
        }

        database
            .rawQuery("SELECT * FROM saved_addresses WHERE is_default = 1")
            .then((defaultAddress) {
          setState(() {
            activeAddress = new ActiveAddress(
                defaultAddress[0]["pool"].toString(),
                defaultAddress[0]["address"].toString());
          });
        });

        setState(() {
          storedAddresses = data
              .map((e) => new ActiveAddress(
                  e["pool"].toString(), e["address"].toString()))
              .toList();
        });
      });
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
            title: Text(state.appTitle, style: GoogleFonts.lato(),)),
        // body is the majority of the screen.
        body: Info(state.activeAddress),
        floatingActionButton: ActionButton(state.activeAddress));
  }
}
