import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeguard/database_helper.dart';
import 'package:lifeguard/pools.dart';
import 'package:lifeguard/widgets/home.dart';
import 'package:lifeguard/widgets/widget_view.dart';

class AddMiningAddress extends StatefulWidget {
  @override
  _AddMiningAddressController createState() => _AddMiningAddressController();
}

class _AddMiningAddressController extends State<AddMiningAddress> {
  bool? checkboxEnabled = false;
  String? dropDownValue = 'MiningPool.ethermine';
  String? miningAddress = '';

  @override
  Widget build(BuildContext context) => _AddMiningAddressView(this);

  final formKey = GlobalKey<FormState>();

  onCheckboxSaved(bool? value) {
    setState(() {
      checkboxEnabled = value;
    });
  }

  onDropDownValueSaved(String? value) {
    setState(() {
      dropDownValue = value;
    });
  }

  onTextFieldSaved(String? value) {
    setState(() {
      miningAddress = value;
    });
  }

  onAddButtonPressed() async {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        
        final db = await DatabaseHelper.instance.database;
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
                onSaved: (value) => this.state.onTextFieldSaved(value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter an address';
                  }

                  final valueAsEnum = MiningPool.values.firstWhere((element) =>
                      element.toString() == this.state.dropDownValue);

                  return validateMiningPoolAddress(valueAsEnum, value)
                      ? null
                      : 'Enter a valid address';
                },
                decoration: InputDecoration(
                    labelText: 'Mining Address',
                    labelStyle: GoogleFonts.lato(),
                    border: UnderlineInputBorder()),
                initialValue: '',
              ),
              FormField<bool>(
                onSaved: (value) => this.state.onCheckboxSaved(value),
                initialValue: false,
                builder: (state) {
                  return CheckboxListTile(
                    value: state.value,
                    onChanged: (value) => state.didChange(value),
                    title: Text(
                      'Set as default?',
                      style: GoogleFonts.lato(),
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.only(top: 8),
                  );
                },
              ),
              FormField<String>(
                  initialValue: 'MiningPool.ethermine',
                  onSaved: (value) => this.state.onDropDownValueSaved(value),
                  builder: (state) {
                    return DropdownButton<String>(
                      value: state.value,
                      style: GoogleFonts.lato(color: Colors.blue),
                      underline: Container(height: 2, color: Colors.blue),
                      isExpanded: true,
                      items: miningPoolPrettyNames.entries.map((e) {
                        return DropdownMenuItem<String>(
                          child: Text(e.value),
                          value: e.key.toString(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        state.didChange(value);
                        this.state.onDropDownValueSaved(value);
                      },
                    );
                  }),
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
                      onPressed: () {
                        if (this.state.formKey.currentState != null) {
                          return this.state.formKey.currentState!.validate() ? this.state.onAddButtonPressed() : null;
                        }

                        return null;
                      },
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
