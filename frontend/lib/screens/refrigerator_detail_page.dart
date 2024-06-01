import 'package:flutter/material.dart';
import '../models/refrigerator.dart';
import 'package:logistics/services/database_service.dart';

Future<void> updateRefrigeratorInDb(Refrigerator refrigerator) async {
  final db = await getDatabase();
  int rowsAffected = await db.update(
    'refrigerators',
    refrigerator.toJson(),
    where: 'id = ?',
    whereArgs: [refrigerator.id],
  );
  // The update operation should go through successfully (aka rows effected = 1)
  if (rowsAffected == 0) {
    throw Exception('Failed to update refrigerator: No rows affected');
  }

  // Update the log.

}

class RefrigeratorDetailPage extends StatefulWidget {
  final Refrigerator refrigerator;

  const RefrigeratorDetailPage({super.key, required this.refrigerator});

  @override
  State<RefrigeratorDetailPage> createState() => _RefrigeratorDetailPageState();
}

class _RefrigeratorDetailPageState extends State<RefrigeratorDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _modelIdController;
  late TextEditingController _manufacturerController;
  late TextEditingController _monitorTypeController;
  late TextEditingController _regulatorTypeController;
  late TextEditingController _vaccineCountController;

  bool _tempMonitorInstalled = false;
  bool _monitorWorking = false;
  bool _voltageRegulatorInstalled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.refrigerator.name);
    _modelIdController = TextEditingController(text: widget.refrigerator.modelId);
    _manufacturerController = TextEditingController(text: widget.refrigerator.manufacturer);
    _monitorTypeController = TextEditingController(text: widget.refrigerator.monitorType);
    _regulatorTypeController = TextEditingController(text: widget.refrigerator.regulatorType);
    _vaccineCountController = TextEditingController(text: widget.refrigerator.vaccineCount.toString());

    _tempMonitorInstalled = widget.refrigerator.tempMonitorInstalled;
    _monitorWorking = widget.refrigerator.monitorWorking;
    _voltageRegulatorInstalled = widget.refrigerator.voltageRegulatorInstalled;
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Update the refrigerator object with new values
      Refrigerator updatedRefrigerator = Refrigerator(
        id: widget.refrigerator.id,
        name: _nameController.text,
        modelId: _modelIdController.text,
        manufacturer: _manufacturerController.text,
        tempMonitorInstalled: _tempMonitorInstalled,
        monitorType: _monitorTypeController.text,
        monitorWorking: _monitorWorking,
        voltageRegulatorInstalled: _voltageRegulatorInstalled,
        regulatorType: _regulatorTypeController.text,
        vaccineCount: int.parse(_vaccineCountController.text),
        hospitalId: widget.refrigerator.hospitalId,
      );

      try {
        // Update the database with new values
        await updateRefrigeratorInDb(updatedRefrigerator);
        // Show a success message or navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Refrigerator details updated successfully')),
        );
      } catch (e) {
        // Handle the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update refrigerator: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.refrigerator.name,
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modelIdController,
                decoration: const InputDecoration(labelText: 'Model ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a model ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _manufacturerController,
                decoration: const InputDecoration(labelText: 'Manufacturer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a manufacturer';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Temperature Monitor Installed'),
                value: _tempMonitorInstalled,
                onChanged: (bool value) {
                  setState(() {
                    _tempMonitorInstalled = value;
                  });
                },
              ),
              TextFormField(
                controller: _monitorTypeController,
                decoration: const InputDecoration(labelText: 'Monitor Type'),
                validator: (value) {
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Monitor Working'),
                value: _monitorWorking,
                onChanged: (bool value) {
                  setState(() {
                    _monitorWorking = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Voltage Regulator Installed'),
                value: _voltageRegulatorInstalled,
                onChanged: (bool value) {
                  setState(() {
                    _voltageRegulatorInstalled = value;
                  });
                },
              ),
              TextFormField(
                controller: _regulatorTypeController,
                decoration: const InputDecoration(labelText: 'Regulator Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a regulator type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vaccineCountController,
                decoration: const InputDecoration(labelText: 'Vaccine Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vaccine count';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
