// Flutter imports:
import 'package:flutter/material.dart';
import 'package:logistics/models/hospital.dart';

// Project imports:
import '../main.dart';
import '../models/refrigerator.dart';
import '../models/vaccine.dart';
import '../utils/vaccine_db_helper.dart';
import 'profile_page.dart';

import 'package:provider/provider.dart'; // context.watch


class RefrigeratorPage extends StatefulWidget {
  final Hospital hospital;
  const RefrigeratorPage({super.key, required this.hospital});

  @override
  State<RefrigeratorPage> createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage> {
  final VaccineDatabaseHelper _vaccineDatabaseHelper = VaccineDatabaseHelper();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            debugPrint('refrigerator to hospital');
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.hospital.name, textAlign: TextAlign.center,),
            const Spacer(),
            IconButton(
              onPressed: () {
                debugPrint('Refrigerator to profile');
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Vaccine>?>(
        future: _vaccineDatabaseHelper.queryVaccinesByColumnValue('refrigerator_id', widget.hospital.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()),);
          }
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, idx) => VaccineCard(
                vaccine: snapshot.data![idx],
                onDelete: () {
                  setState(() {
                    snapshot.data![idx].refrigeratorId = 0;
                    snapshot.data![idx].other = 'Removed';
                    snapshot.data!.removeAt(idx);
                  });
                  debugPrint('onDelete in refrigerator page run');
                },
              ),
            );
          }
          return const Center(child: Text('No Data'),);
        },
      ),
    );
  }
}

class VaccineCard extends StatefulWidget {
  final Vaccine vaccine;
  final VoidCallback onDelete;
  const VaccineCard({super.key,
    required this.vaccine,
    required this.onDelete,
  });

  @override
  State<VaccineCard> createState() => _VaccineCardState();
}

class _VaccineCardState extends State<VaccineCard> {
  
  final VaccineDatabaseHelper _vaccineDatabaseHelper = VaccineDatabaseHelper();

  // handle TextField
  bool isEditing = false;
  late TextEditingController _amountController;
  late TextEditingController _hospitalController;
  late TextEditingController _refrigeratorController;
  late TextEditingController _otherController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '${widget.vaccine.amount}');
    _hospitalController = TextEditingController(text: widget.vaccine.hospital);
    _refrigeratorController = TextEditingController(text: widget.vaccine.refrigerator);
    _otherController = TextEditingController(text: widget.vaccine.other);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _hospitalController.dispose();
    _refrigeratorController.dispose();
    _otherController.dispose();
    super.dispose();
  }

  // need to change some codes to work with local db
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 2.0,
      child: Column(
        children: [
          Align( // widget for removing the VaccineCard
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  _delete(appState);
                  widget.onDelete();
                }
              ),
            ),
          ),
          Text('Name: ${widget.vaccine.name}'),
          const SizedBox(height: 10,),
          Text('Producer: ${widget.vaccine.producer}'),
          const SizedBox(height: 10,),
          Text('Type: ${widget.vaccine.type}'),
          const SizedBox(height: 10,),
          TextField(
            enabled: isEditing,
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            enabled: isEditing,
            controller: _hospitalController,
            decoration: const InputDecoration(
              labelText: 'Hospital',
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            enabled: isEditing,
            controller: _refrigeratorController,
            decoration: const InputDecoration(
              labelText: 'Refrigerator',
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            enabled: isEditing,
            controller: _otherController,
            decoration: const InputDecoration(
              labelText: 'Other',
            ),
          ),
          const SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: Text(isEditing ? 'Save' : 'Edit'),
                onPressed: () {
                  setState(() {
                    if (isEditing) {
                      _save(appState);
                    }
                    isEditing = !isEditing;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // async func's to syn with the local database
  void _save(MyAppState appState) async {
    int res = await _vaccineDatabaseHelper.updateVaccine(widget.vaccine);
    appState.addVaccine(widget.vaccine); // not sure if this should be inside async func
    if (res != 0) {
      debugPrint('Vaccine info saved successfully');
    } else {
      debugPrint('Error occurs when saving vaccine info');
    }
  }

  void _delete(MyAppState appState) async {
    widget.vaccine.refrigeratorId = 0;
    widget.vaccine.other = 'Removed';
    int res = await _vaccineDatabaseHelper.deleteVaccine(widget.vaccine);
    appState.addVaccine(widget.vaccine);
    if (res != 0) {
      debugPrint('Vaccine info deleted successfully');
    } else {
      debugPrint('Error occurs when deleting vaccine info');
    }
  }
}
