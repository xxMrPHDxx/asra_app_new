import 'package:asra_app_new/models/vehicle.dart';

class Owner {
  int? id;
  String name, ic, bankName, bankNo, phone, address;
  String? gender;
  Vehicle vehicle;
  String icPath, bankStatementPath;
  Owner({
    this.name = '',
    this.ic = '',
    this.bankName = '',
    this.bankNo = '',
    this.gender,
    this.phone = '',
    this.address = '',
    required this.vehicle,
    this.icPath = '',
    this.bankStatementPath = '',
  });
}
