import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:hive/hive.dart';
import '../models/stat.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  String selecterSelected = 'Leggero (2min + 3min)';
  String frasiMotivatorie = ' ';
  var ripetere = [130, 190];
  int times = 0;
  int counter = 130;
  int counterMax = 130;
  Timer timer;
  AudioPlayer audioPlugin = AudioPlayer();
  Box stat;
  Box user;
  int secondi = 10;

  void load() async {
    stat = await Hive.openBox('stat');
    user = await Hive.openBox('user');

    try {
      var tmp = await user.get('secondi');
      secondi = int.parse(tmp);
    } catch (e) {
      await user.put('secondi', '10');
      secondi = 10;
    }

    setState(() {
      ripetere = [120 + secondi, 190 + secondi];
      counter = 120 + secondi;
      counterMax = counter;
    });
  }

  void updateCounter() async {
    if (selecterSelected == 'Singolo (3min)') {
      ripetere = [(180 + secondi)];
      counter = ripetere[times];
    } else if (selecterSelected == 'Leggero (2min + 3min)') {
      ripetere = [(120 + secondi), (180 + secondi)];
      counter = ripetere[times];
    } else if (selecterSelected == 'Ripetute (2,30min + 2,30min + 2,30min)') {
      ripetere = [
        (150 + secondi),
        (150 + secondi),
        (150 + secondi),
        (150 + secondi)
      ];
      counter = ripetere[times];
    } else if (selecterSelected == 'Pazzo (3min + 3min + 3min + 3min + 3min)') {
      ripetere = [
        (180 + secondi),
        (180 + secondi),
        (180 + secondi),
        (180 + secondi),
        (180 + secondi)
      ];
      counter = ripetere[times];
    }
  }

  void updateFrasi() {
    if (counterMax != null && counter != 0) {
      if (counter >= (counterMax - 9)) {
        frasiMotivatorie = 'Il tempo sta per iniziare...';
      } else if (counter == (counterMax - 10) ||
          counter == (counterMax - 11) ||
          counter == (counterMax - 12)) {
        frasiMotivatorie = 'VIA';
      } else if (counter <= 10 && counter >= 5) {
        frasiMotivatorie = 'Ci sei quasi!';
      } else if (counter <= 2) {
        frasiMotivatorie = 'STOP';
      } else {
        frasiMotivatorie = ' ';
      }
    } else {
      frasiMotivatorie = ' ';
    }
  }

  void updateSelecter(String e) {
    setState(() {
      selecterSelected = e;
      updateCounter();
      frasiMotivatorie = ' ';
      counterMax = counter;

      if (timer != null && timer.isActive == true) {
        timer.cancel();
        times = 0;
      }
    });
  }

  void startTimer() {
    if (counter == counterMax || counter == 0) {
      updateCounter();
      setState(() {
        counterMax = counter;
        frasiMotivatorie = 'Il tempo sta per iniziare...';
      });
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          counter--;
          updateFrasi();
        } else {
          timer.cancel();

          times++;
          if (times == ripetere.length) {
            frasiMotivatorie = 'Hai finito!';
            addRecord();
            times = 0;
          } else if ((ripetere.length - times) == 1) {
            frasiMotivatorie = 'Ancora una ripetuta!';
          } else {
            frasiMotivatorie = 'Ti mancano ' +
                (ripetere.length - times).toString() +
                ' ripetute.';
          }
        }
      });

      // ANIMATION
      //if (counter % 2 == 0) {
      //  setState(() {
      //    _he = 220;
      //    _we = 220;
      //  });
      //} else {
      //  setState(() {
      //    _he = 210;
      //    _we = 210;
      //  });
      //}

      if (counter == (counterMax - 9)) {
        startSound('https://audio-repository.surge.sh/via.mp3');
      } else if (counter == (counterMax / 2)) {
        startSound('https://audio-repository.surge.sh/meta.mp3');
      } else if (counter == 1) {
        startSound('https://audio-repository.surge.sh/stop.mp3');
      }
    });
  }

  void stopTimer() {
    if (timer != null && timer.isActive == true) {
      timer.cancel();
      setState(() {
        frasiMotivatorie = 'Pausa in corso.';
      });
    }
  }

  void resumeTimer() {
    timer.cancel();
    setState(() {
      frasiMotivatorie = ' ';

      if (counter == 0 && times != 0) {
        times = 0;
      }

      updateCounter();
    });
  }

  Future startSound(url) async {
    await audioPlugin.play(url);
  }

  Future stopSound() async {
    await audioPlugin.stop();
  }

  void addRecord() async {
    var tipo;

    if (selecterSelected == 'Singolo (3min)') {
      tipo = 'singolo';
    } else if (selecterSelected == 'Leggero (2min + 3min)') {
      tipo = 'leggero';
    } else if (selecterSelected == 'Ripetute (2,30min + 2,30min + 2,30min)') {
      tipo = 'ripetute';
    } else if (selecterSelected == 'Pazzo (3min + 3min + 3min + 3min + 3min)') {
      tipo = 'pazzo';
    }

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yy');
    final String formatted = formatter.format(now);

    stat.add(Stat(tipo, formatted));
    //stat.put(formatted, tipo);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  void dispose() {
    if (timer != null) {
      timer.cancel();
      stopSound();
    }
    super.dispose();
  }

  double _he = 210;
  double _we = 210;

  static const shText = <Shadow>[
    Shadow(
      offset: Offset(5, 2),
      blurRadius: 25,
      color: Colors.black,
    )
  ];

  //static const shBox = <BoxShadow>[
  //  BoxShadow(
  //    offset: Offset(0, 0),
  //    blurRadius: 18,
  //    color: Colors.black,
  //  )
  //];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          children: <Widget>[
            Text(
              'TIMER',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Selecter(updateSelecter, selecterSelected),
            GestureDetector(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 800),
                curve: Curves.bounceOut,
                width: _he,
                height: _we,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$counter', //$time
                    style: TextStyle(
                      fontSize: 65,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      shadows: shText,
                    ),
                  ),
                ),
              ),
              onTap: () => stopTimer(),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: ElevatedButton(
                      onPressed: () => startTimer(),
                      child: Text(' START '),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.all(5),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () => stopTimer(),
                      child: Text(' STOP '),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.all(5),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () => resumeTimer(),
                      child: Text(' RESET '),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.all(5),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              margin: const EdgeInsets.all(12),
            ),
            Container(
              child: Center(
                child: Text(
                  frasiMotivatorie,
                  style: TextStyle(
                    fontSize: 28, //35
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              margin: const EdgeInsets.all(5),
            ),
          ],
        ),
      ),
    );
  }
}

class Selecter extends StatefulWidget {
  final Function(String) callback;
  final String value;

  Selecter(this.callback, this.value);

  @override
  SelecterState createState() => SelecterState();
}

class SelecterState extends State<Selecter> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.value,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      onChanged: (String e) => widget.callback(e),
      items: <String>[
        'Singolo (3min)',
        'Leggero (2min + 3min)',
        'Ripetute (2,30min + 2,30min + 2,30min)',
        'Pazzo (3min + 3min + 3min + 3min + 3min)',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
