import 'dart:async';
import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:bus_tracker/app/components/Drawer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

//import 'package:bus_tracker/app/pages/TripSupervisor.dart'; 
//import 'package:bus_tracker/app/pages/TripStudents.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';
import 'package:bus_tracker/app/components/PhoneCall.dart';
//import 'package:bus_tracker/app/requests/maps_requests.dart' as MapRequest;
//import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:bus_tracker/app/states/App_MapState.dart';
import 'package:provider/provider.dart';

class StartTripPage extends StatefulWidget {
	static final String routeName = 'StartTrip';

	@override
	State<StatefulWidget> createState() {
		return new _StartTripPageState();
	}

}

class _StartTripPageState extends State<StartTripPage> {
	GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    var currentTrip ;
    bool tripFromHomeToSchool = null;
    bool _isThereTrip = false;

	SharedPreferences _sharedPreferences;
	var _authToken, _user_id, _username, _role_ID, _schoolID, _schoolBrID, _tripID, _homeResponse;
  int _role_ID_Level;
  var errorMassage = "", _checkConnection = "";

	@override
	void initState() {
		super.initState();
    //print('@@@@@ 11');
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
    _tripID = _sharedPreferences.getString(AuthUtils.tripIDKey);

  fetchTripData();
	  
	}

 fetchTripData() async{
String url = "/ScheduleTrip/TodayTrip";
if(_role_ID_Level == 4) url = "/ScheduleTrip/TodayTrip";
else if(_role_ID_Level == 5) url = "/ScheduleTrip/StudentTodayTrip";

		var responseJson = await NetworkUtils.fetchTrip(_user_id, _role_ID_Level.toString(), _schoolID, _schoolBrID, _authToken,"Guardians_ID", true ,url);
	
      // get TRip from Trip schedule by _id, today, if there record then loadcurrentTrip, else loadCreateNewTrip

			print("Login Page Line 70, responseJson: " + responseJson.toString());
      print("Login Page Line 70, url: " + url.toString());

      //print("*********************** responseJson: " + responseJson.toString());
      errorMassage = _checkConnection = "";

			if(responseJson == "") {
        //print("SnackBar3 fetchTripData");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
        setState(() {
          errorMassage = TranslateStrings.noData();
		        _isThereTrip = false;        
		    });
			} else if(responseJson == 'NetworkError') {
        //print("SnackBar4 fetchTripData");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());
        setState(() {          
          errorMassage = responseJson.toString();
          _checkConnection = TranslateStrings.check_Connection();
		        _isThereTrip = false;        
		    });
			} else if(responseJson == 'Unauthorized') {
        //print("SnackBar4_0 fetchTripData");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.unauthorized_User());
        setState(() {          
          errorMassage = TranslateStrings.unauthorized_User();
		        _isThereTrip = false;        
		    });
			}//else if(responseJson['errors'] != null) {
        else if(responseJson['success'] == false) {
        //print("SnackBar5 fetchTripData");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());
        setState(() {          
          errorMassage = TranslateStrings.server_Invalid_Data();
		        _isThereTrip = false;        
		    });
			}  else if(responseJson['scheduleTrip'] != null) {
        //print("SnackBar6 fetchTripData");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.today_Schedule_Trip());
        setState(() {
          currentTrip = responseJson;
          _isThereTrip = true;
          print("********  Trip1: " + currentTrip.toString());
          insertTripIDDetails(currentTrip['scheduleTrip'][0]['Trip_ID']['_id']);           		                
		    });
      }
      else if(responseJson['trip'] != null) {
        //print("SnackBar7 fetchTripData");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.there_is_no_Schedule_Trip_Today_Select_New_Trip());
        setState(() {
          currentTrip = responseJson;
          _isThereTrip = false;       
          //print("********  Trip2: " + currentTrip.toString()); 
          //insertTripIDDetails(currentTrip['scheduleTrip']['Trip_ID']['_id']); // no trip selected yet, correct path: currentTrip['trip'][0]['_id']       
		    });
      }
        else {
        
        //List list = List();
        //list = responseJson as List;

        //print("responseJson:");
        //print(list[0].toString());
       
       setState(() {
		        //print("responseJson: " + responseJson.toString());
           // currentTrip = responseJson;
           // _isThereTrip = true;
		    });

        return responseJson;
			}

    }
    
