import 'package:flutter/cupertino.dart';

List<Order> orderFromJson(Map<String, dynamic> json ) {
  return (json['orders'] as List)
      .map((itemOrder) => Order.fromJson(itemOrder))
      .toList();
}
class Order extends ChangeNotifier {
  int id = 0;

  String client = "";
  String productName = "";

  int price = 0;
  String adresse = "";
  String phoneNumber = "";
  String status = "";
  String pending_status ="";

  Order(
      {required this.id,
      required this.client,
      required this.productName,
      required this.price,
      required this.adresse,
      required this.phoneNumber,
      required this.status,
      required this.pending_status});

  void setState(String statut) {
    status = statut;

    notifyListeners();
  }

  factory Order.fromJson(Map<String, dynamic> json) => new Order(
        id: json["id"],
        client: json["rname"],
        productName: json['product_desc'],
        price: json['price'],
        adresse: json['receiver_address'],
        phoneNumber: json['rphone'],
        status: json['status'],
        pending_status: json['pending_status']
      );
}
