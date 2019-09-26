import 'package:flutter/material.dart';

class Tracker_Screen extends StatelessWidget {
  var currentTrip;
Tracker_Screen(this.currentTrip);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text(
        "Tracker Buses",
        style: new TextStyle(fontSize: 20.0),
      ),
    );
  }
}
