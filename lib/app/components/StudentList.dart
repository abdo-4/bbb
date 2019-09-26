import 'package:flutter/material.dart';
import 'package:bus_tracker/app/components/DateRange.dart' as DateRagePicker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/components/PhoneCall.dart';
//import 'package:bus_tracker/app/socketio/socketIoManager.dart' as sockets;
import 'package:bus_tracker/app/components/Notification.dart';
//import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';

// not use
class StudentListFieldcd extends StatelessWidget {
	//final TextEditingController usernameController;
	//final String usernameError;
  //StudentListField({this.usernameController, this.usernameError});
  final List list;
  StudentListFieldcd(this.list);

	@override
  Widget build(BuildContext context) {
    print("list Students: "+ (list == null? "Null" : "Not Null"));
    return list == null ? nullStudent(): students();
  }
	
  Widget nullStudent(){
    return new Center(
      child: new Text(
            "No Students List...",
            style: new TextStyle(fontSize: 20.0, color: Colors.pink[200]),),
    );
  }
  
  Widget students(){
    return new Center(
             child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, position) => new Column(
            children: <Widget>[        
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
                                        color:  Colors.yellow[100],
                                        image: new DecorationImage(
                                          //image: ExactAssetImage('lib/app/assets/Student/student_menu_icon96x96.png'),
                                          image: ExactAssetImage('lib/app/assets/Student/student128x128.png'),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                                        border: new Border.all(
                                          color: Colors.red,
                                          width: 4.0,
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
                                          SizedBox(height: 10.0,),
                                          new Text(
                                            "Student: ${list[position]['Student_ID']['Student_Name_ar']}",
                                            style: new TextStyle(fontWeight: FontWeight.bold),
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
                                          "Parent: ${list[position]['Student_ID']['Guardians_ID'] != null ? list[position]['Student_ID']['Guardians_ID'][0]['Name']: ""}",
                                          style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                                          ),
                                          //new Text(
                                          //  "Phone: ${list[position]['Student_ID']['Guardians_ID'] != null? list[position]['Student_ID']['Guardians_ID'][0]['Phone']: ""}",
                                          //  style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                                          //),
                                           Container(
                                            child: new Row(children: <Widget>[
                                              IconButton(icon: new Icon(FontAwesomeIcons.commentAlt,size: 18,), color: Colors.pink[300],
                                              onPressed: () {
                                                //TODO: Send Notification
                                                String parentName = list[position]['Student_ID']['Guardians_ID'] != null? list[position]['Student_ID']['Guardians_ID'][0]['Name']: "Parent";
                                                String guardians_ID = list[position]['Student_ID']['Guardians_ID'] != null? list[position]['Student_ID']['Guardians_ID'][0]['_id']: "";
                                                if(guardians_ID != "") showParentNoteDialog(context, guardians_ID, parentMsgSendCallBack, "direct", "Send Msg To " + parentName);
                                              },),
                                            Text(
                                              list[position]['Student_ID']['Guardians_ID'] != null? list[position]['Student_ID']['Guardians_ID'][0]['Phone']: "Phone Null",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                  fontSize: 18.0,
                                              )
                                            ),
                                            IconButton(icon: new Icon(FontAwesomeIcons.phone,size: 18), color: Colors.pink[300],
                                              onPressed: () {
                                                //TODO: Make a Call
                                                if(list[position]['Student_ID']['Guardians_ID'] != null && list[position]['Student_ID']['Guardians_ID'][0]['Phone'] != null
                                                && list[position]['Student_ID']['Guardians_ID'][0]['Phone'] != "")
                                                {
                                                    phoneCall(list[position]['Student_ID']['Guardians_ID'][0]['Phone']);
                                                }
                                              },),
                                                IconButton(icon: new Icon(FontAwesomeIcons.sms,size: 18), color: Colors.pink[300],
                                              onPressed: () {
                                                //TODO: Make a Call
                                                if(list[position]['Student_ID']['Guardians_ID'] != null && list[position]['Student_ID']['Guardians_ID'][0]['Phone'] != null
                                                && list[position]['Student_ID']['Guardians_ID'][0]['Phone'] != "")
                                                {
                                                    sms(list[position]['Student_ID']['Guardians_ID'][0]['Phone']);
                                                }
                                              },),
                                            ]),
                                          ),      

                                        ]
                                        ),
                                        ),
                                    ),
                                    
