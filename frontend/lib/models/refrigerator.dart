class Refrigerator {
  final int? id;
  final int? hospital;

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
                this.hospital, required this.name, required this.model_id, required this.manufacturer,
                required this.temp_monitor_installed, required this.monitor_type, required this.monitor_working,
                required this.voltage_regulator_installed, required this.regulator_type, required this.vaccine_count});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hospital': hospital,
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
    hospital: map['hospital'],
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
    'model': "logistics.Refrigerator",
    'pk': id,
    'fields': {
      'hospital': hospital,
      'name': name,
      'model_id': model_id,
      'manufacturer': manufacturer,
      'temp_monitor_installed': temp_monitor_installed,
      'monitor_type': monitor_type,
      'monitor_working': monitor_working,
      'voltage_regulator_installed': voltage_regulator_installed,
      'regulator_type': regulator_type,
      'vaccine_count': vaccine_count
    }
  };

  factory Refrigerator.fromJson(Map<String, dynamic> json) => Refrigerator(
      id: json['pk'],
      hospital: json["fields"]['hospital'],
      name: json["fields"]['name'],
      model_id: json["fields"]['model_id'],
      manufacturer: json["fields"]['manufacturer'],
      temp_monitor_installed: json["fields"]['temp_monitor_installed'],
      monitor_type: json["fields"]['monitor_type'],
      monitor_working: json["fields"]['monitor_working'],
      voltage_regulator_installed: json["fields"]['voltage_regulator_installed'],
      regulator_type: json["fields"]['regulator_type'],
      vaccine_count: json["fields"]['vaccine_count']
    );

  // for print
  @override
  String toString() {
    return 'Refrigerator{id: $id, hospital: $hospital, name: $name, model_id: $model_id, manufacturer: '
        '$manufacturer, temp_monitor_installed: $temp_monitor_installed, monitor_type: $monitor_type, '
        'monitor_working: $monitor_working, voltage_regulator_installed: $voltage_regulator_installed, '
        'regulator_type: $regulator_type, vaccine_count: $vaccine_count}';
  }
}