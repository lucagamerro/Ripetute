import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/stat.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Box stat = Hive.box('stat');
  Box user = Hive.box('user');
  var tmp, tipoTmp, dataTmp, secondiTmp, quantiTmp, giornoTmp, nomeGiorno;
  int lu = 0;
  int ma = 0;
  int me = 0;
  int gi = 0;
  int ve = 0;
  int sa = 0;
  int dom = 0;
  int dayMax = 0;
  int quantiOggi = 0;
  int secondiOggi = 0;
  int numeroGiorni = 0;
  final List<Stat> datiripetute = <Stat>[];

  void load() async {
    String formatted = '';
    final List<String> dateSett = <String>[];
    final DateTime now = DateTime.now();

    nomeGiorno = DateFormat('EEEE').format(now);
    if (nomeGiorno == 'Monday') {
      numeroGiorni = 1;
    } else if (nomeGiorno == 'Tuesday') {
      numeroGiorni = 2;
    } else if (nomeGiorno == 'Wednesday') {
      numeroGiorni = 3;
    } else if (nomeGiorno == 'Thursday') {
      numeroGiorni = 4;
    } else if (nomeGiorno == 'Friday') {
      numeroGiorni = 5;
    } else if (nomeGiorno == 'Saturday') {
      numeroGiorni = 6;
    } else if (nomeGiorno == 'Sunday') {
      numeroGiorni = 7;
    } else {
      numeroGiorni = 7;
    }

    for (var i = 0; i < numeroGiorni; i++) {
      var day = now.day;
      var month = now.month;
      var year = now.year;
      var dayW, monthW;

      if ((day - i) > 0) {
        dayW = day - i;
      } else {
        switch (month) {
          case 01:
            dayW = 31 - i;
            month = 12;
            year = year - 1;
            break;
          case 02:
            dayW = 31 - i;
            month = 01;
            break;
          case 03:
            dayW = 28 - i;
            month = 02;
            break;
          case 04:
            dayW = 31 - i;
            month = 03;
            break;
          case 05:
            dayW = 30 - i;
            month = 04;
            break;
          case 06:
            dayW = 31 - i;
            month = 05;
            break;
          case 07:
            dayW = 30 - i;
            month = 06;
            break;
          case 08:
            dayW = 31 - i;
            month = 07;
            break;
          case 09:
            dayW = 31 - i;
            month = 08;
            break;
          case 10:
            dayW = 30 - i;
            month = 09;
            break;
          case 11:
            dayW = 31 - i;
            month = 10;
            break;
          case 12:
            dayW = 30 - i;
            month = 11;
            break;
          default:
            dayW = 31 - i;
            month = month - 1;
            break;
        }
      }

      monthW = (month < 10) ? '0$month' : month.toString();
      dayW = (dayW < 10) ? '0$dayW' : dayW.toString();

      final DateTime acc = DateTime.parse('$year-$monthW-$dayW');
      final DateFormat formatter = DateFormat('dd/MM/yy');
      formatted = formatter.format(acc);

      dateSett.add(formatted.toString());
    }

    final DateFormat formatterOggi = DateFormat('dd/MM/yy');
    final String oggi = formatterOggi.format(now);

    for (var i = 0; i < stat.length; i++) {
      tmp = await stat.get(i);

      dataTmp = tmp.data;

      setState(() {
        datiripetute.add(tmp);
      });

      if (tmp.tipo == 'singolo') {
        quantiTmp = 1;
        secondiTmp = 180;
      } else if (tmp.tipo == 'leggero') {
        quantiTmp = 2;
        secondiTmp = 300;
      } else if (tmp.tipo == 'ripetute') {
        quantiTmp = 3;
        secondiTmp = 450;
      } else if (tmp.tipo == 'pazzo') {
        quantiTmp = 5;
        secondiTmp = 900;
      }

      if (dataTmp == oggi) {
        setState(() {
          quantiOggi = quantiOggi + quantiTmp;
          secondiOggi = secondiOggi + secondiTmp;
        });
      }

      if (dateSett.contains(dataTmp)) {
        DateTime d = new DateFormat('dd/MM/yy').parse(dataTmp);
        giornoTmp = DateFormat('EEEE').format(d);

        setState(() {
          if (giornoTmp == 'Monday') {
            lu = lu + quantiTmp;
            dayMax = (lu < dayMax) ? dayMax : lu;
          } else if (giornoTmp == 'Tuesday') {
            ma = ma + quantiTmp;
            dayMax = (ma < dayMax) ? dayMax : ma;
          } else if (giornoTmp == 'Wednesday') {
            me = me + quantiTmp;
            dayMax = (me < dayMax) ? dayMax : me;
          } else if (giornoTmp == 'Thursday') {
            gi = gi + quantiTmp;
            dayMax = (gi < dayMax) ? dayMax : gi;
          } else if (giornoTmp == 'Friday') {
            ve = ve + quantiTmp;
            dayMax = (ve < dayMax) ? dayMax : ve;
          } else if (giornoTmp == 'Saturday') {
            sa = sa + quantiTmp;
            dayMax = (sa < dayMax) ? dayMax : sa;
          } else if (giornoTmp == 'Sunday') {
            dom = dom + quantiTmp;
            dayMax = (dom < dayMax) ? dayMax : dom;
          }
        });
      }
    }
  }

  void shareText(text) {
    Share.share((text == null) ? 'Scarica anche tu ripetute!' : text);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  static const shText = <Shadow>[
    Shadow(
      offset: Offset(5, 2),
      blurRadius: 25,
      color: Colors.black,
    )
  ];

  static const shBox = <BoxShadow>[
    BoxShadow(
      offset: Offset(5, 2),
      blurRadius: 20,
      spreadRadius: -8,
      color: Colors.black,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          children: <Widget>[
            Text(
              'STATISTICHE',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              child: Container(
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        '$secondiOggi',
                        style: TextStyle(
                          fontSize: 80, //35
                          shadows: shText,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'secondi in parete',
                        style: TextStyle(
                          fontSize: 18, //35
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  margin: EdgeInsets.only(left: 20),
                ),
                width: 500,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(28),
                ),
                margin: const EdgeInsets.all(8),
              ),
              onLongPress: () => shareText(
                  'Oggi mi sono allenato per $secondiOggi secondi in parete!'),
            ),
            GestureDetector(
              child: Container(
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        '$quantiOggi',
                        style: TextStyle(
                          fontSize: 80, //35
                          shadows: shText,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'ripetute completate',
                        style: TextStyle(
                          fontSize: 18, //35
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                  margin: EdgeInsets.only(right: 20),
                ),
                width: 500,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(28),
                ),
                margin: const EdgeInsets.all(8),
              ),
              onLongPress: () =>
                  shareText('Oggi ho completato $quantiOggi ripetute!'),
            ),
            //Container(
            //  child: Container(
            //    child: Text(
            //      'settimana',
            //      style: TextStyle(
            //        fontSize: 18,
            //        fontWeight: FontWeight.bold,
            //        color: Colors.black,
            //      ),
            //    ),
            //    margin: EdgeInsets.only(left: 20),
            //  ),
            //  margin: const EdgeInsets.all(8),
            //),
            Container(
              child: AspectRatio(
                aspectRatio: 1.7,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  color: Colors.white,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (dayMax + 2).toDouble(),
                      barTouchData: BarTouchData(
                        enabled: false,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.transparent,
                          tooltipPadding: const EdgeInsets.all(0),
                          tooltipMargin: 8,
                          getTooltipItem: (
                            BarChartGroupData group,
                            int groupIndex,
                            BarChartRodData rod,
                            int rodIndex,
                          ) {
                            return BarTooltipItem(
                              rod.y.round().toString(),
                              TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          margin: 20,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Lu';
                              case 1:
                                return 'Ma';
                              case 2:
                                return 'Me';
                              case 3:
                                return 'Gi';
                              case 4:
                                return 'Ve';
                              case 5:
                                return 'Sa';
                              case 6:
                                return 'Do';
                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(showTitles: false),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              y: lu.toDouble(),
                              colors: [Colors.deepOrange],
                            )
                          ],
                          showingTooltipIndicators: [0],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              y: ma.toDouble(),
                              colors: [Colors.deepOrange],
                            )
                          ],
                          showingTooltipIndicators: [0],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              y: me.toDouble(),
                              colors: [Colors.deepOrange],
                            )
                          ],
                          showingTooltipIndicators: [0],
                        ),
                        BarChartGroupData(
                          x: 3,
                          barRods: [
                            BarChartRodData(
                              y: gi.toDouble(),
                              colors: [Colors.deepOrange],
                            )
                          ],
                          showingTooltipIndicators: [0],
                        ),
                        BarChartGroupData(
                          x: 4,
                          barRods: [
                            BarChartRodData(
                              y: ve.toDouble(),
                              colors: [Colors.deepOrange],
                            )
                          ],
                          showingTooltipIndicators: [0],
                        ),
                        BarChartGroupData(
                          x: 5,
                          barRods: [
                            BarChartRodData(
                              y: sa.toDouble(),
                              colors: [Colors.deepOrange],
                            )
                          ],
                          showingTooltipIndicators: [0],
                        ),
                        BarChartGroupData(
                          x: 6,
                          barRods: [
                            BarChartRodData(
                              y: dom.toDouble(),
                              colors: [Colors.deepOrange],
                            )
                          ],
                          showingTooltipIndicators: [0],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(boxShadow: shBox),
              margin: const EdgeInsets.only(top: 15),
            ),
          ],
        ),
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

//Expanded(
//  child: ListView.builder(
//    padding: const EdgeInsets.all(8),
//    itemCount: datiripetute.length,
//    itemBuilder: (BuildContext context, int index) {
//      return GestureDetector(
//        child: Container(
//          height: 50,
//          child: Text(
//              '${datiripetute[index].tipo} * ${datiripetute[index].data}'),
//        ),
//        onLongPress: () => shareText(
//            'Il ${datiripetute[index].data} ho fatto una ripetuta ${datiripetute[index].tipo}. Scarica anche tu ripetute su Fdroid!'),
//      );
//    },
//  ),
//),