	insertTripIDDetails(String _tripID) async {
		_sharedPreferences = await _prefs;
         print("Start Trip save Trip_ID.."); 		 
            _sharedPreferences.setString(AuthUtils.tripIDKey, _tripID);
  }


	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			key: _scaffoldKey,      
      //drawer: new Drawer(child: new DrawerComponent(_username, _schoolID, _role_ID_Level),),
			appBar: new AppBar(
				title: Center(child: Center(child: _isThereTrip ? new Text(TranslateStrings.current_Trip()): new Text(TranslateStrings.start_New_Trip()))),
        actions: <Widget>[
            IconButton(
          icon: Icon(FontAwesomeIcons.syncAlt,  color: Colors.pink[200],),
          onPressed: () {
              //print("**********************  try reload data from server..");
              setState(() {
                   errorMassage = TranslateStrings.wait_msg();  
               });
              fetchTripData();
          },
        )
        ],
			),
			body: _isThereTrip ? _loadcurrentTrip(): _loadCreateNewTrip()
		);
	}

Widget TripListWedget ()
{
new Container(
                padding: EdgeInsets.all(8.0),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        TranslateStrings.select_Trip_Direction_from_below() ,
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      new Divider(height: 5.0, color: Colors.black),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),                    
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Radio(
                            value: 1,
                            groupValue: _radioValue1,
                            onChanged: startTripradioChanged,
                          ),
                          new Text(
                            TranslateStrings.go_to_School(),
                            style: new TextStyle(fontSize: 16.0),
                          ),
                          new Radio(
                            value: 0,
                            groupValue: _radioValue1,
                            onChanged: startTripradioChanged,
                          ),
                          new Text(
                            TranslateStrings.back_to_home(),
                            style: new TextStyle(
                              fontSize: 16.0,
                            ),
                          ),                        
                        ],
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      new Divider(
                        height: 5.0,
                        color: Colors.black,
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      (_role_ID_Level != 3)? new SizedBox(height: 1.0,):
                      new RaisedButton(key:null, onPressed:startTripbuttonPressed,                      
                      color: const Color(0xFFe0e0e0),
                      child:
                        new Text(
                        TranslateStrings.start_Trip(),
                          style: new TextStyle(fontSize:18.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w800,
                          fontFamily: "Roboto"),
                        )
                      ),
                    ]));
}

