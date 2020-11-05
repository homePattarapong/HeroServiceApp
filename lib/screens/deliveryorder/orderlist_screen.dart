import 'package:flutter/material.dart';
import 'package:heroServiceApp/screens/deliveryorder/list_screen.dart';
import 'package:heroServiceApp/screens/qrcode/mycode_screen.dart';
import 'package:heroServiceApp/screens/qrcode/scanner_screen.dart';

class OrderListScreen extends StatefulWidget {
  OrderListScreen({Key key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> with SingleTickerProviderStateMixin{
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        bottom: TabBar(
          controller: controller, 
          indicatorColor: Colors.blue,
          tabs: [
            Tab(
              text: 'LIST',
            ),
            Tab(
              text: 'MAP',
            )
          ]),
        actions: [_actionRouteMap()],
      ),
      body: TabBarView(
        controller: controller,
        children: [
          ListScreen(),
          MyCodeScreen(),
        ]
      ),
    );
  }

  Widget _actionRouteMap() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/qrcode');
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Row(
          children: [
            Icon(Icons.alt_route_rounded),
          ],
        ),
      ),
    );
  }
}
