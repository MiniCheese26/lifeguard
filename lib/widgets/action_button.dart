import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeguard/widgets/add_mining_address.dart';
import 'package:lifeguard/widgets/home.dart';
import 'package:lifeguard/widgets/widget_view.dart';

class ActionButton extends StatefulWidget {
  final ActiveAddress? activeAddress;

  ActionButton(this.activeAddress, {Key? key}) : super(key: key);

  @override
  _ActionButtonController createState() => _ActionButtonController();
}

class _ActionButtonController extends State<ActionButton> {
  @override
  Widget build(BuildContext context) => _ActionButtonView(this);

  @override
  void initState() {
    super.initState();
  }

  Future<void> onMiningAddressAdd() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddMiningAddress()));
  }
}

class _ActionButtonView
    extends WidgetView<ActionButton, _ActionButtonController> {
  _ActionButtonView(_ActionButtonController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      buttonSize: 56,
      visible: true,
      curve: Curves.bounceIn,
      shape: CircleBorder(),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.black,
      tooltip: 'Action Menu',
      overlayOpacity: 0,
      elevation: 8,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(color: Colors.white),
      children: _getSpeedDialChildren()
    );
  }

  List<SpeedDialChild> _getSpeedDialChildren() {
    List<SpeedDialChild> children = List.empty(growable: true);

    children.add(SpeedDialChild(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        label: 'Add New Mining Address',
        labelStyle: GoogleFonts.lato(color: Colors.white),
        labelBackgroundColor: Colors.blue,
        onTap: () => this.state.onMiningAddressAdd()));

    if (widget.activeAddress != null) {
      children.add(SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          label: 'Remove Mining Address',
          labelStyle: GoogleFonts.lato(color: Colors.black),
          labelBackgroundColor: Colors.red,
          onTap: () => {}),);
      children.add(SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          label: 'Edit Mining Address',
          labelStyle: GoogleFonts.lato(color: Colors.white),
          labelBackgroundColor: Colors.blue,
          onTap: () => {}),);
    }

    return children;
  }
}
