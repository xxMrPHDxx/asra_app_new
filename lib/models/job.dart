class Job {
  int orderId, itemId, typeId;
  String quotationId;
  int? subJob;
  String orderType, customerName, orderStatus;
  String placeFrom;
  String? placeTo;
  DateTime dateFrom, dateTo;
  double price;
  String link;
  String? flightNumber;
  DateTime? etd, eta;
  double fromLat, fromLon, toLat, toLon;
  String request;
  String? note;
  Job(
    this.orderId,
    this.itemId,
    this.typeId,
    this.quotationId,
    this.orderType,
    this.customerName,
    this.orderStatus,
    this.placeFrom,
    this.placeTo,
    this.dateFrom,
    this.dateTo, {
    this.price = 0,
    this.link = '',
    this.flightNumber,
    this.etd,
    this.eta,
    this.subJob,
    required this.fromLat,
    required this.fromLon,
    required this.toLat,
    required this.toLon,
    required this.request,
    this.note,
  });
}
