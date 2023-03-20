import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fooddataagg/command.dart';
import 'package:fooddataagg/firebase.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Who....cares',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: "title"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  FireBaseDB db = FireBaseDB();
  List<Command> _commands = [];
  double _currentSliderValue = 20;
  double _intervalSliderValue = 3;
  double _delaySliderValue = 8;
  double _amountSliderValue = 20;
  dynamic _value = 0;
  String _data = "";

  void circleButtonPress(String buttonText) {
    bool getSet = false;

    setState(() {
      Command? command = null;
      switch (buttonText) {
        case "Feed now":
          command = instantFeedCommand();
          _value = _currentSliderValue;
          break;
        case "Save settings":
          command = instantFeedCommand();
          _value = _intervalSliderValue;
          _value = _delaySliderValue;
          _value = _amountSliderValue;
          break;
        case "get":
          command = getDataCommand();
          command.executeGet(_data).then((data) {
            setState(() {
              _data = data;
            });
          });
          getSet = true;
      }
      if (command != null) {
        if(getSet == false) {
          command.executeSet(_value);
        }
        _commands.add(command);
      }
      getSet = false;
    });
  }


  Widget buildText(String buttonText){
    return Text(buttonText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget eatingCondition(){
    int number = 41;
    if (number <= 50) {
      return Text('Undereating', style: TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red));
    } else if(number >=90) {
    return Text('Overeating', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red));
      } else if (number >= 51 && number <= 89) {
      return Text('Healthy eating', style: TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green));
    } else {
        return Text('Error', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple));
    }
  }

  Widget refillStatus(){
    int number = 2;
    switch(number) {
      case 0:
        return Text('Empty', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red));
        break; // The switch statement must be told to exit, or it will execute every case.
      case 1:
        return Text('Half full', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.yellow));
        break;
      case 2:
        return Text('Full', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green));
        break;
      default:
        return Text('Error', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple));
    }
  }

  Widget roundButton(String buttonText, double size) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => (circleButtonPress(buttonText)),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(size),
          backgroundColor: Colors.blue, // <-- Button color
          foregroundColor: Colors.white, // <-- Splash color),)
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget statisticsTab() {
    return Column(children: [
      const SizedBox(
        height: 75,
      ),
      Column(children: [
        const Text('Everything is mock data', style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
        Divider(),
        const SizedBox(height: 20),
        buildText('Amount of food given today:'),
        const Text('70g', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        buildText('The average amount of food each week:'),
        const Text('78g', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        buildText('Undereating or overeating:'),
        eatingCondition(),
        buildText('Refill status:'),
        refillStatus(),
      ]),
    ]);
  }

  Widget controlTab() {
    return Column(children: [
      Padding(
          padding: EdgeInsets.only(top: 150.0, bottom: 50.0),
          child: roundButton("Feed now", 90)),
      Column(children: [
        buildText("Choose amount"),
        Slider(
          value: _currentSliderValue,
          max: 50,
          divisions: 10,
          label: "${_currentSliderValue.round()}g",
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
        buildText("Last time fed:"),
        Text(_data),
      ]),
      roundButton("get", 10)
    ]);
  }

  Widget settingsTab() {
    return Column(children: [
      const SizedBox(
        height: 75,
      ),
      Column(children: [
        const Text(
          "Times a day:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: _intervalSliderValue,
          max: 7,
          divisions: 7,
          label: "${_intervalSliderValue.round()} intervals a day",
          onChanged: (double value) {
            setState(() {
              _intervalSliderValue = value;
            });
          },
        ),
        const Text(
          "How many hours in between:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: _delaySliderValue,
          max: 24,
          divisions: 24,
          label: "Every ${_delaySliderValue.round()} hours a day",
          onChanged: (double value) {
            setState(() {
              _delaySliderValue = value;
            });
          },
        ),
        const Text(
          "Amount of food:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: _amountSliderValue,
          max: 50,
          divisions: 25,
          label: "${_amountSliderValue.round()} amount each interval",
          onChanged: (double value) {
            setState(() {
              _amountSliderValue = value;
            });
          },
        ),
      ]),
      roundButton("Save settings", 50)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: "Statistics"),
                Tab(text: "Settings"),
                Tab(text: "Control"),
              ],
            ),
            title: const Text('Feeder 9000'),
          ),
          body: TabBarView(children: [
            statisticsTab(),
            settingsTab(),
            controlTab(),
          ]),
        ),
      ),
    );
  }
}
