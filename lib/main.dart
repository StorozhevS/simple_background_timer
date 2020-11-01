// import 'dart:js_util';

import 'package:alarm_manager/log_screen.dart';
import 'package:alarm_manager/notificationManager.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

NotificationManager n = new NotificationManager();
int counter = 1;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
    var now = DateTime.now().toIso8601String();
    saveStringToPrefs(null, key: now, value: 'started');
    AndroidAlarmManager.oneShotAt(
        DateTime.now().add(Duration(seconds: 5)), 0, notificate,
        exact: true,
        allowWhileIdle: true,
        wakeup: true,
        rescheduleOnReboot: true,
        alarmClock: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
            child: RaisedButton(
          onPressed: () async {
            // await createPrefsString();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PrefsScreen()));
          },
          child: Text('Show prefs content'),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("${DateTime.now()} =======> start AAM");
          var now = DateTime.now().toIso8601String();
          saveStringToPrefs(null, key: now, value: 'started');
          AndroidAlarmManager.oneShotAt(
            // DateTime.now().add(Duration(seconds: 5)),
            DateTime.now().add(Duration(minutes: 10)),
            0,
            notificate,
            exact: true,
            allowWhileIdle: true,
            wakeup: true,
            rescheduleOnReboot: true,
            alarmClock: true,
          );
        },
      ),
    );
  }
}

void notificate() {
  var now = DateTime.now().toIso8601String();
  print("$now =======> start notificate(${counter++}) ");
  saveStringToPrefs(null, key: now, value: 'notificate');
  n.initNotificationManager();
  n.showNotificationWithDefaultSound("MyTitle", "Body");
  AndroidAlarmManager.oneShotAt(
    // DateTime.now().add(Duration(seconds: 5)),
    DateTime.now().add(Duration(minutes: 10)),
    0,
    notificate,
    exact: true,
    allowWhileIdle: true,
    wakeup: true,
    rescheduleOnReboot: true,
    alarmClock: true,
  );
  return;
}

saveStringToPrefs(SharedPreferences prefs, {String key, String value}) async {
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  await prefs.setString(key, value);
}
