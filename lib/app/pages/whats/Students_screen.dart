//import 'package:bus_tracker/app/Socketio/socketIoManager.dart';
import 'package:flutter/material.dart';
//import '../../models/chat_model.dart';
//import 'package:bus_tracker/app/components/StudentList.dart';

import 'package:bus_tracker/app/components/DateRange.dart' as DateRagePicker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/components/PhoneCall.dart';
//import 'package:bus_tracker/app/socketio/socketIoManager.dart';
import 'package:bus_tracker/app/components/Notification.dart';
//import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

import 'package:bus_tracker/app/states/App_MapState.dart';
import 'package:provider/provider.dart';

class Students_Screen extends StatefulWidget {  
  final String user_id, schoolid, schoolbid, token;
  final int role_ID_Level;
  Students_Screen(this.user_id, this.role_ID_Level, this.schoolid, this.schoolbid, this.token);

  @override
  Students_ScreenState createState() {    
    return new Students_ScreenState();
  }
}

class Students_ScreenState extends State<Students_Screen> {
  var currentTrip, scheduleTripList;
  List studentslist;
  List absentlist;
  Students_ScreenState();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
var appMapState;

@override
void initState() {   
    super.initState();    
    //if(widget.role_ID_Level == 5) fetchStudentTodayTrip();    
    //else 
    fetchStudentData();
}

  @override
  Widget build(BuildContext context) {
    appMapState = Provider.of<AppMapState>(context);
           return new Scaffold(
      key: _scaffoldKey,
     /* appBar: new AppBar(
        title: new Text("Compliant"),
        elevation: 0.7,        
        actions: <Widget>[
          new Icon(Icons.search),
          new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
          ),
          new Icon(Icons.more_vert)
        ],
      ), */
      body:  studentslist == null || studentslist.length == 0
        ? nullStudent()        
       : students(studentslist),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,        
        children: <Widget>[
          new FloatingActionButton(
            backgroundColor: (widget.role_ID_Level == 5) ? Theme.of(context).textTheme.display3.color : Colors.grey , // Colors.pinkAccent[100]:  Colors.grey, // Theme.of(context).accentColor,            
            child: new Icon(
              FontAwesomeIcons.userPlus,
              color:  (widget.role_ID_Level == 5) ? Colors.white: Colors.grey[300],
            ),
            onPressed: () {
              if(widget.role_ID_Level == 5){
               //TODO: Send Complaint to School.
               //print("*********** widget.schoolID: "+ widget.schoolID);
               showParentAddStudentDialog(context, TranslateStrings.add_Student(), parentAddStudentCallBack);
              }
            },
          ),        
        ],
      ),
    );
  }

  Widget nullStudent() {
  return new Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          TranslateStrings.nullStudent(),
          style: new TextStyle(fontSize: 20.0, color: Theme.of(context).textTheme.display3.color),
        ),
        SizedBox(width: 10.0),
        new Icon(FontAwesomeIcons.frown, color: Theme.of(context).textTheme.display3.color ,
        size: Theme.of(context).textTheme.display3.fontSize * 1.5)
      ],
    ),
  );
}

