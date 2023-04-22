import 'package:delevery_app/model/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:call_log/call_log.dart';

import 'package:delevery_app/api/ApiClient.dart';

class OrderList extends StatefulWidget {
  OrderList({Key? key, required this.status, required this.pending_status})
      : super(key: key);
  final String pending_status;
  final String status;

  @override
  OrderListState createState() => OrderListState(status, pending_status);
}

List<Order> allOrders = [];

class OrderListState extends State<OrderList> {
  String pending_status;
  String status;

  OrderListState(this.status, this.pending_status);

  List<bool>? showButtons = [];
  TextEditingController editingController = TextEditingController();
  var _reasons = [
    "Client injoinable",
    "Réporté à la demande",
    "Adresse eronnée",
    "numéro eronnée",
    "non contacté",
  ];
  var _currentReason;
  List<Order> orders = [];

  // This list holds the data for the list view

  List<Order> suggestions = [];
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  final ApiClient _apiClient = ApiClient();

  Future<List<Order>> getOrderList(String status) async {
    String? token = await ApiClient.getToken('token');
    Map<String, dynamic> response = await _apiClient.getOrders(status, token);
    return orderFromJson(response);
  }


  @override
  void initState() {
    allOrders.clear();
    orders.clear();
    getOrderList(status).then((value) => setState(() {
          allOrders.addAll(value);
          orders = allOrders;
          for (int i = 0; i < orders.length; i++) {
            showButtons?.add(false);
          }
        }));
    _dropDownMenuItems = getDropDownMenuItems();
    _currentReason = _dropDownMenuItems[0].value;

    super.initState();
  }

  void showHide(int i) {
    setState(() {
      showButtons![i] = !showButtons![i];
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
            },
          )
        ],
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
                child: /*orders
                      .where((order) =>
                          order.pending_status.contains(pending_status))
                      .toList()
                      .isNotEmpty
                  ? */
                    ListView.builder(
                        itemBuilder: (context, index) {
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                title: Wrap(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            child: Text(orders[index]
                                                .client
                                                .toString()),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            child: Text(orders[index]
                                                .productName
                                                .toString()),
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
                                subtitle: Wrap(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(orders[index].adresse.toString()),
                                        Text(orders[index]
                                            .phoneNumber
                                            .toString()),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                            visible: showButtons![index],
                                            child: Container(
                                                child: Row(
                                              children: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () {
                                                    orderDelivredPopUP(
                                                        orders[index], index);
                                                  },
                                                  child: Text("Livré"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor: Colors
                                                              .lightGreenAccent
                                                              .shade700,
                                                          minimumSize:
                                                              Size(100, 40)),
                                                ),
                                                const SizedBox(
                                                  width: 50,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        _showReportedDialog(
                                                            context,
                                                            orders[index],
                                                            index);
                                                      });
                                                    },
                                                    child: Text("Reporté"),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.redAccent
                                                                    .shade700,
                                                            minimumSize:
                                                                Size(100, 40))),
                                              ],
                                            ))),
                                      ],
                                    )
                                  ],
                                ),
                                trailing: Visibility(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                    color:
                                                        Colors.green.shade700,
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
                            );
                        },
                        itemCount: orders.length)
                /*:  const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),*/
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

  void orderDelivredPopUP(Order order, int index) {
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
          onPressed: () async {
            Iterable<CallLogEntry> entries = await CallLog.query(
              number: order.phoneNumber,
              type: CallType.outgoing,
            );
            String? token = await ApiClient.getToken('token');
            if (entries.isNotEmpty) {
              var time = entries.first.timestamp?.toInt() ?? 0;
              _apiClient.saveCallLog(
                  order.id,
                  entries.first.duration.toString(),
                  DateTime.fromMillisecondsSinceEpoch(time).toString(),
                  token);
            }else{
              _apiClient.saveCallLog(
                  order.id,
                  "0",
                  "not called",
                  token);
            }
            _apiClient.updateStatus(order.id, "delivered", "delivered", token);

            setState(() {
              order.setState("delivered");
              orders.removeWhere((element) => element.status != 'in_progress');
              allOrders
                  .removeWhere((element) => element.status != 'in_progress');
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
  Future<void> _showReportedDialog(context, Order order, int index) async {
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
                        onPressed: () async {
                          String? token = await ApiClient.getToken('token');
                          Iterable<CallLogEntry> entries = await CallLog.query(
                            number: order.phoneNumber,
                            type: CallType.outgoing,
                          );
                          if (entries.isNotEmpty) {
                            var time = entries.first.timestamp?.toInt() ?? 0;
                            _apiClient.saveCallLog(
                                order.id,
                                entries.first.duration.toString(),
                                DateTime.fromMillisecondsSinceEpoch(time)
                                    .toString(),
                                token);
                          }else
                            {
                              _apiClient.saveCallLog(
                                  order.id,
                                  "0",
                                  "not called",
                                  token);
                            }
                          _apiClient.updateStatus(order.id, "reported",
                              _currentReason.toString(), token);
                          setState(() {
                            order.setState("reported");
                            orders.removeWhere(
                                (element) => element.status != 'in_progress');
                            allOrders.removeWhere(
                                (element) => element.status != 'in_progress');
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