int _radioValue1 = -1;
Widget _loadCreateNewTrip()
{

  if(currentTrip == null)
  {
      return new Center( child: new Text(
                    TranslateStrings.noData() + _checkConnection + errorMassage,
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ));
  }

  //print("=============================================================================");
  //print("============================================================================="); 
  //print(_role_ID_Level.toString());
int j =0;
  print("currentTrip:" + currentTrip.toString());
return new ListView.builder(
      itemCount: currentTrip['trip'].length,
      itemBuilder: (context, i) => new Column(
            children: <Widget>[   
               new Divider(
                height: 10.0,
              ),
              new Card(
                color: Colors.yellow[100],
                child:  new Column(
              children: <Widget>[
              new ListTile(
                /*
                leading: new CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  //backgroundImage: new NetworkImage("dummyData[i].avatarUrl"),
                ),
                */
                leading: Icon(Icons.album, color:  Colors.pink[300],),
                title: new Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: new Text(
                        currentTrip['trip'][i]['Tr_Name_ar'].toString(),
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: new Text(
                        currentTrip['trip'][i]['Tr_Name_en'].toString(),
                        style: new TextStyle(color: Colors.black54, fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
                subtitle: new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getSchoolWidget(currentTrip['trip'][i]).toList(),),
                ),
              ),

              
                            SizedBox(height: 5.0),
                            ListTile(
                            leading: Icon(Icons.album, color:  Colors.pink[300],),
                            //title: Text(TranslateStrings.school() + ": " + sC_Name_ar),
                            //subtitle: Text(TranslateStrings.branch() + ": " + br_Name),
                            title: new Column(                             
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: getSupervisor(currentTrip['trip'][i]).toList(),
                              ),
                            ),    
                            
                                SizedBox(height: 5.0),
 ListTile(
                            leading: Icon(Icons.album, color:  Colors.pink[300],),
                            //title: Text(TranslateStrings.school() + ": " + sC_Name_ar),
                            //subtitle: Text(TranslateStrings.branch() + ": " + br_Name),
                            title: new Column(                              
                              crossAxisAlignment: CrossAxisAlignment.start, 
                              children: <Widget> [
                                //new Text( currentTrip['trip'][i]['Driver_ID']['Name'].toString()),
                                new Text(TranslateStrings.driver() + ": " + (currentTrip['trip'][i]['Driver_ID'] != null ? currentTrip['trip'][i]['Driver_ID']['Name'].toString(): "")),
                                
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                  new Text(TranslateStrings.contact() + ": " + (currentTrip['trip'][i]['Driver_ID'] != null  && currentTrip['trip'][i]['Driver_ID']['Phone'] != null
                                      && currentTrip['trip'][i]['Driver_ID']['Phone'].toString() != "" ? currentTrip['trip'][i]['Driver_ID']['Phone'].toString(): "")),
                                  IconButton(
                                      icon: new Icon(FontAwesomeIcons.phone, size: 18),
                                      color: currentTrip['trip'][i]['Driver_ID'] != null && currentTrip['trip'][i]['Driver_ID']['Phone'] != null
                                      && currentTrip['trip'][i]['Driver_ID']['Phone'].toString() != ""? Colors.pink[300]: Colors.grey,                      
                                      onPressed: () {
                                      //TODO: Make a Call
                                      if(currentTrip['trip'][i]['Driver_ID'] != null && currentTrip['trip'][i]['Driver_ID']['Phone'] != null
                                      && currentTrip['trip'][i]['Driver_ID']['Phone'].toString() != "") phoneCall(currentTrip['trip'][i]['Driver_ID']['Phone'].toString());
                                      },
                                  ),
                                  new SizedBox(height: 1.0,),
                                  IconButton(
                                      icon: new Icon(FontAwesomeIcons.sms, size: 18),
                                      color: currentTrip['trip'][i]['Driver_ID'] != null && currentTrip['trip'][i]['Driver_ID']['Phone'] != null
                                      && currentTrip['trip'][i]['Driver_ID']['Phone'].toString() != ""? Colors.pink[300]: Colors.grey,                       
                                      onPressed: () {
                                      //TODO: Make a SMS
                                      if(currentTrip['trip'][i]['Driver_ID'] != null && currentTrip['trip'][i]['Driver_ID']['Phone'] != null
                                      && currentTrip['trip'][i]['Driver_ID']['Phone'].toString() != "") sms(currentTrip['trip'][i]['Driver_ID']['Phone']);
                                      },
                                  ),
                                    ],
                                ),                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(TranslateStrings.rating()),
                                     FlutterRatingBar(
                                          initialRating: dr_Rating,
                                          allowHalfRating: false,
                                          ignoreGestures: false,
                                          tapOnlyMode: false,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                          fillColor: currentTrip['trip'][i]['Driver_ID'] != null ? Colors.pink[200]: Colors.grey,
                                          borderColor: currentTrip['trip'][i]['Driver_ID'] != null ? Colors.pink[200]: Colors.grey,
                                          enableTap:  _role_ID_Level != 4 && currentTrip['trip'][i]['Driver_ID'] != null,
                                          //textDirection:
                                          //_isRTLMode ? TextDirection.rtl : TextDirection.ltr,
                                          /*fullRatingWidget:
                                              _customize ? _image("assets/heart.png") : null,
                                          halfRatingWidget:
                                              _customize ? _image("assets/heart_half.png") : null,
                                          noRatingWidget:
                                              _customize ? _image("assets/heart_border.png") : null,*/
                                          onRatingUpdate: (rating) {
                                            if (currentTrip['trip'][i]['Driver_ID'] != null ) 
                                            setState(() {
                                              if(_role_ID_Level != 4){
                                              dr_Rating = rating;
                                              print("driverRating: "+ dr_Rating.toString());
                                              saveRating(currentTrip['trip'][i]['School_ID'], rating, "/ScheduleTrip/UpdateDriverRating");
                                              }
                                            });                                            
                                          }
                                          ),   
                                  ],
                                ),
                                        
                              ],
                              ),
                            ),                      
                            
                            SizedBox(height: 5.0),
                            ListTile(
                                leading: Icon(Icons.album, color:  Colors.pink[300],),
                                title: Row(
                                  children: <Widget>[
                                    Text(TranslateStrings.bus() + ": "),
                                          FlutterRatingBar(
                                          initialRating: bus_Rating,
                                          allowHalfRating: false,
                                          ignoreGestures: false,
                                          tapOnlyMode: false,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                          fillColor: Colors.pink[200],
                                          borderColor: Colors.pink[200],
                                          enableTap:  _role_ID_Level != 4,
                                          //textDirection:
                                          //_isRTLMode ? TextDirection.rtl : TextDirection.ltr,
                                          /*fullRatingWidget:
                                              _customize ? _image("assets/heart.png") : null,
                                          halfRatingWidget:
                                              _customize ? _image("assets/heart_half.png") : null,
                                          noRatingWidget:
                                              _customize ? _image("assets/heart_border.png") : null,*/
                                          onRatingUpdate: (rating) {        
                                             if(_role_ID_Level != 4){                                    
                                                setState(() {
                                                  bus_Rating = rating;
                                                  print("Bus Rating: "+ bus_Rating.toString());
                                                  saveRating(currentTrip['trip'][i]['School_ID'], rating, "/ScheduleTrip/UpdateBusRating");
                                                });                      
                                             }                      
                                          }
                                          ),                                         
                                    /*  new IconButton(icon: new Icon(FontAwesomeIcons.save, color: dr_Name != "" ? Colors.pink[300]: Colors.grey),
                                      onPressed: () => {
                                        //TODO: save Driver Rating in DB.
                                        //saveDriverRating(sch_id)
                                        //fetchTripData()
                                      },)*/
                                  ],
                                ),
                                //subtitle: Text("Supervisor: " + supervisor_Name),
                              ),
                 new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Radio(
                            value: j++,
                            groupValue: _radioValue1,
                            onChanged: startTripradioChanged,
                            activeColor: Colors.pink,
                          ),
                          new Text(
                            TranslateStrings.go_to_School(),
                            style: new TextStyle(fontSize: 16.0),
                          ),
                          new Radio(
                            value:  j++,
                            groupValue: _radioValue1,
                            onChanged: startTripradioChanged,
                            activeColor: Colors.pink,
                          ),
                          new Text(
                            TranslateStrings.back_to_home(),
                            style: new TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                                                  
                        ],
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                    (_role_ID_Level != 3)? SizedBox(height: 1.0,):
                    new RaisedButton(key:null, onPressed: () async{
                    //print("_id: "+ currentTrip['trip'][i]['_id'].toString());
                    if(tripFromHomeToSchool != null){
//                    print("_radioValue1: "+ _radioValue1.toString());
                    
                    var responseJson = await NetworkUtils.startTrip(_user_id, _role_ID_Level.toString(), _schoolID, _schoolBrID,currentTrip['trip'][i]['_id'].toString(),"", tripFromHomeToSchool, "/ScheduleTrip/Add", _authToken);
                    if(responseJson == null) {
                      //print("SnackBar6 _loadCreateNewTrip");
                      //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
                    } else if(responseJson == 'NetworkError') {
                      //print("SnackBar4 _loadCreateNewTrip");
                      //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());
                    } //else if(responseJson['errors'] != null) {
                      else if(responseJson['success'] == false) {
                      //print("SnackBar5 _loadCreateNewTrip");
                      //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());
                      setState(() {
                          _isThereTrip = false;        
                      });
                    } else {
                      //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ChangePasswordPage()));
                      //Navigator.of(_scaffoldKey.currentContext)
                        //.pushReplacementNamed('StartTrip');
                      Navigator.of(_scaffoldKey.currentContext)
                        .pushReplacementNamed("/");

                      return responseJson;
                    }
                    }else{
                      //print("_radioValue1: "+ _radioValue1.toString());
                      //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.tripFromHomeToSchool_isNull());
                    }

                  },                      
                            color: Colors.pink[200],
                            child:
                              new Text(
                              TranslateStrings.start_Trip(),
                                style: new TextStyle(fontSize:18.0,
                                color: const Color(0xFF000000),
                                fontWeight: FontWeight.w800,
                                fontFamily: "Roboto"),
                              ),
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                            ),
            ]),         
              
              ),
               
               new Divider(
                height: 10.0,
              ),

            ],
          ),
    );
}
double dr_Rating = 0, bus_Rating =0;

