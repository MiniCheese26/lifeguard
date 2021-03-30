import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeguard/pools.dart';
import 'package:lifeguard/widgets/home.dart';
import 'package:lifeguard/widgets/widget_view.dart';

class AddMiningAddress extends StatefulWidget {
  @override
  _AddMiningAddressController createState() => _AddMiningAddressController();
}

class _AddMiningAddressController extends State<AddMiningAddress> {
  bool? checkboxEnabled = false;
  String? dropDownValue = 'Pools.ethermine';

  @override
  Widget build(BuildContext context) => _AddMiningAddressView(this);

  final formKey = GlobalKey<FormState>();

  onCheckboxChanged(bool? value) {
    setState(() {
      checkboxEnabled = value;
    });
  }

  onDropDownValueChanged(String? value) {
    setState(() {
      dropDownValue = value;
    });
  }

  onAddButtonPressed() {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }
}

class _AddMiningAddressView
    extends WidgetView<AddMiningAddress, _AddMiningAddressController> {
  _AddMiningAddressView(_AddMiningAddressController state) : super(state);

  List<DropdownMenuItem<String>>? _getDropDownItems() {
    List<DropdownMenuItem<String>>? items = List.empty(growable: true);

    for (final value in poolDetails.entries) {
      items.add(DropdownMenuItem(
        child: Text(value.value),
        value: value.key.toString(),
      ));
    }

    return items;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Mining Address',
          style: GoogleFonts.lato(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: this.state.formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) =>
                    value != null && value.isEmpty ? 'Enter an address' : null,
                decoration: InputDecoration(
                    labelText: 'Mining Address',
                    labelStyle: GoogleFonts.lato(),
                    border: UnderlineInputBorder()),
                initialValue: '',
              ),
              CheckboxListTile(
                  value: this.state.checkboxEnabled,
                  onChanged: (value) => this.state.onCheckboxChanged(value),
                  title: Text('Set as default?', style: GoogleFonts.lato()),
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.only(top: 8)),
              DropdownButton<String>(
                value: this.state.dropDownValue,
                style: GoogleFonts.lato(color: Colors.blue),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (value) => this.state.onDropDownValueChanged(value),
                items: _getDropDownItems(),
                isExpanded: true,
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      child: Text(
                        'Add Address',
                        style: GoogleFonts.lato(color: Colors.white),
                      ),
                      onPressed: this.state.onAddButtonPressed(),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff64b450)),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
