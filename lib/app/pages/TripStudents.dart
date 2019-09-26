import 'package:flutter/material.dart';
import 'package:bus_tracker/app/components/Drawer.dart';
import 'package:bus_tracker/app/components/StudentList.dart';
//import 'package:auth_flow/app/utils/network_utils.dart';

class TripStudentsPage extends StatefulWidget {
	static final String routeName = 'TripStudents';

     final List list;
     final _authToken, _user_id, _username, _role_ID_Level, _schoolID, _schoolBrID;

TripStudentsPage(this.list, this._authToken, this._user_id, this._username, this._role_ID_Level, this._schoolID, this._schoolBrID);

	@override
	State<StatefulWidget> createState() {
		return new _TripStudentsPageState();
	}

}

class _TripStudentsPageState extends State<TripStudentsPage> {
	GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

	@override
	void initState() {
		super.initState();
		
    
	}

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			key: _scaffoldKey,
      drawer: new Drawer(child: new DrawerComponent(widget._username, widget._schoolID, widget._role_ID_Level),),
			appBar: new AppBar(
				title: new Text('Students on Trip'),
			),
			body: new Text("TripStudentsPage TODO: repeare..")// new StudentListField(widget.list),
    );
    }



}