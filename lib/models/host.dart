class Host {
  int? id;
  String profilePic;
  String name, email, icNumber, phone, password, address;
  String? gender;
  String icPath, bankPath;
  Host({
    this.id,
    this.profilePic = '',
    this.name = '',
    this.email = '',
    this.icNumber = '',
    this.gender,
    this.phone = '',
    this.password = '',
    this.address = '',
    this.icPath = '',
    this.bankPath = '',
  });
}
