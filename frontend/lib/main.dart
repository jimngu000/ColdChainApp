import 'screens/refrigerator_page.dart';
import 'utils/vaccine_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/district.dart';
import 'models/hospital.dart';
import 'models/refrigerator.dart';
import 'models/vaccine.dart';
import 'screens/menu_page.dart';

void main() async {

  runApp(MyApp());

  // test code
  var v1 = Vaccine(
      name: 'vv1',
      producer: 'vv1p',
      type: 'd',
      amount: 10,
      hospital: 'h1',
      refrigeratorId: 1,
      refrigerator: 'r1',
      other: '');

  final VaccineDatabaseHelper qVaccineDatabaseHelper = VaccineDatabaseHelper();
  await qVaccineDatabaseHelper.insertVaccine(v1);
}

class MyApp extends StatelessWidget {

  MyApp({super.key});

  // test code
  var fido = Refrigerator(
    id: 1,
    name: 'r1',
    hospitalId: 2,
    hospital: 'h1',
    other: 'o1',
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Cold Chain App',
        theme: ThemeData(primarySwatch: Colors.cyan),
        home: SafeArea(
          child: RefrigeratorPage(
            refrigerator: fido,
          ), // this should be login page, not implemented yet
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // lists for synchronization
  var districtList = <District>[];
  var hospitalList = <Hospital>[];
  var refrigeratorList = <Refrigerator>[];
  var vaccineList = <Vaccine>[];

  // not sure if these methods required or if we can update lists in screens codes
  void addDistrict(District district) {
    for (District item in districtList) {
      if (item.id == district.id) {
        districtList.remove(item);
        break;
      }
    }
    districtList.add(district);
    notifyListeners();
  }

  void addHospital(Hospital hospital) {
    for (Hospital item in hospitalList) {
      if (item.id == hospital.id) {
        hospitalList.remove(item);
        break;
      }
    }
    hospitalList.add(hospital);
    notifyListeners();
  }

  void addRefrigerator(Refrigerator refrigerator) {
    for (Refrigerator item in refrigeratorList) {
      if (item.id == refrigerator.id) {
        refrigeratorList.remove(item);
        break;
      }
    }
    refrigeratorList.add(refrigerator);
    notifyListeners();
  }

  void addVaccine(Vaccine vaccine) {
    for (Vaccine item in vaccineList) {
      if (item.id == vaccine.id) {
        vaccineList.remove(item);
        break;
      }
    }
    vaccineList.add(vaccine);
    notifyListeners();
  }
}
