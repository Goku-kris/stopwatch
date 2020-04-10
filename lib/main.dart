import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  TabController tb;
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool started = true;
  bool stopped = true;
  int times = 0;
  String timeTod = "";
  bool checkTimer = true;


  @override
  void initState(){
    tb = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  void start(){
    setState(() {
      started = false;
      stopped = false;
    });
    times = ((hour*3600)+(min*60)+sec);
    Timer.periodic(Duration(
      seconds: 1,
    ), (Timer t){
      setState((){
        if(times < 1 || checkTimer == false){
          t.cancel();
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ));
        }
        else if(times < 60){
          timeTod = times.toString();
          times = times-1;
        }else if(times<3600){
          int n = times ~/ 60;
          int s = times - (60*n);
          timeTod = n.toString()+ ":" + s.toString();
          times = times-1;
        }else{
          int h = times ~/ 3600;
          int t = times - (3600*h);
          int n = t ~/ 60;
          int s = t - (60*n);
          timeTod = h.toString()+ ":" + n.toString()+ ":" + s.toString();
          times = times - 1;
        }
      });
    });
  }

  void stop(){
    setState(() {
      started = true;
      stopped = true;
      checkTimer = false;
    });
  }

  Widget timer(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 10.0
                      ),
                      child: Text(
                        "HH",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    NumberPicker.integer(
                        initialValue:  hour,
                        minValue: 0,
                        maxValue: 23,
                        listViewWidth: 60.0,
                        onChanged: (val){
                          setState((){
                            hour = val;
                          });
                        }
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 10.0
                      ),
                      child: Text(
                        "MM",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    NumberPicker.integer(
                        initialValue:  min,
                        minValue: 0,
                        maxValue: 59,
                        listViewWidth: 60.0,
                        onChanged: (val){
                          setState((){
                            min = val;
                          });
                        }
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 10.0
                      ),
                      child: Text(
                        "SS",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    NumberPicker.integer(
                        initialValue:  sec,
                        minValue: 0,
                        maxValue: 59,
                        listViewWidth: 60.0,
                        onChanged: (val){
                          setState((){
                            sec = val;
                          });
                        }
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              timeTod,
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: started ? start : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 10.0,
                  ),
                  color: Colors.blue,
                  child: Text(
                    "Start",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white
                    ),
                  ),
                  shape:StadiumBorder(),
                ),
                RaisedButton(
                  onPressed: stopped ? null : stop,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 10.0,
                  ),
                  color: Colors.blue,
                  child: Text(
                    "Stop",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white
                    ),
                  ),
                  shape: StadiumBorder(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool starts = true;
  bool stops= true;
  bool resets = true;
  String stopDisplay = "00:00:00";
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);

  void startTimer(){
    Timer(dur, keepRun);
  }

  void keepRun(){
    if(swatch.isRunning){
      startTimer();
    }
    setState(() {
      stopDisplay = swatch.elapsed.inHours.toString().padLeft(2,"0") + ":" + (swatch.elapsed.inMinutes % 60).toString().padLeft(2,"0") + ":" + (swatch.elapsed.inSeconds % 60).toString().padLeft(2,"0");
    });
  }

  void startWatch(){
    setState(() {
      stops = false;
      starts = false;
      resets = true;
    });
    swatch.start();
    startTimer();
  }
  void stopWatch(){
    setState(() {
      stops = true;
      resets = false;
      starts = true;
    });
    swatch.stop();
  }
  void resetWatch(){
    setState(() {
      starts = true;
      resets = true;
    });
    swatch.reset();
    stopDisplay = "00:00:00";
  }

  Widget stopwatch(){
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                stopDisplay,
                style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        shape: StadiumBorder(),
                        color: Colors.blue,
                        onPressed: stops ? null : stopWatch,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 15.0,
                        ),
                        child: Text(
                          "Stop",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      RaisedButton(
                        shape: StadiumBorder(),
                        color: Colors.blue,
                        onPressed: resets ? null : resetWatch ,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 15.0,
                        ),
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  RaisedButton(
                    shape: StadiumBorder(),
                    onPressed: starts ? startWatch : null,
                    color: Colors.blue,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 15.0,
                    ),
                    child: Text(
                      "Start",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Timer/Stopwatch"
        ),
        centerTitle: true,
        bottom: TabBar(
          tabs: <Widget>[
            Text(
                "Countdown Timer"
            ),
            Text(
                "Stopwatch"
            ),
          ],
          labelPadding: EdgeInsets.only(
            bottom: 10.0,
          ),
          labelStyle: TextStyle(
            fontSize: 18.0,
          ),
          unselectedLabelColor: Colors.white54,
          controller: tb,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          timer(),
          stopwatch(),
        ],
        controller: tb,
      ),
      backgroundColor: Colors.black,
    );
  }
}
