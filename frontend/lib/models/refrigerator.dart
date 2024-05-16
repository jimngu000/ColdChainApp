class Refrigerator {
  final int? id;
  final int? hospitalId;

  final String name;
  final String model_id;
  final String manufacturer;
  final bool temp_monitor_installed;
  final String monitor_type;
  final bool monitor_working;
  final bool voltage_regulator_installed;
  final String regulator_type;
  final int vaccine_count;


  Refrigerator({this.id, // primary key
                this.hospitalId, required this.name, required this.model_id, required this.manufacturer,
                required this.temp_monitor_installed, required this.monitor_type, required this.monitor_working,
                required this.voltage_regulator_installed, required this.regulator_type, required this.vaccine_count});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hospital_id': hospitalId,
      'name': name,
      'model_id': model_id,
      'manufacturer': manufacturer,
      'temp_monitor_installed': temp_monitor_installed,
      'monitor_type': monitor_type,
      'monitor_working': monitor_working,
      'voltage_regulator_installed': voltage_regulator_installed,
      'regulator_type': regulator_type,
      'vaccine_count': vaccine_count,
    };
  }

  factory Refrigerator.fromMap(Map<String, dynamic> map) => Refrigerator(
    id: map['id'],
    hospitalId: map['hospital_id'],
    name: map['name'],
    model_id: map['model_id'],
    manufacturer: map['manufacturer'],
    temp_monitor_installed: map['temp_monitor_installed'],
    monitor_type: map['monitor_type'],
    monitor_working: map['monitor_working'],
    voltage_regulator_installed: map['voltage_regulator_installed'],
    regulator_type: map['regulator_type'],
    vaccine_count: map['vaccine_count']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'hospital_id': hospitalId,
    'name': name,
    'model_id': model_id,
    'manufacturer': manufacturer,
    'temp_monitor_installed': temp_monitor_installed,
    'monitor_type': monitor_type,
    'monitor_working': monitor_working,
    'voltage_regulator_installed': voltage_regulator_installed,
    'regulator_type': regulator_type,
    'vaccine_count': vaccine_count,
  };

  factory Refrigerator.fromJson(Map<String, dynamic> json) => Refrigerator(
      id: json['id'],
      hospitalId: json['hospital_id'],
      name: json['name'],
      model_id: json['model_id'],
      manufacturer: json['manufacturer'],
      temp_monitor_installed: json['temp_monitor_installed'],
      monitor_type: json['monitor_type'],
      monitor_working: json['monitor_working'],
      voltage_regulator_installed: json['voltage_regulator_installed'],
      regulator_type: json['regulator_type'],
      vaccine_count: json['vaccine_count']
    );

  // for print
  @override
  String toString() {
    return 'Refrigerator{id: $id, hospital_id: $hospitalId, name: $name, model_id: $model_id, manufacturer: '
        '$manufacturer, temp_monitor_installed: $temp_monitor_installed, monitor_type: $monitor_type, '
        'monitor_working: $monitor_working, voltage_regulator_installed: $voltage_regulator_installed, '
        'regulator_type: $regulator_type, vaccine_count: $vaccine_count}';
  }
}