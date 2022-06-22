/// Dart import
import 'dart:convert';

/// Package import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

/// DataGrid import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'controllers/table_data_controller.dart';


/// Set employee's data collection to data grid source.
class TableDataGridSource extends DataGridSource {
  TableDataController _tableController = Get.put(TableDataController());

  String tableName;

  /// Creates the employee data source class with required details.
  TableDataGridSource(
      {required this.tableName, required String sampleType}) {
      employees = getEmployees();
      buildDataGridRow(sampleType);
  }

  Future<void> _populateData(String sampleType) async {
    await _generateProductList();
    buildDataGridRow(sampleType);
  }

  /// Instance of an employee.
  List<Employee> employees = <Employee>[];

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  // Populate Data from the json file
  Future<void> _generateProductList() async {
    final String responseBody =
        await rootBundle.loadString('assets/product_data.json');
    final dynamic list =
        await json.decode(responseBody).cast<Map<String, dynamic>>();
    employees = await list
        .map<Employee>((dynamic json) => Employee.fromJson(json))
        .toList() as List<Employee>;
  }

  /// Building DataGridRows
  void buildDataGridRow(String sampleType) {
    dataGridRows = employees.map<DataGridRow>((Employee employee) {
      if (sampleType == 'JSON') {
        return DataGridRow(cells: <DataGridCell<String>>[
          DataGridCell<String>(columnName: 'id', value: employee.id),
          DataGridCell<String>(
              columnName: 'contactName', value: employee.contactName),
          DataGridCell<String>(
              columnName: 'companyName', value: employee.companyName),
          DataGridCell<String>(columnName: 'city', value: employee.city),
          DataGridCell<String>(columnName: 'country', value: employee.country),
          DataGridCell<String>(
              columnName: 'designation', value: employee.designation),
          DataGridCell<String>(
              columnName: 'postalCode', value: employee.postalCode),
          DataGridCell<String>(
              columnName: 'phoneNumber', value: employee.phoneNumber),
        ]);
      } else {
        return DataGridRow(cells: <DataGridCell<String>>[
          DataGridCell<String>(columnName: 'id', value: employee.id),
          DataGridCell<String>(
              columnName: 'contactName', value: employee.contactName),
          DataGridCell<String>(
              columnName: 'companyName', value: employee.companyName),
          DataGridCell<String>(columnName: 'address', value: employee.address),
          DataGridCell<String>(columnName: 'city', value: employee.city),
          DataGridCell<String>(columnName: 'country', value: employee.country),
          DataGridCell<String>(
              columnName: 'designation', value: employee.designation),
          DataGridCell<String>(
              columnName: 'postalCode', value: employee.postalCode),
          DataGridCell<String>(
              columnName: 'phoneNumber', value: employee.phoneNumber),
        ]);
      }
    }).toList();
  }

