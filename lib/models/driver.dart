class Driver {
  int? id;
  String name, email, icNumber, phone, password, address;
  String icPath, licensePath, eHailingLicensePath, eHailingInsurancePath;
  String carInsurancePath, roadTaxPath, carGrantPath;
  Driver({
    this.id,
    this.name = '',
    this.email = '',
    this.icNumber = '',
    this.phone = '',
    this.password = '',
    this.address = '',
    this.icPath = '',
    this.licensePath = '',
    this.eHailingLicensePath = '',
    this.eHailingInsurancePath = '',
    this.carInsurancePath = '',
    this.roadTaxPath = '',
    this.carGrantPath = '',
  });
}
