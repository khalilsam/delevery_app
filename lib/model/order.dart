import 'package:flutter/cupertino.dart';

class Order extends ChangeNotifier  {
  String client;
  String productName;

  double price;
  String adresse;
  String phoneNumber;
  String status;

  Order(this.client, this.productName, this.price, this.adresse,
      this.phoneNumber,this.status);

  void setState(String statut) {
    status = statut;

    notifyListeners();
  }
}
