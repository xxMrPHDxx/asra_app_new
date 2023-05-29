class Vehicle {
  int? id, ownerId, classId, modelId;
  String plateNo;
  String? status, color;
  String insurancePath, roadTaxPath, ownerApprovalPath;
  String frontView, leftView, rightView, rearView, innerView;
  Vehicle({
    this.id,
    this.ownerId,
    this.classId,
    this.modelId,
    this.plateNo = '',
    this.status,
    this.color,
    this.insurancePath = '',
    this.roadTaxPath = '',
    this.ownerApprovalPath = '',
    this.frontView = '',
    this.leftView = '',
    this.rightView = '',
    this.rearView = '',
    this.innerView = '',
  });
}
