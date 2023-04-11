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
      "27367724","pending"),
  Order("Habil Amri", "Imprimante epson", 4000.00, "Rue 6023 omrane sup",
      "12345678","pending"),
  Order("Habil Amri", "Souris HP", 40.00, "Rue 6024 omrane sup", "87654321","pending"),
  Order("Habil Amri", "Clavier HP", 4000.00, "Rue 6025 omrane sup", "95862555","pending"),
  Order(
      "Habil Amri", "Ecran samsung", 4000.00, "Rue 6026 omrane sup", "25858588","pending"),
  Order(
      "foulen ben foulen", "Ecran toshiba", 3000.00, "Rue 72345 omrane sup", "123456","pending")
];

class OrderListState extends State<OrderList> {
  List<bool> showButtons = [];
  TextEditingController editingController = TextEditingController();
  var _reasons = [
    "Client injoinable",
    "Réporté à la demande",
    "Adresse eronnée",
    "numéro eronnée",
    "non contacté",
  ];
  var _currentReason;

  // This list holds the data for the list view
  List<Order> orders = allOrders;
  List<Order> suggestions = [];
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentReason = _dropDownMenuItems[0].value;
    for (int i = 0; i < orders.length; i++) {
      showButtons.add(false);
    }
    super.initState();
  }

  void showHide(int i) {
    setState(() {
      showButtons[i] = !showButtons[i];
    });
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String reason in _reasons) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(DropdownMenuItem(value: reason, child: Text(reason)));
    }
    return items;
  }

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
              child: orders.where((order) => order.status.contains('pending')).toList().isNotEmpty
                  ? ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 2,
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
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                          orders[index].productName.toString()),
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
                                  Text(orders[index].phoneNumber.toString()),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                      visible: showButtons[index],
                                      child: Container(
                                          child: Row(
                                        children: <Widget>[
                                          ElevatedButton(
                                            onPressed: () {
                                              orderDelivredPopUP(orders[index],index);
                                            },
                                            child: Text("Livré"),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors
                                                    .lightGreenAccent.shade700),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _showReportedDialog(context,orders[index],index);
                                                });
                                              },
                                              child: Text("Reporté"),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .redAccent.shade700)),
                                        ],
                                      ))),
                                ],
                              )
                            ],
                          ),
                          trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Center(
                                        child: IconButton(
                                          onPressed: () {
                                            showHide(index);
                                            _callNumber(orders[index]
                                                .phoneNumber
                                                .toString());
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

  void orderDelivredPopUP(Order order,int index) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Livré",
      desc: "",
      buttons: [
        DialogButton(
          child: Text(
            "Confirmer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            setState(() {
              order.setState("delivered");
              orders.removeWhere((element) => element.status != 'pending');
              allOrders.removeWhere((element) => element.status != 'pending');
              showHide(index);
            });
            Navigator.pop(context);
            },
          color: Colors.lightGreenAccent.shade700,
        ),
        DialogButton(
          child: Text(
            "Fermer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Colors.redAccent.shade700,
            Colors.redAccent.shade400,
          ]),
        )
      ],
    ).show();
  }

  // Alert Dialog function
  Future<void> _showReportedDialog(context,Order order,int index ) async {
    // flutter defined function
    return showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Réporté",
                    style: TextStyle(
                        color: Colors.redAccent.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  DropdownButtonFormField(
                    value: _currentReason,
                    items: _dropDownMenuItems,
                    onChanged: (value) {
                      changedDropDownItem(value);
                    },
                    onSaved: (value) {
                      changedDropDownItem(value);
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            order.setState("reported");
                            orders.removeWhere((element) => element.status != 'pending');
                            allOrders.removeWhere((element) => element.status != 'pending');
                            showHide(index);
                          });
                          Navigator.pop(context);
                          },
                        child: Text("Sauvegarder"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreenAccent.shade700),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () { Navigator.pop(context);},
                          child: Text("Annuler"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.shade700)),
                    ],
                  )
                ],
              )),
        );
      },
    );
  }

  changedDropDownItem(Object? selectedReason) {
    print("Selected reason $selectedReason, we are going to refresh the UI");
    setState(() {
      _currentReason = selectedReason;
      print("_currentReason $_currentReason, we are going to refresh the UI2");
    });
  }
}