Widget students(List list) { 
  return new Center(
    child: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, position) => new Column(children: <Widget>[
            new Card(
              color: Colors.yellow[100],
              margin: EdgeInsets.all(12.0),
              child: new Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new ListTile(
                    leading: new Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        color: Colors.yellow[100],
                        image: new DecorationImage(
                          image: ExactAssetImage(
                              //'lib/app/assets/Student/student_menu_icon96x96.png'),
                              'lib/app/assets/Student/student128x128.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(50.0)),
                        border: new Border.all(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                    ),
                    /*
                                      new CircleAvatar(
                                        foregroundColor: Theme.of(context).primaryColor,
                                        backgroundColor: Colors.white54,
                                        //backgroundImage: new NetworkImage("dummyData[i].avatarUrl"),
                                        //backgroundImage: new NetworkImage("dummyData[i].avatarUrl"),
                                        child: new Image.asset('lib/app/assets/Student/student_menu_icon96x96.png'),
                                        radius: 50,
                                        
                                      ),
                                      */
                    title: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        new Text(
                          TranslateStrings.student() + ": ${(widget.role_ID_Level == 5) ? list[position]['Student_Name_ar']: list[position]['Student_ID']['Student_Name_ar']}",
                          //TranslateStrings.student() + ": ${ list[position]['Student_ID']['Student_Name_ar']}",
                          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.display3.fontSize),
                        ),
                        // new Text(
                        //  "Pickup location: ${list[position]['Student_ID']['Pickup_location'] != null ? list[position]['Student_ID']['Pickup_location']: ""}",
                        //  style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                        //),
                      ],
                    ),
                    subtitle: new Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              TranslateStrings.parent() + ": ${((widget.role_ID_Level == 5)? list[position]['Guardians_ID']:list[position]['Student_ID']['Guardians_ID']) != null ? ((widget.role_ID_Level == 5)? list[position]['Guardians_ID'][0]['Name']:list[position]['Student_ID']['Guardians_ID'][0]['Name']) : ""}",
                              //TranslateStrings.parent() + ": ${list[position]['Student_ID']['Guardians_ID'] != null ? list[position]['Student_ID']['Guardians_ID'][0]['Name'] : ""}",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: Theme.of(context).textTheme.display3.fontSize),
                            ),
                            //new Text(
                            //  "Phone: ${list[position]['Student_ID']['Guardians_ID'] != null? list[position]['Student_ID']['Guardians_ID'][0]['Phone']: ""}",
                            //  style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                            //),
                            Container(
                              child: Column(
                                children: <Widget>[
                                   Text(
                                    (widget.role_ID_Level == 5) ? (list[position]['Guardians_ID'] != null
                                        ? list[position]['Guardians_ID'][0]['Phone'] : TranslateStrings.no_Contact_Number())
                                        : (list[position]['Student_ID']['Guardians_ID'] != null
                                        ? list[position]['Student_ID']['Guardians_ID'][0]['Phone'] : TranslateStrings.no_Contact_Number()),
                                    //list[position]['Student_ID']['Guardians_ID'] != null
                                    //    ? list[position]['Student_ID']['Guardians_ID'][0]['Phone'] : TranslateStrings.no_Contact_Number(),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: Theme.of(context).textTheme.display3.fontSize,
                                    )),
                                  new Row(                                    
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                    IconButton(
                                      icon: new Icon(
                                        FontAwesomeIcons.commentAlt,
                                        size: 18,
                                      ),
                                      color: Theme.of(context).textTheme.display3.color,
                                      onPressed: () {
                                        //TODO: Send Notification
                                        String parentName , guardians_ID ="";
                                        if (widget.role_ID_Level == 5){
                                          parentName = list[position]['Guardians_ID'] != null ? list[position]['Guardians_ID'][0]['Name'] : TranslateStrings.parent();
                                          guardians_ID = list[position]['Guardians_ID'] != null  ? list[position]['Guardians_ID'][0]['_id'] : "";
                                        }
                                        else{
                                          parentName = list[position]['Student_ID']['Guardians_ID'] != null ? list[position]['Student_ID']['Guardians_ID'][0]['Name'] : TranslateStrings.parent();
                                          guardians_ID = list[position]['Student_ID']['Guardians_ID'] != null  ? list[position]['Student_ID']['Guardians_ID'][0]['_id'] : "";
                                        }

                                        if (guardians_ID != "")
                                          showParentNoteDialog(context, guardians_ID, parentMsgSendCallBack, "direct", TranslateStrings.send_Msg_To() + parentName);
                                      },
                                    ),                               
                                    IconButton(
                                      icon: new Icon(FontAwesomeIcons.phone,
                                          size: 18),
                                      color: (widget.role_ID_Level == 5)? ((list[position]['Guardians_ID'] != null && list[position]['Guardians_ID'][0]['Phone'] != null && list[position]['Guardians_ID'][0]['Phone'] != "") ? Theme.of(context).textTheme.display3.color: Colors.grey)
                                      :(list[position]['Student_ID']['Guardians_ID'] != null && list[position]['Student_ID']['Guardians_ID'][0]['Phone'] != null && list[position]['Student_ID']['Guardians_ID'][0]['Phone'] != "")? Theme.of(context).textTheme.display3.color: Colors.grey ,
                                      onPressed: () {
                                        //TODO: Make a Call
                                        if (widget.role_ID_Level == 5){
                                        if (list[position]['Guardians_ID'] != null &&
                                            list[position]['Guardians_ID'][0]['Phone'] != null &&
                                            list[position]['Guardians_ID'][0]['Phone'] != "") {
                                          phoneCall(list[position]
                                              ['Guardians_ID'][0]['Phone']);
                                        } else
                                          NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.no_Contact_Number());
                                        }
                                        else{
                                          if (list[position]['Student_ID']['Guardians_ID'] != null &&
                                            list[position]['Student_ID']['Guardians_ID'][0]['Phone'] != null &&
                                            list[position]['Student_ID']['Guardians_ID'][0]['Phone'] != "") {
                                          phoneCall(list[position]['Student_ID']
                                              ['Guardians_ID'][0]['Phone']);
                                        } else
                                          NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.no_Contact_Number());
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          new Icon(FontAwesomeIcons.sms, size: 18),
                                      color: (widget.role_ID_Level == 5)? ((list[position]['Guardians_ID'] == null || list[position]['Guardians_ID'][0]['Phone'] == null || list[position]['Guardians_ID'][0]['Phone'] == "") ? Colors.grey: Colors.pink[300])
                                      :(list[position]['Student_ID']['Guardians_ID'] == null && list[position]['Student_ID']['Guardians_ID'][0]['Phone'] == null || list[position]['Student_ID']['Guardians_ID'][0]['Phone'] == "")? Colors.grey : Colors.pink[300],
                                      onPressed: () {
                                        //TODO: Make a Call
                                        if (widget.role_ID_Level == 5){
                                        if (list[position]['Guardians_ID'] != null &&
                                            list[position]['Guardians_ID'][0]['Phone'] != null &&
                                            list[position]['Guardians_ID'][0]['Phone'] != "") {
                                          sms(list[position]
                                              ['Guardians_ID'][0]['Phone']);
                                        } else
                                          NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.no_Contact_Number());
                                        }
                                        else{
                                          if (list[position]['Student_ID']['Guardians_ID'] != null &&
                                            list[position]['Student_ID']['Guardians_ID'][0]['Phone'] != null &&
                                            list[position]['Student_ID']['Guardians_ID'][0]['Phone'] != "") {
                                          sms(list[position]['Student_ID']
                                              ['Guardians_ID'][0]['Phone']);
                                        } else
                                          NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.no_Contact_Number());
                                        }
                                      },
                                    ),
                                  ]),
                              
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                            //TODO: Add student Attendance. ride bus below: isDirectionFromHomeToSchool
                           getAttendanceParentWidgets(list[position]) ,
                      ),

                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[   
                        //TODO: Add Students Absent.
                        new Checkbox(
                          key: null,
                          value: (widget.role_ID_Level == 5)? (list[position]['Absent_ID'] == null || list[position]['Absent_ID'].toString() == "[]" ? false : true) 
                          : (list[position]['Student_ID']['Absent_ID'] == null || list[position]['Student_ID']['Absent_ID'].toString() == "[]" ? false : true),
                          //value: (list[position]['Student_ID']['Absent_ID'] == null || list[position]['Student_ID']['Absent_ID'].toString() == "[]" ? false : true),
                          activeColor: Colors.pink,
                          onChanged: (bool e) async {
                            //TODO: Add Confirm form
                            //final result = await Navigator.push(context, showConfirmDialog(context, "kk") );
                            //final result = await Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => showConfirmDialog(context, "kk")));
                              bool isAbsent = (widget.role_ID_Level == 5)? (list[position]['Absent_ID'] == null || list[position]['Absent_ID'].toString() == "[]" ? false : true)
                              : (list[position]['Student_ID']['Absent_ID'] == null || list[position]['Student_ID']['Absent_ID'].toString() == "[]" ? false : true);
                              //bool isAbsent = (list[position]['Student_ID']['Absent_ID'] == null || list[position]['Student_ID']['Absent_ID'].toString() == "[]" ? false : true);
                            final result = await confirmDialog(context, TranslateStrings.confirm_Dialog(), isAbsent ? TranslateStrings.remove_Absent(): TranslateStrings.add_Absent());                                        
                            //print("******************  after dialog......");
                            print("******************  after dialog......" + result.toString());
                            if (result == 'Yes') {
                              
                              if(isAbsent){
                                 //TODO: Clear Absent
                                 //print('@@@@ list _d:' + (widget.role_ID_Level == 5 ? list[position]['Absent_ID'].toString()
                                 //: list[position]['Student_ID']['Absent_ID'].toString()) );
                                 var responseJson =
                                    await NetworkUtils.studentsClearAbsent(
                                        (widget.role_ID_Level == 5) ? list[position]['_id'].toString(): list[position]['Student_ID']['_id'].toString(),
                                       //list[position]['Student_ID']['_id'].toString(),
                                       (widget.role_ID_Level == 5) ? list[position]['Absent_ID'][0]['_id'] : list[position]['Student_ID']['Absent_ID'][0]['_id'],
                                       //list[position]['Student_ID']['Absent_ID'][0]['_id'],
                                        "/Absent/remove");
                                  print("*********** Remove Absent responseJson2:" + responseJson.toString());
                                  //print("*********** Absent responseJson2:" + responseJson[0].toString());
                                if (responseJson == null) {
                                  //print("SnackBar3 Remove Absent RaisedButton");
                                  //NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong on Trip!');

                                } else if (responseJson == 'NetworkError') {
                                  //print("SnackBar4 Remove Absent RaisedButton");
                                  //NetworkUtils.showSnackBar(_scaffoldKey, "Network Error...");

                                } //else if(responseJson['errors'] != null) {
                                else if (responseJson['success'] == false) {
                                  print("SnackBar5 Remove Absent RaisedButton");
                                  //NetworkUtils.showSnackBar(_scaffoldKey, 'Server Invalid Data');
                                
                                } else if (responseJson['success'] == true){
                                  print("SnackBar6 Remove Absent RaisedButton");
                                  setState(() {
                                      (widget.role_ID_Level == 5) ? (list[position]['Absent_ID'] = null) : (list[position]['Student_ID']['Absent_ID'] = null);                                    
                                     //(list[position]['Student_ID']['Absent_ID'] = null);                                    
                                                                    });
                                  appMapState.sendStudentAbsent(list[position]['Student_ID']['_id'], list[position]['Student_ID']['Absent_ID']);
                                  //fillAbsentData();
                                }

                              } else {
                              //TODO: Insert Student Absent.
                              var date = new DateRagePicker.DateRange();
                              var obj = await date.getDate(context);
                              if (obj["picked"] != null) {
                                //TODO: Send to server.
                                //TODO: Testing
                                print("Absent Date is: " + obj.toString());                               
                                var responseJson =
                                    await NetworkUtils.studentsAbsent(
                                        (widget.role_ID_Level == 5) ? list[position]['_id'].toString() : list[position]['Student_ID']['_id'].toString(),
                                        //list[position]['Student_ID']['_id'].toString(),
                                        obj["picked"][0],
                                        obj["picked"][1],
                                        obj["day"],
                                        "/Absent/Add");
                                  print("*********** Absent responseJson2:" + responseJson.toString());
                                  //print("*********** Absent responseJson2:" + responseJson[0].toString());
                                if (responseJson == null) {
                                  print("SnackBar3 Absent RaisedButton");
                                  //NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong on Trip!');

                                } else if (responseJson == 'NetworkError') {
                                  print("SnackBar4 Absent RaisedButton");
                                  //NetworkUtils.showSnackBar(_scaffoldKey, "Network Error...");

                                } //else if(responseJson['errors'] != null) {
                                else if (responseJson['success'] == false) {
                                  print("SnackBar5 Absent RaisedButton");
                                  //NetworkUtils.showSnackBar(_scaffoldKey, 'Server Invalid Data');
                                  //TODO: solve this setState()
                                  //setState(() {
                                  //_isThereTrip = false;
                                  //});
                                } else if (responseJson['success'] == true){
                                  print("SnackBar6 Absent RaisedButton");
                                  setState(() {
                                    
                                      (widget.role_ID_Level == 5) ? (list[position]['Absent_ID'] = []) : (list[position]['Student_ID']['Absent_ID'] = []);
                                       //(list[position]['Student_ID']['Absent_ID'] = []);
                                        (widget.role_ID_Level == 5) ? (list[position]['Absent_ID'].add(responseJson['absent'])) : (list[position]['Student_ID']['Absent_ID'].add(responseJson['absent']));  
                                        // (list[position]['Student_ID']['Absent_ID'].add(responseJson['absent']));  
                                      //print('@@@@ ffff :' + list[position]['Student_ID']['Absent_ID'].toString());
                                                                    });
                                  if(widget.role_ID_Level != 5)
                                    appMapState.sendStudentAbsent(list[position]['Student_ID']['_id'], list[position]['Student_ID']['Absent_ID']);
                                    else appMapState.sendStudentAbsent(list[position]['_id'], list[position]['Absent_ID']);
                                  //fillAbsentData();
                                }
                              } else {
                                print("Absent Date is Null");
                                //TODO: riase Alert to user.
                              }
                              } // if not absent
                            } // if yes.
                          },
                        ),
                        new Text(
                          TranslateStrings.absent(),
                          style: Theme.of(context).textTheme.display3,
                          //style: new TextStyle(
                          //    fontSize: 18.0,
                          //    color:
                          //        Colors.pink[300], // const Color(0xFF000000),
                          //    fontWeight: FontWeight.w800,
                          //    fontFamily: "Roboto"),
                        ),
                      ]), 

                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                            
                ],
              ),
            )
          ]),
    ),
  );
}

