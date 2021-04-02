import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';

class Profile extends StatefulWidget {
  final Function() callback;

  Profile(this.callback);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Box user = Hive.box('user');
  Box stat = Hive.box('stat');
  String selecterSelected = '10';

  void load() async {
    var tmp = await user.get('secondi');

    if (tmp != null) {
      setState(() {
        selecterSelected = tmp.toString();
      });
    } else {
      setState(() {
        selecterSelected = '10';
      });
      await user.put('secondi', '10');
    }
  }

  void clearDatabase() async {
    if (stat != null && user != null) {
      try {
        await stat.clear();
        await user.clear();
        await user.put('secondi', '10');
      } catch (e) {
        print('An error occurred: $e');
      }
    }
  }

  void updateSelecter(String e) async {
    setState(() {
      selecterSelected = e;
    });
    await user.put('secondi', e.toString());
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          children: [
            Text(
              'IMPOSTAZIONI',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            ChangeTime(updateSelecter, selecterSelected),
            Container(
              height: 50,
              child: Center(
                child: GestureDetector(
                  onTap: () => widget.callback(),
                  child: Text('Mostra tutorial'),
                ),
              ),
            ),
            Container(
              height: 50,
              child: Center(
                child: GestureDetector(
                  onTap: () => clearDatabase(),
                  child: Text('Cancella tutti i dati'),
                ),
              ),
            ),
            Container(
              height: 50,
              child: Center(
                child: Text('Email: lucagamerro.savemode@gmail.com'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeTime extends StatefulWidget {
  final Function(String) callback;
  final String value;

  ChangeTime(this.callback, this.value);

  @override
  ChangeTimeState createState() => ChangeTimeState();
}

class ChangeTimeState extends State<ChangeTime> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 18),
      child: Row(
        children: [
          Text('Secondi prima dell\'inizio del timer: '),
          DropdownButton<String>(
            value: widget.value,
            iconSize: 24,
            elevation: 16,
            style: TextStyle(fontSize: 15, color: Colors.black),
            onChanged: (String e) => widget.callback(e),
            items: <String>[
              '0',
              '5',
              '10',
              '20',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
