import 'package:delevery_app/model/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
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
  var  _reasons = [
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
   List<DropdownMenuItem<String>> _dropDownMenuItems =[];


  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentReason = _dropDownMenuItems[0].value;
    super.initState();
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String reason in _reasons) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add( DropdownMenuItem(value: reason, child: Text(reason)));
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
                                  Text(orders[index].phoneNumber.toString())
                                ],
                              )
                            ],
                          ),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                  child: IconButton(
                                    onPressed: () {
                                      final phoneCall =
                                          FlutterPhoneState.startPhoneCall(
                                              orders[index]
                                                  .phoneNumber
                                                  .toString());
                                      waitForCompletion(phoneCall);
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

  void orderDelivredPopUP() {
    Navigator.pop(context);
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
          onPressed: () => Navigator.pop(context),
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
  Future<void> _showAlertDialog(context) async {
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
                    onChanged:(value){ changedDropDownItem(value);},
                    onSaved:(value){ changedDropDownItem(value);},
                  ),
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

  waitForCompletion(PhoneCall phoneCall) async {
    await phoneCall.done;
    print("Call is completed");

    Alert(
      context: context,
      type: AlertType.none,
      title: "Commande",
      desc: "",
      buttons: [
        DialogButton(
          child: Text(
            "Livré",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => orderDelivredPopUP(),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Reporté",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
            _showAlertDialog(context);
          }),
          gradient: LinearGradient(colors: [
            Colors.redAccent.shade700,
            Colors.redAccent.shade400,
          ]),
        )
      ],
    ).show();
  }
}