Widget _loadcurrentTrip()
{
  //print("_loadcurrentTrip");

  if(currentTrip == null )
  {
    //print("currentTrip = null");
      return null;
  }
 
  //print("currentTrip2: " + currentTrip.toString());

  var scheduleTripList;
  if(currentTrip['scheduleTrip'] != null)
  {
     //print("currentTrip['scheduleTrip'] != null" );
  scheduleTripList = currentTrip['scheduleTrip'][0];
    
  }
  else if(currentTrip['scheduletrip'] != null)
  {  
    //print("currentTrip['scheduletrip'] != null" );
    scheduleTripList = currentTrip['scheduletrip'];  
  }
  else
  {
    return null;
  }

  String sch_id = scheduleTripList['_id'].toString();
  //String trip_id = scheduleTripList['Trip_ID']['_id'].toString();
  String tr_Name = scheduleTripList['Trip_ID']['Tr_Name_ar'].toString();
  String tr_Type_Note =  scheduleTripList['Tr_Type_Note'].toString();
  String dr_Name =  scheduleTripList['Driver_ID'] != null? scheduleTripList['Driver_ID']['Dr_Name_ar'].toString(): "";
  String dr_Contact =  scheduleTripList['Driver_ID'] != null? scheduleTripList['Driver_ID']['Phone'].toString(): "";
  dr_Rating =  dr_Name != "" && scheduleTripList['Driver_Rating'] != null? double.parse(scheduleTripList['Driver_Rating'].toString()): 0;
  bus_Rating =  scheduleTripList['Bus_Rating'] != null? double.parse(scheduleTripList['Bus_Rating'].toString()): 0;
  String sC_Name_ar = scheduleTripList['School_ID']['SC_Name_ar'].toString();
  String br_Name =  scheduleTripList['School_Br_ID'] != null? scheduleTripList['School_Br_ID']['Br_Name'].toString(): "";
  ////String supervisor_Name =  scheduleTripList['Supervisor_ID'][0]['username'].toString();
  //List supervisorlist = scheduleTripList['Supervisor_ID'];
  //List studentslist = scheduleTripList['WaypointList'];
  String scheduleTrip = TranslateStrings.finish_Trip();

  return new Container(
				margin: const EdgeInsets.symmetric(horizontal: 16.0),
				child:new ListView(
          children: <Widget>[  
                 new Divider(height: 16.0),
                 new Center(
                    child: Card(
                      color: Colors.yellow[100],
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.album, color:  Colors.pink[300],),
                            title: Text(TranslateStrings.trip() + ": " + tr_Name),
                            subtitle: Text(TranslateStrings.trip_Note() + ": " + tr_Type_Note),
                          ),
                          SizedBox(height: 5.0),
                           
                           ListTile(
                            leading: Icon(Icons.album, color:  Colors.pink[300],),
                            //title: Text(TranslateStrings.school() + ": " + sC_Name_ar),
                            //subtitle: Text(TranslateStrings.branch() + ": " + br_Name),
                            title: new Column(                              
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: getSchoolWidget(scheduleTripList).toList(), 
                              ),
                            ),    
                            SizedBox(height: 5.0),
                            ListTile(
                            leading: Icon(Icons.album, color:  Colors.pink[300],),
                            //title: Text(TranslateStrings.school() + ": " + sC_Name_ar),
                            //subtitle: Text(TranslateStrings.branch() + ": " + br_Name),
                            title: new Column(                             
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: getSupervisor(scheduleTripList).toList(),
                              ),
                            ),    
                            SizedBox(height: 5.0),
                            ListTile(
                            leading: Icon(Icons.album, color:  Colors.pink[300],),
                            //title: Text(TranslateStrings.school() + ": " + sC_Name_ar),
                            //subtitle: Text(TranslateStrings.branch() + ": " + br_Name),
                            title: new Column(                              
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget> [
                                Text(TranslateStrings.driver() + ": " + dr_Name),
                                
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                  new Text(TranslateStrings.contact() + ": " + dr_Contact),
                                  IconButton(
                                      icon: new Icon(FontAwesomeIcons.phone, size: 18),
                                      color: (dr_Contact != "") ? Colors.pink[300]: Colors.grey,                      
                                      onPressed: () {
                                      //TODO: Make a Call
                                      if(dr_Contact != "") phoneCall(dr_Contact);
                                      },
                                  ),
                                  new SizedBox(height: 1.0,),
                                  IconButton(
                                      icon: new Icon(FontAwesomeIcons.sms, size: 18),
                                      color: (dr_Contact != "") ? Colors.pink[300]: Colors.grey,                       
                                      onPressed: () {
                                      //TODO: Make a SMS
                                      if(dr_Contact != "") sms(dr_Contact);
                                      },
                                  ),
                                    ],
                                ),                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(TranslateStrings.rating()),
                                     FlutterRatingBar(
                                          initialRating: dr_Rating,
                                          allowHalfRating: false,
                                          ignoreGestures: false,
                                          tapOnlyMode: false,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                          fillColor: dr_Name != "" ? Colors.pink[200]: Colors.grey,
                                          borderColor: dr_Name != "" ? Colors.pink[200]: Colors.grey,
                                          enableTap:  _role_ID_Level != 4 && dr_Name != "",
                                          //textDirection:
                                          //_isRTLMode ? TextDirection.rtl : TextDirection.ltr,
                                          /*fullRatingWidget:
                                              _customize ? _image("assets/heart.png") : null,
                                          halfRatingWidget:
                                              _customize ? _image("assets/heart_half.png") : null,
                                          noRatingWidget:
                                              _customize ? _image("assets/heart_border.png") : null,*/
                                          onRatingUpdate: (rating) {
                                            if (dr_Name != "" ) 
                                             if(_role_ID_Level != 4){
                                                setState(() {
                                                  dr_Rating = rating;
                                                  print("driverRating: "+ dr_Rating.toString());
                                                  saveRating(sch_id, rating, "/ScheduleTrip/UpdateDriverRating");
                                                });                      
                                             }                      
                                          }
                                          ),   
                                  ],
                                ),
                                        
                              ],
                              ),
                            ),                      
                            
                            SizedBox(height: 5.0),
                            ListTile(
                                leading: Icon(Icons.album, color:  Colors.pink[300],),
                                title: Row(
                                  children: <Widget>[
                                    Text(TranslateStrings.bus() + ": "),
                                          FlutterRatingBar(
                                          initialRating: bus_Rating,
                                          allowHalfRating: false,
                                          ignoreGestures: false,
                                          tapOnlyMode: false,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                          fillColor: Colors.pink[200],
                                          borderColor: Colors.pink[200],
                                          enableTap:  _role_ID_Level != 4,
                                          //textDirection:
                                          //_isRTLMode ? TextDirection.rtl : TextDirection.ltr,
                                          /*fullRatingWidget:
                                              _customize ? _image("assets/heart.png") : null,
                                          halfRatingWidget:
                                              _customize ? _image("assets/heart_half.png") : null,
                                          noRatingWidget:
                                              _customize ? _image("assets/heart_border.png") : null,*/
                                          onRatingUpdate: (rating) {      
                                             if(_role_ID_Level != 4){                                      
                                                setState(() {
                                                  bus_Rating = rating;
                                                  print("Bus Rating: "+ bus_Rating.toString());
                                                  saveRating(sch_id, rating, "/ScheduleTrip/UpdateBusRating");
                                                });                      
                                             }                      
                                          }
                                          ),                                         
                                    /*  new IconButton(icon: new Icon(FontAwesomeIcons.save, color: dr_Name != "" ? Colors.pink[300]: Colors.grey),
                                      onPressed: () => {
                                        //TODO: save Driver Rating in DB.
                                        //saveDriverRating(sch_id)
                                        //fetchTripData()
                                      },)*/
                                  ],
                                ),
                                //subtitle: Text("Supervisor: " + supervisor_Name),
                              ),
                       

                          /*
                            ListTile(
                            leading: Icon(Icons.album, color:  Colors.pink[300],),
                            title: Text("list.length: " + list.length.toString()),
                            subtitle: Text("Branch: " + br_Name),
                          ),
                           ListTile(
                            leading: Icon(Icons.album, color:  Colors.pink[300],),
                            title: Text("list: " + list[0]['Name'].toString()),
                            subtitle: Text("list: " + list[0]['username'].toString()),
                          ),
                          */

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              (scheduleTripList['isDirectionFromHomeToSchool'] == true)? Text(TranslateStrings.tripToSchool()): Text(TranslateStrings.tripToHome()),
                              new SizedBox(height: 10.0,),
                              (_role_ID_Level != 3)? new SizedBox(height: 1.0,):
                              ButtonTheme.bar( // make buttons use the appropriate styles for cards
                                child: ButtonBar(
                                  children: <Widget>[
                                    RaisedButton(
                                      key:null, onPressed: () async{
                                          //print("_id: "+ sch_id);
                                          var responseJson = await NetworkUtils.startTrip(_user_id, _role_ID_Level.toString(), _schoolID, _schoolBrID,"", sch_id, tripFromHomeToSchool, "/ScheduleTrip/finishTrip", _authToken);
                                          if(responseJson == null) {
                                            //print("SnackBar6 _loadcurrentTrip");
                                            NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());

                                          } else if(responseJson == 'NetworkError') {
                                            //print("SnackBar4 _loadcurrentTrip");
                                            NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());

                                          } //else if(responseJson['errors'] != null) {
                                            else if(responseJson['success'] == false) {
                                            //print("SnackBar5 _loadcurrentTrip");
                                            NetworkUtils.showSnackBar(_scaffoldKey, responseJson['message'].toString());
                                            setState(() {
                                                    //_isThereTrip = false;        
                                            });
                                          } else {
                                                 Provider.of<AppMapState>(context).trip_Finished();                 
                                          setState(() {
                                                    scheduleTrip = TranslateStrings.trip_Finished();
                                                   
                                                    //currentTrip = responseJson;      
                                                    //_isThereTrip = false;                                                      
                                            });

                                            //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ChangePasswordPage()));
                                            /**
                                             * Removes stack and start with the new page.
                                             * In this case on press back on HomePage app will exit.
                                             * **/
                                            Navigator.of(_scaffoldKey.currentContext)
                                              .pushReplacementNamed("/");

                                            return responseJson;
                                          }}
                                      ,                      
                                      color: Colors.pink[100],
                                      child:
                                        new Text(" " + scheduleTrip + " ", // Finish Trip
                                          style: new TextStyle(fontSize:18.0,
                                          color: const Color(0xFF000000),
                                          fontWeight: FontWeight.w800,
                                          fontFamily: "Roboto"),
                                        ),
                                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                    ),                                
                                    /*FlatButton(
                                      child: const Text('Student on Trip', style: TextStyle(color: Colors.black54)), // 
                                      onPressed: ()   {Navigator.of(context).pop();
                                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new TripStudentsPage(studentslist,_authToken, _user_id, _username, _role_ID_Level, _schoolID, _schoolBrID)));}
                                    ),
                                    FlatButton(
                                      child: const Text('Supervisor', style: TextStyle(color: Colors.black54)),
                                      onPressed: ()   {Navigator.of(context).pop();
                                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new TripsupervisorPage(supervisorlist)));}
                                    ),*/
                                  ],
                                ),
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),
                  ),

                    
                    /*

            new ListTile(
              title: new Text("Change Password"),
              trailing: new Icon(Icons.arrow_upward),
              onTap: () {
                //Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ChangePasswordPage()));
              }
            )
           */

          ],
        )
        
);
}

