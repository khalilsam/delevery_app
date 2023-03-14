import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportOrderDialog extends StatefulWidget {
  const ReportOrderDialog({super.key});
  @override
  ReportOrderDialogState createState() => new ReportOrderDialogState();

}
List _reasons = [
  "Client Injoignable",
  "Réporté a la demande du client",
  "Adresse eronnée",
  "numéro eronnée",
  "non contacté",
];

class ReportOrderDialogState extends State<ReportOrderDialog>{
  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String reason in _reasons) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: reason, child: new Text(reason)));
    }
    return items;
  }
  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  String? _currentReason;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentReason = _dropDownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  AlertDialog(
          content: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: double.infinity,
              child: Column(
                children: <Widget>[
                  Text(
                    "Zone Selection",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  new DropdownButton(
                    value: _currentReason,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem(_currentReason),
                  ),
                  new Row(
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
  changedDropDownItem(String? selectedReason) {
    print("Selected reason $selectedReason, we are going to refresh the UI");
    setState(() {
      _currentReason = selectedReason;
    });
  }
}