void parentMsgSendCallBack(String guardians_ID, String value, String msgRoute) {
  print(" ************************* StudentList Dialog value: " + value);
  print(" ************************* StudentList Dialog guardians_ID: " +
      guardians_ID);
  //SocketIOClass.sendnotification(guardians_ID, "msg", msgRoute);
  NetworkUtils.sendNotification(
      'direct', guardians_ID, value, msgRoute, '/Notification/Add');
}

bool _isLoading =false;
void fillAbsentData() async{
var responseJson = await NetworkUtils.fetchStudentsWithAbsent("/ScheduleTrip/TodayTrip");
	
			//print("Login Page Line 70, responseJson: " + responseJson);

      //print(" " + responseJson.toString());
      
      print("new home3");
			
      if(responseJson == "" || responseJson == null) {
        print("SnackBar3 fillAbsentData home");
        setState(() {
		        //_isThereTrip = false;        
		    });
			} else if(responseJson == 'NetworkError') {
        print("SnackBar4 fillAbsentData home");
        setState(() {          
		        //_isThereTrip = false;        
		    });
			} //else if(responseJson['errors'] != null) {
        else if(responseJson['success'] == false) {
        print("SnackBar5 fillAbsentData home");
        setState(() {          
		        //_isThereTrip = false;        
		    });
			}  else if(responseJson['scheduleTrip'] != null) {
        print("SnackBar6 fillAbsentData home");
        setState(() {         
            print("SnackBar8 fillAbsentData home");          
            absentlist = responseJson['scheduleTrip'][0]['WaypointList'];
            //print('List:' + list.toString());
		        //_isThereTrip = true;
            _isLoading = true;
            print("new home4");
          });                   
      } 

}