void startTripbuttonPressed() async{
	var responseJson = await NetworkUtils.startTrip(_user_id, _role_ID_Level.toString(), _schoolID, _schoolBrID,"trip_id","Sch_id", tripFromHomeToSchool, "", _authToken);
  print("SnackBar6 startTripbuttonPressed");
			if(responseJson == null) {
        //print("SnackBar6 startTripbuttonPressed");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
			} else if(responseJson == 'NetworkError') {
        //print("SnackBar4 startTripbuttonPressed");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());
			} //else if(responseJson['errors'] != null) {
        else if(responseJson['success'] == false) {
        //print("SnackBar5 startTripbuttonPressed");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());
        setState(() {
		       // stop for test   _isThereTrip = false;        
		    });
			} else {
        
        //List list = List();
        //list = responseJson as List;
      print("SnackBar7 startTripbuttonPressed");
        //print("responseJson:");
        //print(list[0].toString());
       
       setState(() {
		      // stop for test  _isThereTrip = true;
          // stop for test    currentTrip = responseJson;
		    });

        //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ChangePasswordPage()));

        return responseJson;
			}

}


    void startTripradioChanged(int value) {
      setState(() {
               _radioValue1 = value;
               if(value == 0) // trip from home to school
                {
                    tripFromHomeToSchool = true;
                }
                else
                {
                    tripFromHomeToSchool = false;
                } 
            });    
    }

