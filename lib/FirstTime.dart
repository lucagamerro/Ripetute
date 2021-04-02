import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class FirstTimePage extends StatefulWidget {
  final Function() callback;

  FirstTimePage(this.callback);

  @override
  _FirstTimePageState createState() => _FirstTimePageState();
}

class _FirstTimePageState extends State<FirstTimePage> {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Image.asset('assets\\start.png'),
        title: 'Benvenuto!',
        body:
            'Ripetute è un\' applicazione per monitorare l\'allelamento in parete.',
        //footer: Text('Footer Text  here '),
      ),
      PageViewModel(
        image: Image.asset('assets\\timer.png'),
        title: 'Timer',
        body:
            'Nella pagina timer potrai scegliere una tipologia di ripetuta (in secondi), da eseguire.',
      ),
      PageViewModel(
        image: Image.asset('assets\\stat.png'),
        title: 'Statistiche',
        body:
            'Trovarai tutte le statistiche relative ai tui allenamenti nella pagina relativa. Tenendo premuto potrai condividere i successi con gli amici.',
      ),
      PageViewModel(
        image: Image.asset('assets\\end.png'),
        title: 'Fine',
        body:
            'E\' tutto qua! Adesso puoi iniziare ad allenarti con l\'app Ripetute!',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Ripetute in parete',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        )),
      ),
      body: IntroductionScreen(
        globalBackgroundColor: Colors.deepOrange,
        dotsDecorator: DotsDecorator(
          color: Colors.white,
          activeColor: Colors.black,
        ),
        pages: getPages(),
        showNextButton: true,
        showSkipButton: true,
        skip: Text('Salta'),
        done: Text('Finito'),
        //onSkip: () => widget.callback(),
        onDone: () => widget.callback(),
      ),
    );
  }
}
