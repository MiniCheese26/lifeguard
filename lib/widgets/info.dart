import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeguard/alerts.dart';
import 'package:lifeguard/mining_pools.dart';
import 'package:lifeguard/pool_apis/flexpool.dart';
import 'package:lifeguard/pool_apis/pool_api.dart';
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
  PoolApi? poolApi;

  @override
  Widget build(BuildContext context) => _InfoView(this);

  @override
  void initState() {
    super.initState();

    if (this.widget.activeAddress?.miningPoolName != null) {
      switch (this.widget.activeAddress!.miningPoolName) {
        case MiningPool.ethermine:
          // TODO: change on implementation
          poolApi = new FlexpoolApi(this.widget.alerts);
          break;
        case MiningPool.rvnFlypool:
          // TODO: change on implementation
          poolApi = new FlexpoolApi(this.widget.alerts);
          break;
        case MiningPool.flexpool:
          poolApi = new FlexpoolApi(this.widget.alerts);
          break;
        default:
          poolApi = null;
          break;
      }
    }
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
      return Center(
      );
    }
  }
}
