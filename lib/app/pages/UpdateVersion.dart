import 'package:flutter/material.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateVersionPage extends StatefulWidget {
static final String routeName = 'UpdateVersion';

	@override
	UpdateVersionPageState createState() => new UpdateVersionPageState();

}

class UpdateVersionPageState extends State<UpdateVersionPage> {
	final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	
	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			key: _scaffoldKey,
      appBar: new AppBar(
				title: Center(child: new Text(TranslateStrings.school_Bus(), style: Theme.of(context).textTheme.headline)), //style: TextStyle(color: Colors.pink[400], fontSize: 24.0))),        
           elevation: 0.7,      
			),
			body: nullWidget()
		);
	}

 Widget nullWidget() {
  return new Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          TranslateStrings.updateAppVersion(),
          style: new TextStyle(fontSize: 20.0, color: Theme.of(context).textTheme.display3.color),
        ),
        SizedBox(width: 10.0),
        new Icon(FontAwesomeIcons.frown, color: Theme.of(context).textTheme.display3.color ,
        size: Theme.of(context).textTheme.display3.fontSize * 1.5)
      ],
    ),
  );
}

}