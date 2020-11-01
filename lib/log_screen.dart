import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';

class PrefsScreen extends StatefulWidget {
  @override
  createState() => PrefsScreenState();
}

class PrefsScreenState extends State {
  var text = "";

  @override
  void initState() {
    createPrefsString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Text(text),
        ),
      ),
    );
  }

  createPrefsString() async {
    var prefs = await SharedPreferences.getInstance();
    var list = prefs.getKeys();
    var value = "";
    String rez = "";
    for (var item in list) {
      if (item == "playSound" || item == "timeStampsList") continue;
      try {
        value = prefs.getString(item);
        rez += item + " <--> " + value + "\n";
      } catch (e) {}
    }
    setState(() {
      text = rez;
    });
  }
}
