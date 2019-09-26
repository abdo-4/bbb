import 'dart:async';
import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_tracker/app/components/Drawer.dart';

import 'package:bus_tracker/app/pages/TripSupervisor.dart'; 
import 'package:bus_tracker/app/pages/TripStudents.dart'; 

class AbsentPage extends StatefulWidget {
	static final String routeName = 'Absent';

	@override
	State<StatefulWidget> createState() {
		return new _AbsentPageState();
	}

}

class _AbsentPageState extends State<AbsentPage> {
	GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    var currentTrip ;
    bool tripFromHomeToSchool = true;
    bool _isThereTrip = false;

	SharedPreferences _sharedPreferences;
	var _authToken, _user_id, _username, _role_ID, _schoolID, _schoolBrID, _homeResponse;
  int _role_ID_Level;

	@override
	void initState() {
		super.initState();
		_fetchSessionAndNavigate();
    
	}

	_fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		_authToken = AuthUtils.getToken(_sharedPreferences);
		_role_ID = _sharedPreferences.getString(AuthUtils.roleIDKey);
    _role_ID_Level = _sharedPreferences.getInt(AuthUtils.roleLevelKey);
    _user_id = _sharedPreferences.getString(AuthUtils.userIdKey);
		_username = _sharedPreferences.getString(AuthUtils.nameKey);
    _schoolID = _sharedPreferences.getString(AuthUtils.schoolIDKey);
    _schoolBrID = _sharedPreferences.getString(AuthUtils.schoolBrIDKey);
  
fetchTripData();
	  
	}

 fetchTripData() async{

		var responseJson = await NetworkUtils.fetchTrip(_user_id, _role_ID_Level.toString(), _schoolID, _schoolBrID, _authToken, "Absent_ID" , true,"/Trip/List");
	
      // get TRip from Trip schedule by _id, today, if there record then loadcurrentTrip, else loadCreateNewTrip

			//print("Login Page Line 70, responseJson: " + responseJson);

//print("responseJson: " + responseJson.toString());

			if(responseJson == null) {
        print("SnackBar3");
				NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong on Trip!');

			} else if(responseJson == 'NetworkError') {
        print("SnackBar4");
				NetworkUtils.showSnackBar(_scaffoldKey, "Network Error...");

			} //else if(responseJson['errors'] != null) {
        else if(responseJson['success'] == false) {
        print("SnackBar5");
				NetworkUtils.showSnackBar(_scaffoldKey, 'Server Invalid Data');
        setState(() {
		        _isThereTrip = false;        
		    });
			} else {
        
        //List list = List();
        //list = responseJson as List;

        //print("responseJson:");
        //print(list[0].toString());
       
       setState(() {
		        _isThereTrip = true;
            currentTrip = responseJson;
		    });

        return responseJson;
			}

    }
    



	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			key: _scaffoldKey,
      drawer: new Drawer(child: new DrawerComponent(_username, _schoolID, _role_ID_Level),),
			appBar: new AppBar(
				title: new Text('Students Absent List'),
			),
			body: _loadcurrentTrip()
		);
	}

Widget _loadcurrentTrip()
{
  String tr_Name = currentTrip['trip'][0]['Tr_Name'].toString();
  String tr_Type_Note =  currentTrip['trip'][0]['Tr_Type_Note'].toString();
  String dr_Name =  currentTrip['trip'][0]['Driver_ID']['Dr_Name'].toString();
  String sC_Name_ar = currentTrip['trip'][0]['School_ID']['SC_Name_ar'].toString();
  String br_Name =  currentTrip['trip'][0]['School_Br_ID']['Br_Name'].toString();
  String supervisor_Name =  currentTrip['trip'][0]['Supervisor_ID'][0]['username'].toString();
  List supervisorlist = currentTrip['trip'][0]['Supervisor_ID'];
  List studentslist = currentTrip['trip'][0]['WaypointList'];

return new Container(
				margin: const EdgeInsets.symmetric(horizontal: 16.0),
				child:new Center(
             child:  new ListView.builder(
                                //key: ,
                                  padding: const EdgeInsets.all(15.0),
                                  itemCount: studentslist.length,
                                  itemBuilder: (BuildContext context, int position){
                                  
                                  return new Container
                                  (child: new Column(children: <Widget>[
                                          new ListTile(
                                            title: new Text("Name: ${studentslist[position]['Students']['Student_Name_ar']}",
                                                style: new TextStyle(
                                                    fontSize: 18.9,
                                                    fontWeight: FontWeight.bold)),

                                            subtitle: new Text("Absent From: ${studentslist[position]['Students']['Absent_ID']['From_Date']}",
                                                style: new TextStyle(
                                                    fontSize: 13.4,
                                                    color: Colors.grey,
                                                    fontStyle: FontStyle.italic)),

                                          ),

                                                  new ListTile(
                                            title: new Text("Absent From: ${studentslist[position]['Students']['Absent_ID']['From_Date']}",
                                                style: new TextStyle(
                                                    fontSize: 18.9,
                                                    fontWeight: FontWeight.bold)),

                                            subtitle: new Text("Absent To: ${studentslist[position]['Students']['Absent_ID']['To_Date']}",
                                                style: new TextStyle(
                                                    fontSize: 13.4,
                                                    color: Colors.grey,
                                                    fontStyle: FontStyle.italic)),

                                          ),

                                  ],
                                  ),
                                  );

                                  /*
                                                              
                                  */

                                  }
                              ),


      
            
          ),

);
}


   

   

}