import 'package:delevery_app/model/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrderList extends StatefulWidget {
  OrderList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  OrderListState createState() => new OrderListState();
}

List<Order> allOrders = [
  Order("Khalil Samti", "Pc Gamer HP", 3500.00, "Rue 6023 omrane sup",
      "27367724"),
  Order("Habil Amri", "Imprimante epson", 4000.00, "Rue 6023 omrane sup",
      "12345678"),
  Order("Habil Amri", "Souris HP", 40.00, "Rue 6024 omrane sup", "87654321"),
  Order("Habil Amri", "Clavier HP", 4000.00, "Rue 6025 omrane sup", "95862555"),
  Order(
      "Habil Amri", "Ecran samsung", 4000.00, "Rue 6026 omrane sup", "25858588")
];

class OrderListState extends State<OrderList> {
  TextEditingController editingController = TextEditingController();

  // This list holds the data for the list view
  List<Order> orders = allOrders;
  List<Order> suggestions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: searchOrders,
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Recherche",
                    hintText: "Recherche",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: orders.isNotEmpty
                  ? ListView.builder(
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
                                      child:
                                          Text(orders[index].client.toString()),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                          orders[index].productName.toString()),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
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
                                  SizedBox(height: 10),
                                  Text(orders[index].phoneNumber.toString())
                                ],
                              )
                            ],
                          ),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: <
                                  Widget>[
                            Center(
                              child: IconButton(
                                onPressed: () {
                                  _callNumber(
                                      orders[index].phoneNumber.toString());
                                  Alert(
                                    context: context,
                                    type: AlertType.none,
                                    title: "",
                                    desc: "",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Livré",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        color: Color.fromRGBO(0, 179, 134, 1.0),
                                      ),
                                      DialogButton(
                                        child: Text(
                                          "Reporté",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        gradient: LinearGradient(colors: [
                                          Colors.redAccent.shade700,
                                          Colors.redAccent.shade400,
                                        ]),
                                      )
                                    ],
                                  ).show();
                                },
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.email,
                              color: Colors.yellow.shade700,
                            )
                          ]),
                        ),
                      ),
                    )
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void searchOrders(String query) async {
    suggestions = allOrders.where((order) {
      final username = order.client.toLowerCase();
      final product = order.productName.toLowerCase();
      final phone = order.phoneNumber.toLowerCase();
      final adresse = order.adresse.toLowerCase();
      final input = query.toLowerCase();
      return username.contains(input) ||
          product.contains(input) ||
          phone.contains(input) ||
          adresse.contains(input);
    }).toList();
    setState(() => orders = suggestions);
  }

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
