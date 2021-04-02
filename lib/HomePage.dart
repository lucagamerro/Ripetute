import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'widgets/TimerPage.dart';
import 'widgets/Statistics.dart';
import 'widgets/Profile.dart';

class HomePage extends StatefulWidget {
  final Function() callback;

  HomePage(this.callback);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentpage;

  void route(int index) async {
    await Hive.openBox('stat');
    await Hive.openBox('user');

    if (index == 0) {
      setState(() {
        currentpage = TimerPage();
      });
    } else if (index == 1) {
      setState(() {
        currentpage = Statistics();
      });
    } else if (index == 2) {
      setState(() {
        currentpage = Profile(widget.callback);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: GestureDetector(
            child: Text(
              'Ripetute in parete',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
            onTap: () => route(0),
          ),
        ),
      ),
      body: Container(
        child: (currentpage == null) ? TimerPage() : currentpage,
        margin: const EdgeInsets.all(12.5),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'statistiche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'impostazioni',
          ),
        ],
        onTap: route,
        backgroundColor: Colors.deepOrange,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