void saveRating(String tripID, double rating, String url) async{
                var responseJson = await NetworkUtils.tripRating(tripID, rating, url);
                print("NNNNNNNN responseJson2 rating: "+ responseJson.toString());
                    if(responseJson == null) {                      
                      //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
                    } else if(responseJson == 'NetworkError') {                      
                      //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());
                    } else if(responseJson['success'] == false) {                     
                      //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());                   
                    } else if(responseJson['success'] == true){                                     
                            setState(() {                                                           
                              //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.saveDone()); 
                            });                                     
                      return responseJson;
                    }
}

List<Widget> getSchoolWidget(var node){
      List<Widget> widgets = new List<Widget>();
      try{
          widgets.addAll([Center(
            child: new Text(node['School_ID']['SC_Name_ar'].toString(),
                      style: new TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
          ),
                  new Text(TranslateStrings.drawer_Manager() + ": " + node['School_ID']['SC_manager_Name'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
                  (node['School_ID']['Sc_Manager_Contact'] == null)? new SizedBox(height: 1.0,):                  

                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        new Text(TranslateStrings.contact() + ": " + node['School_ID']['Sc_Manager_Contact'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
                  IconButton(
                      icon: new Icon(FontAwesomeIcons.phone, size: 18),
                      color: Colors.pink[300],                       
                      onPressed: () {
                      //TODO: Make a Call
                      phoneCall(node['School_ID']['Sc_Manager_Contact']);
                      },
                  ),
                new SizedBox(height: 1.0,),
                  IconButton(
                      icon: new Icon(FontAwesomeIcons.sms, size: 18),
                      color: Colors.pink[300],                       
                      onPressed: () {
                      //TODO: Make a SMS
                      sms(node['School_ID']['Sc_Manager_Contact']);
                      },
                  ),
                    ],
                  ),
                  new Text(TranslateStrings.email() + ": " + node['School_ID']['Sc_manager_Email'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
                  new Text(TranslateStrings.address() + ": " + node['School_ID']['Sc_Address_ar'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
          ]);

            if(node['School_Br_ID'] == null) widgets.add(new SizedBox(height: 1.0,));                   
                    else widgets.addAll([
                  new Text(node['School_Br_ID']['Br_Name'].toString(),
                  style: new TextStyle(color: Colors.black54, fontSize: 15.0),),
                  new Text(node['School_Br_ID']['Br_Address'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),),
                  new Text(node['School_Br_ID']['Br_phone'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
                  new Text(node['School_Br_ID']['Br_manager_Name'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
                  (node['School_Br_ID']['Sc_Manager_Contact'] != null && node['School_Br_ID']['Sc_Manager_Contact'].toString() != "")? new SizedBox(height: 1.0,):                  
                  new Row(
                    children: <Widget>[
                       new Text(node['School_Br_ID']['Sc_Manager_Contact'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
                  IconButton(
                      icon: new Icon(FontAwesomeIcons.phone, size: 18),
                      color: Colors.pink[300],                       
                      onPressed: () {
                      //TODO: Make a Call
                      phoneCall(node['School_Br_ID']['Sc_Manager_Contact']);
                      },
                  ),
                 
                  IconButton(
                      icon: new Icon(FontAwesomeIcons.sms, size: 18),
                      color: Colors.pink[300],                       
                      onPressed: () {
                      //TODO: Make a SMS
                      sms(node['School_Br_ID']['Sc_Manager_Contact']);
                      },
                  ),
                    ],
                  ),
                  new Text(node['School_Br_ID']['Br_manager_Email'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
                      ]);
          }catch(err){ print("########### Error: "+ err.toString());
            //NetworkUtils.showSnackBar(_scaffoldKey, err.toString());
            }
                      //print("node['Supervisor_ID']: " + (node['Supervisor_ID'] == null).toString());
                      //widgets.addAll(getSupervisor(node).toList());
                      //print(node);
            return widgets.toList();

}

List<Widget> getSupervisor(var node){
  List<Widget> widgets = new List<Widget>();
  try{
                //print("@@@ node['Supervisor_Rating']: " + node['Supervisor_Rating'].toString());
                if(node['Supervisor_ID'] == null && node['Supervisor_ID'].toString() == "[]") 
                  widgets.add(new SizedBox(height: 1.0,));
                else{
                  //List aa = node['Supervisor_ID'];
                for (int i =0 ;i<node['Supervisor_ID'].length;i++) {
                  widgets.addAll([
                  new Text(TranslateStrings.supervisor() + ": " +node['Supervisor_ID'][i]['Name'].toString(),
                  style: new TextStyle(color: Colors.black54, fontSize: 15.0),),
                  new Text(TranslateStrings.email() + ": " +node['Supervisor_ID'][i]['Email'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),),
                                  
                  (node['Supervisor_ID'][i]['Phone'] == null || node['Supervisor_ID'][i]['Phone'].toString() == "")? 
                  new Text(TranslateStrings.contact() + ": ",
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ) : 
                  new Row(
                    children: <Widget>[
                   new Text(TranslateStrings.contact() + ": " + node['Supervisor_ID'][i]['Phone'].toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),

                  IconButton(
                      icon: new Icon(FontAwesomeIcons.phone, size: 18),
                      color: Colors.pink[300],                       
                      onPressed: () {
                      //TODO: Make a Call
                      phoneCall(node['Supervisor_ID'][i]['Phone']);
                      },
                  ),
                  
                  IconButton(
                      icon: new Icon(FontAwesomeIcons.sms, size: 18),
                      color: Colors.pink[300],                       
                      onPressed: () {
                      //TODO: Make a SMS
                      sms(node['Supervisor_ID'][i]['Phone']);
                      },
                  ),
                    ],
                  ),
                  
                  SizedBox(height: 5.0),

                            Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(TranslateStrings.rating()),
                                     FlutterRatingBar(
                                          initialRating: node['Supervisor_Rating'] != null && node['Supervisor_Rating'] != "" ? double.parse(node['Supervisor_Rating'].toString()) : 0.0 ,
                                          allowHalfRating: false,
                                          ignoreGestures: false,
                                          tapOnlyMode: false,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                          fillColor: node['Supervisor_ID'] != null && node['Supervisor_ID'].toString() != "[]" ? Colors.pink[200]: Colors.grey,
                                          borderColor: node['Supervisor_ID'] != null && node['Supervisor_ID'].toString() != "[]" ? Colors.pink[200]: Colors.grey,
                                          enableTap: _role_ID_Level != 3 && node['Supervisor_ID'] != null && node['Supervisor_ID'].toString() != "[]",
                                          //textDirection:
                                          //_isRTLMode ? TextDirection.rtl : TextDirection.ltr,
                                          /*fullRatingWidget:
                                              _customize ? _image("assets/heart.png") : null,
                                          halfRatingWidget:
                                              _customize ? _image("assets/heart_half.png") : null,
                                          noRatingWidget:
                                              _customize ? _image("assets/heart_border.png") : null,*/
                                          onRatingUpdate: (rating) {
                                            if (node['Supervisor_ID'] != null && node['Supervisor_ID'].toString() != "[]" ) 
                                            setState(() {
                                              if(_role_ID_Level != 3){
                                              //dr_Rating = rating;
                                              print("SupervisorRating: "+ rating.toString());
                                              saveRating(node['_id'], rating, "/ScheduleTrip/UpdateSupervisorRating");
                                              }
                                            });                                            
                                          }
                                          ),   
                                  ],
                                ),

                      ]);
                 
                };
                }
            
            }catch(err){ print("########## Error: "+ err.toString());
            //NetworkUtils.showSnackBar(_scaffoldKey, err.toString());
            }
            
            return widgets.toList();
}

void getTripRoute(){
  //MapRequest.OSMServices osm = new MapRequest.OSMServices();
  //  osm.getRoute(new LatLng(15.0,32.0), new LatLng(15.30, 32.30), MapRequest.OSMServices.CAR);
}

}