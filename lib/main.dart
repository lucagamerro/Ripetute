import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'models/stat.dart';

import 'FirstTime.dart';
import 'HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.registerAdapter(StatAdapter());

  // Better: Hive.initFlutter();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var page;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      setState(() {
        page = HomePage(mostraTutorial);
      });
    } else {
      await prefs.setBool('seen', true);
      // await user.put('secondi', '10');
      setState(() {
        page = FirstTimePage(done);
      });
    }
  }

  void done() {
    setState(() {
      page = HomePage(mostraTutorial);
    });
  }

  void mostraTutorial() {
    setState(() {
      page = FirstTimePage(done);
    });
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ripetute',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: (page != null) ? page : Scaffold(),
    );
  }
}

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.deepOrange,
//      ),
//      debugShowCheckedModeBanner: false,
//      home: HomePage(),
//    );
//  }
//}