fetchStudentData() async{
String _url = "";
//print("url: " + _url + ", " + widget.role_ID_Level.toString());
  if(widget.role_ID_Level == 5)
    _url = "/Students/list";
  else
    _url = "/ScheduleTrip/TodayTrip";
    //print("url: " + _url + ", " + widget.role_ID_Level.toString());
		var responseJson = await NetworkUtils.fetchTrip(widget.user_id, widget.role_ID_Level.toString(), widget.schoolid, widget.schoolbid, widget.token,"Guardians_ID", true , _url);
	
      // get TRip from Trip schedule by _id, today, if there record then loadcurrentTrip, else loadCreateNewTrip

			//print("Login Page Line 70, responseJson: " + responseJson);

      print(" " + responseJson.toString());
      
      print("new home3");
			
      if(responseJson == "" || responseJson == null) {
        print("SnackBar3 fetchTripData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
        setState(() {
		        //#stop _isThereTrip = false;        
		    });
			} else if(responseJson == 'NetworkError') {
        print("SnackBar4 fetchTripData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());
        setState(() {          
		        //#stop _isThereTrip = false;        
		    });
			} //else if(responseJson['errors'] != null) {
        else if(responseJson['success'] == false) {
        print("SnackBar5 fetchTripData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());
        setState(() {          
		        //#stop _isThereTrip = false;        
		    });
			}  else if(responseJson['scheduleTrip'] != null) {
        print("SnackBar6 fetchTripData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.today_Schedule_Trip());
        //TODO: save TripId, and add to SocketIO.
        //await saveTripId(currentTrip['scheduleTrip'][0]["Trip_ID"]["_id"]); // stop 10-05-2019
        setState(() {
          currentTrip = responseJson;          
         
            print("SnackBar8 fetchTripData home");
            //print("currentTrip['scheduleTrip'] != null" );
          scheduleTripList = currentTrip['scheduleTrip'][0];
            studentslist = scheduleTripList['WaypointList'];
		        //#stop _isThereTrip = true;
            _isLoading = true;
            print("new home4");
          });
          }
          else if(currentTrip != null && currentTrip['scheduletrip'] != null)
          {  
            setState(() {            
            print("SnackBar9 fetchTripData home");
            scheduleTripList = currentTrip['scheduletrip'];  
            studentslist = scheduleTripList['WaypointList'];
		        //_isThereTrip = true;
            //_isLoading = true;
            });
        
      }
      else if(responseJson['trip'] != null) {
        print("SnackBar7 fetchTripData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.there_is_no_Schedule_Trip_Today_Select_New_Trip());
        //TODO: Clear TripId, SocketIO
        //await clearTripId();  // stop 10-05-2019
        setState(() {
          currentTrip = responseJson;
		        //#stop _isThereTrip = false;        
		    });        
      } else if(responseJson['success'] == true && responseJson['students'] != null) {
        setState(() {
          studentslist = responseJson['students'];
          });
      }
        else {
        
        //List list = List();
        //list = responseJson as List;
        print("SnackBar8 fetchTripData home");
        //print("responseJson:");
        //print(list[0].toString());
       
       setState(() {
		        //print("responseJson: " + responseJson.toString());
           // currentTrip = responseJson;
           // _isThereTrip = true;
		    });

    }
    
}

fetchStudentTodayTrip() async{

    String _url = "/ScheduleTrip/StudentTodayTrip";            
		var responseJson = await NetworkUtils.fetchStudentTodayTrip(widget.user_id, widget.role_ID_Level.toString(), widget.schoolid, widget.schoolbid, widget.token,"Guardians_ID", true , _url);   

      print("######### fetchStudentTodayTrip: " + responseJson.toString());
			
      if(responseJson == "" || responseJson == null) {
        setState(() {          
		           studentslist = null;
		    });
        print("SnackBar3 fetchStudentTodayTrip home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());      
			} else if(responseJson == 'NetworkError') {
        setState(() {          
		           studentslist = null;
		    });
        print("SnackBar4 fetchStudentTodayTrip home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());      
			} else if(responseJson['success'] == false) {
        setState(() {          
		           studentslist = null;
		    });
        print("SnackBar5 fetchStudentTodayTrip home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());        
			}  else if(responseJson['scheduleTrip'] != null && responseJson['scheduleTrip'][0]['WaypointList'] != null) {
            print("SnackBar6 fetchStudentTodayTrip home");
            //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.today_Schedule_Trip());   
            List temp = new List();          
                for(int i =0;i<responseJson['scheduleTrip'][0]['WaypointList'].length; i++){
                  try{
                  if(responseJson['scheduleTrip'][0]['WaypointList'][i]['Student_ID'] != null)
                  temp.add(responseJson['scheduleTrip'][0]['WaypointList'][i]);
                  }catch(err){print("Erroor: "+ err.toString());
                  //print("Erroor: "+ responseJson['scheduleTrip'][0]['WaypointList'][i].toString());
                  }
                }         
              setState(() {
                  studentslist = temp;
                  scheduleTripList = responseJson['scheduleTrip'][0];
                //studentslist = scheduleTripList['WaypointList'];            
                print("SnackBar8 fetchStudentTodayTrip home");  
                //print("SnackBar8 fetchStudentTodayTrip home: "+ temp.length.toString());  
            });
          }  else if(responseJson['trip'] != null && responseJson['trip'][0]['WaypointList'] != null) {
                print("SnackBar6 fetchStudentTodayTrip home");
                //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.today_Schedule_Trip());   
                List temp = new List();          
                    for(int i =0;i<responseJson['trip'][0]['WaypointList'].length; i++){
                      try{
                      if(responseJson['trip'][0]['WaypointList'][i]['Student_ID'] != null)
                      temp.add(responseJson['trip'][0]['WaypointList'][i]);
                      }catch(err){print("Error trip: "+ err.toString());
                      //print("Erroor: "+ responseJson['trip'][0]['WaypointList'][i].toString());
                      }
                    }         
                  setState(() {
                      studentslist = temp;
                      scheduleTripList = responseJson['trip'][0];
                    //studentslist = scheduleTripList['WaypointList'];            
                    print("SnackBar9 fetchStudentTodayTrip home");  
                    //print("SnackBar9 fetchStudentTodayTrip home: "+ temp.length.toString());  
                  });
          }       
        else {
            setState(() {          
		              studentslist = null;
		        });
            }
}

void parentAddStudentCallBack(String studentID, String birthDate)async{
var responseJson = await NetworkUtils.sendParentAddStudent(widget.user_id, studentID, birthDate, "/Students/UpdateParentsBySTID");
	
			//print("Login Page Line 70, responseJson: " + responseJson);

      //print(" " + responseJson.toString());
      
      print("new home3");
			
      if(responseJson == "" || responseJson == null) {
        print("SnackBar3 parentAddStudentCallBack home");
        setState(() {
		        //_isThereTrip = false;        
		    });
			} else if(responseJson == 'NetworkError') {
        print("SnackBar4 parentAddStudentCallBack home");
        setState(() {          
		        //_isThereTrip = false;        
		    });
			} //else if(responseJson['errors'] != null) {
        else if(responseJson['success'] == false) {
        print("SnackBar5 parentAddStudentCallBack home");
        setState(() {          
		        //_isThereTrip = false;        
		    });
			}  else if(responseJson['success'] == true) {
        print("SnackBar6 parentAddStudentCallBack home");
        setState(() {          
		        //_isThereTrip = false;        
            //TODO: Add new Student or reload Student list.
            fetchStudentData();
		    });
      } else  {
        print("SnackBar7 parentAddStudentCallBack Data return is null");
       
      } 
}

List<Widget> getAttendanceParentWidgets(var node){
  List<Widget> widgets = new List<Widget>();
    if(scheduleTripList == null && node != null) {widgets.add(new SizedBox(height: 1.0,)); return widgets;}
print("node['Supervisor_student_at_bus']:" + node['Supervisor_student_at_bus'].toString());

    if(scheduleTripList['isDirectionFromHomeToSchool'] == true){    
    widgets.addAll([
      new IconButton(icon: new Icon(FontAwesomeIcons.home, size: 18),                                                                                   
      color: node['parent_ID_student_leave_home'] != null ? (node['parent_ID_student_leave_home']['at'] == true ? Colors.pink[300] : Colors.black): Colors.grey,
      onPressed: () {
               if(widget.role_ID_Level == 5) {
                 node['parent_ID_student_leave_home'] = (node['parent_ID_student_leave_home'] == null)?  {'at': true}: {'at' : !node['parent_ID_student_leave_home']['at']};
                 saveAttendance(scheduleTripList['_id'], node['_id'], 'parent_ID_student_leave_home', node['parent_ID_student_leave_home']['at'].toString() , '/ScheduleTrip/UpdateAttendance');                          
               }
      },),
       new IconButton(icon: new Icon(FontAwesomeIcons.busAlt, size: 18),
      color: node['Supervisor_student_at_bus'] != null ?(node['Supervisor_student_at_bus']['at'] == true ? Colors.pink[300] : Colors.black): Colors.grey,                                      
      onPressed: () {
                 if(widget.role_ID_Level == 3) {
                   node['Supervisor_student_at_bus'] = (node['Supervisor_student_at_bus'] == null)? {'at': true}: {'at' : !node['Supervisor_student_at_bus']['at']};                   
                   saveAttendance(scheduleTripList['_id'], node['_id'], 'Supervisor_student_at_bus', node['Supervisor_student_at_bus']['at'].toString(), '/ScheduleTrip/UpdateAttendance'); 
                  appMapState.sendStudentAttendance(scheduleTripList['_id'], node['_id'], node['Student_ID']['_id']);
                 }
      },),
       new IconButton(icon: new Icon(FontAwesomeIcons.school, size: 18),
      color: node['Supervisor_student_reach_school'] != null ? (node['Supervisor_student_reach_school']['at'] == true ? Colors.pink[300] : Colors.black): Colors.grey,                                      
      onPressed: () {
                  if(widget.role_ID_Level == 3) {
                    node['Supervisor_student_reach_school'] = (node['Supervisor_student_reach_school'] == null)?  {'at': true}: {'at' : !node['Supervisor_student_reach_school']['at']};
                    saveAttendance(scheduleTripList['_id'], node['_id'], 'Supervisor_student_reach_school', node['Supervisor_student_reach_school']['at'].toString(), '/ScheduleTrip/UpdateAttendance');                        
                  }
      },),
      //new Padding(
      //   padding: new EdgeInsets.all(8.0),
      //)
    ]);
    }
    else{
    widgets.addAll([
      new IconButton(icon: new Icon(FontAwesomeIcons.school, size: 18),                                                                                   
      color: node['SchoolAdmin_student_leave_school'] != null ? (node['SchoolAdmin_student_leave_school']['at'] == true ? Colors.pink[300] : Colors.black): Colors.grey,
      onPressed: () {
                 if(widget.role_ID_Level == 3) {
                   node['SchoolAdmin_student_leave_school'] = (node['SchoolAdmin_student_leave_school'] == null)?  {'at': true}: {'at' : !node['SchoolAdmin_student_leave_school']['at']};
                   saveAttendance(scheduleTripList['_id'], node['_id'], 'SchoolAdmin_student_leave_school', node['SchoolAdmin_student_leave_school']['at'].toString() , '/ScheduleTrip/UpdateAttendance');                         
                 }
      },),
            new IconButton(icon: new Icon(FontAwesomeIcons.bus, size: 18),
      color: node['Supervisor_student_at_bus'] != null ?(node['Supervisor_student_at_bus']['at'] == true ? Colors.pink[300] : Colors.black): Colors.grey,                                      
      onPressed: () {
                 if(widget.role_ID_Level == 3) {
                   node['Supervisor_student_at_bus'] = (node['Supervisor_student_at_bus'] == null)?  {'at': true}: {'at' : node['Supervisor_student_at_bus']['at']};                   
                   saveAttendance(scheduleTripList['_id'], node['_id'], 'Supervisor_student_at_bus', node['Supervisor_student_at_bus']['at'].toString(), '/ScheduleTrip/UpdateAttendance'); 
                 }
      },),
       new IconButton(icon: new Icon(FontAwesomeIcons.bus, size: 18),                                                                                   
      color: node['Supervisor_student_leave_bus'] != null ?(node['Supervisor_student_leave_bus']['at'] == true ? Colors.pink[300] : Colors.black): Colors.grey,                                      
      onPressed: () {
                 if(widget.role_ID_Level == 3) {
                   node['Supervisor_student_leave_bus'] = (node['Supervisor_student_leave_bus'] == null)?  {'at': true}: {'at' : !node['Supervisor_student_leave_bus']['at']};
                   saveAttendance(scheduleTripList['_id'], node['_id'], 'Supervisor_student_leave_bus', node['Supervisor_student_leave_bus']['at'].toString(), '/ScheduleTrip/UpdateAttendance');                         
                   appMapState.sendStudentAttendance(scheduleTripList['_id'], node['_id'], node['Student_ID']['_id']);
                 }
      },),
       new IconButton(icon: new Icon(FontAwesomeIcons.home, size: 18),                                                                                   
      color: node['parent_ID_student_reach_home'] != null ? (node['parent_ID_student_reach_home']['at'] == true ? Colors.pink[300] : Colors.black): Colors.grey,                                      
      onPressed: () {
                  if(widget.role_ID_Level == 5) {
                    node['parent_ID_student_reach_home'] = (node['parent_ID_student_reach_home'] == null)?  {'at': true}: {'at' : !node['parent_ID_student_reach_home']['at']};
                    saveAttendance(scheduleTripList['_id'], node['_id'], 'parent_ID_student_reach_home', node['parent_ID_student_reach_home']['at'].toString(), '/ScheduleTrip/UpdateAttendance');                        
                  }
      },),
      //new Padding(
      //   padding: new EdgeInsets.all(8.0),
      //)
    ]);
    }               
                            /*new Image.asset(
                                                'lib/app/assets/Student/At bus pink.png',
                                                height: 32,
                                                width: 32,
                                              ),
                            new Image.asset(
                              'lib/app/assets/Student/leave bus pink.png',
                              height: 32,
                              width: 32,
                            ),*/
                            
                           


  return widgets;
}

void saveAttendance(String tripID, String waypointListID, String param, String paramValue, String url) async{
                var responseJson = await NetworkUtils.saveAttendance(tripID, waypointListID, param, paramValue, url);
                print("NNNNNNNN responseJson2 rating: "+ responseJson.toString());
                    if(responseJson == null) {                      
                      NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
                    } else if(responseJson == 'NetworkError') {                      
                      NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());
                    } else if(responseJson['success'] == false) {                     
                      NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());                   
                    } else if(responseJson['success'] == true){                                     
                            setState(() {                                                           
                              NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.saveDone()); 
                            });                                     
                      return responseJson;
                    }                       
}

}