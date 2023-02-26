import 'package:delevery_app/model/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  OrderList({Key? key}) : super(key: key);

  final List<Order> orders = [
    Order("Khalil Samti", "Pc Gamer HP", 3500.00, "Rue 6023 omrane sup",
        "27367724"),
    Order("Habil Amri", "Imprimante epson", 4000.00, "Rue 6023 omrane sup",
        "12345678"),
    Order("Habil Amri", "Souris HP", 40.00, "Rue 6024 omrane sup", "87654321"),
    Order(
        "Habil Amri", "Clavier HP", 4000.00, "Rue 6025 omrane sup", "95862555"),
    Order("Habil Amri", "Ecran samsung", 4000.00, "Rue 6026 omrane sup",
        "25858588")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) => Card(
            elevation: 6,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child:  Text(orders[index].client.toString()),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child:  Text(orders[index].productName.toString()),
                        ),
                      )

                    ],
                  ),
                  Column(
                    children: [
                      Text(orders[index].price.toString()),
                    ],
                  )
                ],
              ),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orders[index].adresse.toString()),
                      Text(orders[index].phoneNumber.toString())
                    ],
                  )
                ],
              ),
              trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.phone),
                    SizedBox(width: 10),
                    Icon(Icons.email)
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
