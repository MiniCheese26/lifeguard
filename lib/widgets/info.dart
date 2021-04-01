import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeguard/alerts.dart';
import 'package:lifeguard/widgets/home.dart';
import 'package:lifeguard/widgets/widget_view.dart';

class Info extends StatefulWidget {
  final ActiveAddress? activeAddress;
  final Alerts alerts;

  Info(this.activeAddress, this.alerts, {Key? key}) : super(key: key);

  @override
  _InfoController createState() => _InfoController();
}

class _InfoController extends State<Info> {
  @override
  Widget build(BuildContext context) => _InfoView(this);

  @override
  void initState() {
    super.initState();
  }
}

class _InfoView extends WidgetView<Info, _InfoController> {
  _InfoView(_InfoController state) : super(state);

  @override
  Widget build(BuildContext context) {
    if (this.widget.activeAddress == null) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Add a mining address to get started",
                style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ),
      );
    } else {
      return Center();
    }
  }
}
