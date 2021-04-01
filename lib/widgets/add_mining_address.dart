import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeguard/alerts.dart';
import 'package:lifeguard/database_helper.dart';
import 'package:lifeguard/mining_pools.dart';
import 'package:lifeguard/widgets/home.dart';
import 'package:lifeguard/widgets/widget_view.dart';
import 'package:sqflite/sqflite.dart';

class AddMiningAddress extends StatefulWidget {
  final Alerts alerts;

  AddMiningAddress(this.alerts);

  @override
  _AddMiningAddressController createState() => _AddMiningAddressController();
}

class _AddMiningAddressController extends State<AddMiningAddress> {
  bool? checkboxEnabled = false;
  String? dropDownValue = '';
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

        if (db != null) {
          final defaultCount = Sqflite.firstIntValue(await db.rawQuery(
              'SELECT COUNT(*) FROM saved_addresses WHERE is_default = 1'));

          if (defaultCount == 0) {
            setState(() {
              checkboxEnabled = true;
            });
          }

          int newId = -1;
          await db.transaction((txn) async {
            newId = await txn.rawInsert(
                'INSERT INTO saved_addresses(address, pool, is_default) VALUES (?, ?, ?)',
                [
                  miningAddress,
                  dropDownValue,
                  checkboxEnabled ?? false ? '1' : '0'
                ]);
          });

          Navigator.pop(context, {'newId': newId});
        } else {
          // failed snack thing
        }
      }
    }
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

                  final miningPool = EnumToString.fromString(
                      MiningPool.values, this.state.dropDownValue ?? '');

                  if (miningPool != null) {
                    return validateMiningPoolAddress(miningPool, value)
                        ? null
                        : 'Enter a valid address';
                  }

                  return null;
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
                  initialValue: 'ethermine',
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
                          value: EnumToString.convertToString(e.key),
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
                      onPressed: () => this.state.onAddButtonPressed(),
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
