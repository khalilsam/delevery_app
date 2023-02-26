import 'package:delevery_app/orderList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: Center(
          child: GridView.extent(
        primary: false,
        padding: const EdgeInsets.all(8),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        maxCrossAxisExtent: width / 2,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderList()),
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
                        leading: Image.asset('images/pending.png'),
                        title: const Text('19'),
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
                  MaterialPageRoute(builder: (context) => OrderList()),
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
                        leading: Image.asset('images/success.png'),
                        title: const Text('9'),
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
                MaterialPageRoute(builder: (context) => OrderList()),
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
                      leading: Image.asset('images/cancel.png'),
                      title: const Text('9'),
                      subtitle: const Text('Reported'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderList()),
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
                      leading: Image.asset('images/caisse.png'),
                      title: const Text('9'),
                      subtitle: const Text('Income'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
      drawer: const NavigationDrawer(),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[buildHeader(context), buildMenuItems(context)],
          ),
        ),
      );

  buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  buildMenuItems(BuildContext context) => Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderList()),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderList()),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.pending),
              title: const Text('Pending   (30)'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderList()),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.check_box),
              title: const Text('Delivred     (15)'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderList()),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.report_off),
              title: const Text('Reported   (9)'),
            ),
          ),
        ],
      );
}