  // Overrides
  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell dataCell) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Text(dataCell.value.toString()),
      );
    }).toList());
  }

  /// Employee Data collection set.
  List<Employee> getEmployees() {
    return <Employee>[
      Employee(
          id: 'ALFKI',
          contactName: 'Maria Anders',
          companyName: 'Alfreds Futterkiste',
          address: 'Obere Str. 57',
          city: 'Berlin',
          country: 'Germany',
          designation: 'Sales Representative',
          postalCode: '12209',
          phoneNumber: '030-0074321'),
      Employee(
          id: 'ANATR',
          contactName: 'Ana Trujillo',
          companyName: 'Ana Trujillo Emparedados',
          address: 'Avda. de la Constitución 2222',
          city: 'México D.F.',
          country: 'Mexico',
          designation: 'Owner',
          postalCode: '05021',
          phoneNumber: '(5) 555-4729'),
      Employee(
          id: 'ANTON',
          contactName: 'Antonio Moreno',
          companyName: 'Antonio Moreno Taquería',
          address: 'Mataderos  2312',
          city: 'México D.F',
          country: 'Mexico',
          designation: 'Owner',
          postalCode: '05023',
          phoneNumber: '(5) 555-3932'),
      Employee(
          id: 'AROUT',
          contactName: 'Thomas Hardy',
          companyName: 'Around the Horn',
          address: '120 Hanover Sq.',
          city: 'London',
          country: 'UK',
          designation: 'Sales Representative',
          postalCode: 'WA1 1DP',
          phoneNumber: '(71) 555-7788'),
      Employee(
          id: 'BERGS',
          contactName: 'Christina Berglund',
          companyName: 'Berglunds snabbköp',
          address: 'Berguvsvägen  8',
          city: 'Luleå',
          country: 'Sweden',
          designation: 'Order Administrator',
          postalCode: 'S-958 22',
          phoneNumber: '0921-12 34 65'),
      Employee(
          id: 'BLAUS',
          contactName: 'Hanna Moos',
          companyName: 'Blauer See Delikatessen',
          address: 'Forsterstr. 57',
          city: 'Mannheim',
          country: 'Germany',
          designation: 'Sales Representative',
          postalCode: '68306',
          phoneNumber: '0621-08460'),
      Employee(
          id: 'BLONP',
          contactName: 'Frédérique Citeaux',
          companyName: 'Blondel père et fils',
          address: '24, place Kléber',
          city: 'Strasbourg',
          country: 'France',
          designation: 'Marketing Manager',
          postalCode: '67000',
          phoneNumber: '88.60.15.31'),
      Employee(
          id: 'BOLID',
          contactName: 'Martín Sommer',
          companyName: 'Bólido Comidas preparadas',
          address: 'C/ Araquil, 67',
          city: 'Madrid',
          country: 'Spain',
          designation: 'Marketing Manager Owner',
          postalCode: '28023',
          phoneNumber: '(91) 555 22 82'),
      Employee(
          id: 'BONAP',
          contactName: 'Laurence Lebihan',
          companyName: ''' Bon app' ''',
          address: '12, rue des Bouchers',
          city: 'Marseille',
          country: 'France',
          designation: 'Owner',
          postalCode: '13008',
          phoneNumber: '91.24.45.40'),
      Employee(
          id: 'BOTTM',
          contactName: 'Elizabeth Lincoln',
          companyName: 'Bottom-Dollar Markets',
          address: '23 Tsawassen Blvd.',
          city: 'Tsawassen',
          country: 'Canada',
          designation: 'Accounting Manager',
          postalCode: 'T2F 8M4',
          phoneNumber: '(604) 555-4729'),
      Employee(
          id: 'BSBEV',
          contactName: 'Victoria Ashworth',
          companyName: '''B's Beverages''',
          address: 'Fauntleroy Circus',
          city: 'London',
          country: 'UK',
          designation: 'Sales Representative',
          postalCode: 'EC2 5NT',
          phoneNumber: '(71) 555-1212'),
      Employee(
          id: 'CACTU',
          contactName: 'Patricio Simpson',
          companyName: 'Cactus Comidas para llevar',
          address: 'Cerrito 333',
          city: 'Buenos Aires',
          country: 'Argentina',
          designation: 'Sales Agent',
          postalCode: '1010',
          phoneNumber: '(1) 135-5555'),
      Employee(
          id: 'CENTC',
          contactName: 'Francisco Chang',
          companyName: 'Centro comercial Moctezuma',
          address: 'Sierras de Granada 9993',
          city: 'México D.F.',
          country: 'Mexico',
          designation: 'Marketing Manager',
          postalCode: '05022',
          phoneNumber: '0452-076545'),
      Employee(
          id: 'CHOPS',
          contactName: 'Yang Wang',
          companyName: 'Chop-suey Chinese',
          address: 'Hauptstr. 29',
          city: 'Bern',
          country: 'Switzerland',
          designation: 'Owner',
          postalCode: '3012',
          phoneNumber: '(5) 555-3392'),
      Employee(
          id: 'COMMI',
          contactName: 'Pedro Afonso',
          companyName: 'Comércio Mineiro',
          address: 'Av. dos Lusíadas, 23',
          city: 'São Paulo',
          country: 'Brazil',
          designation: 'Sales Associate',
          postalCode: '05432-043',
          phoneNumber: '(11) 555-7647'),
      Employee(
          id: 'CONSH',
          contactName: 'Elizabeth Brown',
          companyName: 'Consolidated Holdings',
          address: 'Berkeley Gardens \n 12  Brewery',
          city: 'London',
          country: 'UK',
          designation: 'Sales Representative',
          postalCode: 'WX1 6LT',
          phoneNumber: '7675-3425'),
      Employee(
          id: 'DRACD',
          contactName: 'Sven Ottlieb',
          companyName: 'Drachenblut Delikatessen',
          address: 'Walserweg 21',
          city: 'Aachen',
          country: 'Germany',
          designation: 'Order Administrator',
          postalCode: '52066',
          phoneNumber: '(71) 555-2282'),
      Employee(
          id: 'DUMON',
          contactName: 'Janine Labrune',
          companyName: 'Du monde entier',
          address: '67, rue des Cinquante Otages',
          city: 'Nantes',
          country: 'France',
          designation: 'Owner',
          postalCode: '44000',
          phoneNumber: '0241-039123'),
      Employee(
          id: 'EASTC',
          contactName: 'Ann Devon',
          companyName: 'Eastern Connection',
          address: '35 King George',
          city: 'London',
          country: 'UK',
          designation: 'Sales Agent',
          postalCode: 'WX3 6FW',
          phoneNumber: '40.67.88.88'),
      Employee(
          id: 'ERNSH',
          contactName: 'Roland Mendel',
          companyName: 'Ernst Handel',
          address: 'Kirchgasse 6',
          city: 'Graz',
          country: 'Austria',
          designation: 'Sales Manager',
          postalCode: '8010',
          phoneNumber: '(71) 555-0297')
    ];
  }
}


/// Class contains properties to hold the detailed information about the employee
/// which will be rendered in datagrid.
class Employee {
  /// Creates the employee info class with required details.
  Employee(
      {required this.id,
      required this.contactName,
      required this.companyName,
      required this.address,
      required this.city,
      required this.country,
      required this.designation,
      required this.postalCode,
      required this.phoneNumber});

  /// Fetch data from json
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        id: json['id'],
        contactName: json['contactName'],
        companyName: json['companyName'],
        address: json['address'],
        city: json['city'],
        country: json['country'],
        designation: json['designation'],
        postalCode: json['postalCode'],
        phoneNumber: json['phoneNumber']);
  }

  /// Id of an employee info.
  final String id;

  /// Contact name of an employee info.
  final String contactName;

  /// Company name of an employee info.
  final String companyName;

  /// Address of an employee info.
  final String address;

  /// City of an employee info.
  final String city;

  /// Country of an employee info.
  final String country;

  /// Designation of an employee info.
  final String designation;

  /// Postal code of an employee info.
  final String postalCode;

  /// Phone number of an employee info.
  final String phoneNumber;
}