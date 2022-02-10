import 'package:flutter/material.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';

import 'drawer_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget("Help Center", _scaffoldKey),
      drawer: const DrawerScreen(),
    );
  }
}
