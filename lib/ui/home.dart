import 'package:delevery_app/ui/orderList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'NavigationDrawer.dart';
import '../api/ApiClient.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiClient _apiClient = ApiClient();
  int inProgressSize = 0;
  int deliveredSize = 0;
  int reportedSize = 0;

  @override
  initState() {
    super.initState();
    getInprogressData();
    getDeliveredData();
    getReportedData();
  }

  void getInprogressData() async {
    String? token = await ApiClient.getToken('token');
    Map<String, dynamic> inProgress =
        await _apiClient.getOrders('in_progress', token);
    setState(() {
      inProgressSize = inProgress['orders'].length;
    });
  }

  void getDeliveredData() async {
    String? token = await ApiClient.getToken('token');
    Map<String, dynamic> delivered =
        await _apiClient.getOrders('delivered', token);
    setState(() {
      deliveredSize = delivered['orders'].length;
    });
  }

  void getReportedData() async {
    String? token = await ApiClient.getToken('token');
    Map<String, dynamic> reported =
        await _apiClient.getOrders('reported', token);
    setState(() {
      reportedSize = reported['orders'].length;
    });
  }

  @override
  Widget build(BuildContext context) {
    //instance of ApiClient class

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GridView.extent(
                primary: false,
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                maxCrossAxisExtent: width / 2,
                childAspectRatio: (1 / .6),
                shrinkWrap: true,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderList(
                                  status: "in_progress", pending_status: "0")),
                        );
                      },
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.all(4),
                        child: Card(
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading:
                                    Image.asset('assets/images/pending.png'),
                                title: Text(inProgressSize.toString()),
                                subtitle: const Text('Pending'),
                              ),
                            ],
                          ),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderList(
                                  status: "delivered", pending_status: "1")),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Card(
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading:
                                    Image.asset('assets/images/success.png'),
                                title: Text(deliveredSize.toString()),
                                subtitle: const Text('Delivered'),
                              ),
                            ],
                          ),
                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderList(
                                status: "reported", pending_status: "2")),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Card(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Image.asset('assets/images/cancel.png'),
                              title: Text(reportedSize.toString()),
                              subtitle: const Text('Reported'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Card(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Image.asset('assets/images/caisse.png'),
                              title: const Text('9'),
                              subtitle: const Text('Income'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text('Performane',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.normal,
                      fontSize: 40)),
              SizedBox(height: 10),
              CircularPercentIndicator(
                radius: 130.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 15.0,
                percent: 0.4,
                center: new Text(
                  "40%",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: Colors.blueGrey.shade600,
                progressColor: Colors.blue.shade400,
              )
            ],
          ),
        ),
      ),
      drawer: NavigationDrawer(
          inprogress: inProgressSize,
          delivered: deliveredSize,
          reported: reportedSize),
    );
  }
}
