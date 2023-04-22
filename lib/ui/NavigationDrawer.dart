import 'package:delevery_app/ui/home.dart';
import 'package:delevery_app/ui/main.dart';
import 'package:delevery_app/ui/orderList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer(
      {Key? key,
        required this.inprogress,
        required this.delivered,
        required this.reported})
      : super(key: key);
  final int inprogress;
  final int delivered;
  final int reported;

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
      UserAccountsDrawerHeader(
        accountName: Text('Khalil Samti'),
        accountEmail: Text('samti.khalil@gmail.com'),
        currentAccountPicture: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset('assets/images/profil.png'),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
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
            MaterialPageRoute(
                builder: (context) =>
                    OrderList(status: "in_progress", pending_status: "0")),
          );
        },
        child: ListTile(
          leading: const Icon(Icons.pending),
          title: Text('Pending ($inprogress)'),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderList(status: "delivered", pending_status: "1")),
          );
        },
        child: ListTile(
          leading: const Icon(Icons.check_box),
          title: Text('Delivred     ($delivered)'),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderList(status: "reported", pending_status: "2")),
          );
        },
        child: ListTile(
          leading: const Icon(Icons.report_off),
          title: Text('Reported   ($reported)'),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyLoginPage()),
          );
        },
        child: ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
        ),
      ),
    ],
  );
}