                                      new Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                               new Image.asset('lib/app/assets/Student/At bus pink.png', height: 32, width: 32,),                                                  
                                               new Image.asset('lib/app/assets/Student/leave bus pink.png', height: 32, width: 32,),
                                                new Padding(
                                                  padding: new EdgeInsets.all(8.0),
                                                ),
                                                new RaisedButton(key:null, onPressed: () async{
                                                  //TODO: Supervisor_Aproof_student_reach_school,... etc.
                                                  /*
                                                   bool absent;
                                                   if( list[position]['Student_ID']['Absent_ID'] == null ||  list[position]['Student_ID']['Absent_ID'] == "")
                                                   {
                                                     absent = true;
                                                   }
                                                   else
                                                   {
                                                     absent = false;
                                                   }
                                                   
                                                  var responseJson = await NetworkUtils.studentsAbsent(_user_id, _role_ID.toString(), _schoolID, _schoolBrID,list[position]['Student_ID']['_id'].toString(), absent, "/Absent/TodayUpdate", _authToken);
                                                  if(responseJson == null) {
                                                    print("SnackBar6 Absent RaisedButton");
                                                    //NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong on Trip!');

                                                  } else if(responseJson == 'NetworkError') {
                                                    print("SnackBar4 Absent RaisedButton");
                                                    //NetworkUtils.showSnackBar(_scaffoldKey, "Network Error...");

                                                  } //else if(responseJson['errors'] != null) {
                                                    else if(responseJson['success'] == false) {
                                                    print("SnackBar5 Absent RaisedButton");
                                                    //NetworkUtils.showSnackBar(_scaffoldKey, 'Server Invalid Data');
                                                    setState(() {
                                                        _isThereTrip = false;        
                                                    });
                                                  } else {
                                                    
                                                    //List list = List();
                                                    //list = responseJson as List;
                                                  print("SnackBar6 Absent RaisedButton");
                                                    //print("responseJson:" +responseJson.toString());
                                                    //print("currentTrip:" +currentTrip.toString());
                                                    //print(list[0].toString());
                                                  
                                                  setState(() {
                                                        //currentTrip = responseJson;                          
                                                        //_isThereTrip = true;                                        
                                                    });
                                                
                                                    //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ChangePasswordPage()));
                                                    //Navigator.of(_scaffoldKey.currentContext)
                                                      //.pushReplacementNamed('StartTrip');
                                                    Navigator.of(_scaffoldKey.currentContext)
                                                      .pushReplacementNamed("/");

                                                    return responseJson;
                                                  }
                                              
                                              */
                                                  } ,        
                                                  color: Colors.pink[200],
                                                  child:
                                                    new Text(list[position]['Student_ID']['Absent_ID'] != null ? "Absent": "Present",
                                                      style: new TextStyle(fontSize:18.0,
                                                      color: const Color(0xFF000000),
                                                      fontWeight: FontWeight.w800,
                                                      fontFamily: "Roboto"),
                                                    ),
                                                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                                  ),      

                                                new Padding(
                                                  padding: new EdgeInsets.all(8.0),
                                                ),
                                                /* new RaisedButton(key:null, onPressed: () async{
                                                  //TODO: Insert Student Absent.
                                                var date = new DateRagePicker.DateRange();
                                                   var obj = await date.getDate(context);                                               
                                                    if(obj["picked"] != null)
                                                    {
                                                      //TODO: Send to server.
                                                      print("Absent Date is: " + obj.toString());
                                                    }
                                                    else
                                                    {
                                                        print("Absent Date is Null");
                                                    }

                                                  } ,        
                                                  color: Colors.pink[200],
                                                  child:
                                                    new Text("Absent",
                                                      style: new TextStyle(fontSize:18.0,
                                                      color: const Color(0xFF000000),
                                                      fontWeight: FontWeight.w800,
                                                      fontFamily: "Roboto"),
                                                    ),
                                                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                                ),   */      
                                                new Checkbox(
                                                  value: false,
                                                  onChanged: (bool e) => studentAbsentChange(context, e),
                                                ),
                                                new Text("Absent",
                                                      style: new TextStyle(fontSize:18.0,
                                                      color: const Color(0xFF000000),
                                                      fontWeight: FontWeight.w800,
                                                      fontFamily: "Roboto"),
                                                )
                                               ]
                                            ),
                                    
                                    SizedBox(height: 10.0,),
                                    
                                    ],
                                  ),
                                  )
            ]
              ),
        
		    ),
      );
 }

  void studentAbsentChange(BuildContext context, bool e) async
  {
    //TODO: Insert Student Absent.
    var date = new DateRagePicker.DateRange();
    var obj = await date.getDate(context);                                               
    if(obj["picked"] != null)
    {
      //TODO: Send to server.
      print("Absent Date is: " + obj.toString());
    }
    else
    {
        print("Absent Date is Null");
    }     
  }

   void parentMsgSendCallBack(String guardians_ID, String value, String msgRoute)
  {
    print(" ************************* StudentList Dialog value: " + value);
    print(" ************************* StudentList Dialog guardians_ID: " + guardians_ID);
    //SocketIOClass.sendnotification(guardians_ID, value, msgRoute);  
      NetworkUtils.sendNotification('direct', guardians_ID, value, msgRoute, '/Notification/Add');
  }

}