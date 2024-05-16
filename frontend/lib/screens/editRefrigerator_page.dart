import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import '../models/hospital.dart';
import '../models/refrigerator.dart';
import 'profile_page.dart';
import 'refrigerator_page.dart';
import 'globals.dart' as globals;

class EditRefrigeratorPage extends StatefulWidget {
  final Refrigerator refrigerator;

  EditRefrigeratorPage({required this.refrigerator});

  @override
  _EditRefrigeratorPageState createState() => _EditRefrigeratorPageState();
}

class _EditRefrigeratorPageState extends State<EditRefrigeratorPage> {
  final _formKey = GlobalKey<FormState>();

  late int? hospital;
  late String name;
  late String modelId;
  late String manufacturer;
  late bool tempMonitorInstalled;
  late String monitorType;
  late bool monitorWorking;
  late bool voltageRegulatorInstalled;
  late String regulatorType;
  late int vaccineCount;

  @override
  void initState() {
    super.initState();
    hospital = widget.refrigerator.hospital;
    name = widget.refrigerator.name;
    modelId = widget.refrigerator.model_id;
    manufacturer = widget.refrigerator.manufacturer;
    tempMonitorInstalled = widget.refrigerator.temp_monitor_installed;
    monitorType = widget.refrigerator.monitor_type;
    monitorWorking = widget.refrigerator.monitor_working;
    voltageRegulatorInstalled = widget.refrigerator.voltage_regulator_installed;
    regulatorType = widget.refrigerator.regulator_type;
    vaccineCount = widget.refrigerator.vaccine_count;
  }

  Future<void> _saveForm() async {
    String user = globals.userId.toString();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Refrigerator newRefrigerator = Refrigerator(
        id: widget.refrigerator.id,
        hospital: hospital,
        name: name,
        model_id: modelId,
        manufacturer: manufacturer,
        temp_monitor_installed: tempMonitorInstalled,
        monitor_type: monitorType,
        monitor_working: monitorWorking,
        voltage_regulator_installed: voltageRegulatorInstalled,
        regulator_type: regulatorType,
        vaccine_count: vaccineCount,
      );
      String jsonBody = jsonEncode(newRefrigerator.toJson());
      jsonBody = "[$jsonBody]";
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/logistics/updateFridge/$user/'), // Assuming there is an id field in the Refrigerator model
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );
      print(response.body);
      _cancel();
    }
  }

  void _cancel() {
    Navigator.of(context).pop();  // Return to the previous page without saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Refrigerator'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                initialValue: modelId,
                decoration: InputDecoration(labelText: 'Model ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the model ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  modelId = value!;
                },
              ),
              TextFormField(
                initialValue: manufacturer,
                decoration: InputDecoration(labelText: 'Manufacturer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the manufacturer';
                  }
                  return null;
                },
                onSaved: (value) {
                  manufacturer = value!;
                },
              ),
              SwitchListTile(
                title: Text('Temperature Monitor Installed'),
                value: tempMonitorInstalled,
                onChanged: (value) {
                  setState(() {
                    tempMonitorInstalled = value;
                  });
                },
              ),
              TextFormField(
                initialValue: monitorType,
                decoration: InputDecoration(labelText: 'Monitor Type'),
                onSaved: (value) {
                  monitorType = value!;
                },
              ),
              SwitchListTile(
                title: Text('Monitor Working'),
                value: monitorWorking,
                onChanged: (value) {
                  setState(() {
                    monitorWorking = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Voltage Regulator Installed'),
                value: voltageRegulatorInstalled,
                onChanged: (value) {
                  setState(() {
                    voltageRegulatorInstalled = value;
                  });
                },
              ),
              TextFormField(
                initialValue: regulatorType,
                decoration: InputDecoration(labelText: 'Regulator Type'),
                onSaved: (value) {
                  regulatorType = value!;
                },
              ),
              TextFormField(
                initialValue: vaccineCount.toString(),
                decoration: InputDecoration(labelText: 'Vaccine Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the vaccine count';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  vaccineCount = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: _cancel,
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
