import 'package:flutter/material.dart';
import 'package:bus_tracker/app/components/NotificationList.dart';
import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
import 'package:bus_tracker/app/utils/GeneralFunction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_tracker/app/components/LoadScreenWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/components/Notification.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

class NotificationScreen extends StatefulWidget {
  static final String routeName = 'notification';
  final String schoolID, schoolBrID, userID, userName, token;
  final int role_ID_Level;
  NotificationScreen(this.userID, this.userName, this. role_ID_Level, this.schoolID, this.schoolBrID, this.token );

  @override
  NotificationScreenState createState() {
    //print("************** NotificationScreen Notificationlist init.. ";
    return new NotificationScreenState();
  }
}

class NotificationScreenState extends State<NotificationScreen>
//TODO: with SingleTickerProviderStateMixin // must add for: "vsync: this"
 { 
var notificationlist;
var supervisorID, driverID, tripID;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
bool _isLoading = false;
bool _isThereNotes = false;

@override
	void initState() {
		super.initState();
    _showLoading();    
    //print("new note1");
		 _fetchNotificationData();    
    //print("new note5");
    _fetchTripIDs();
	}

_fetchNotificationData() async{

		var responseJson = await NetworkUtils.fetchNotificationData("/Notification/listByDate");			
        _hideLoading();
      //print("@@@@@@@@@ _fetchNotificationData: " + responseJson.toString());
      
      //print("new note3");
			
      if(responseJson == "" || responseJson == null) {
        print("SnackBar3 _fetchNotificationData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
        setState(() {
		        _isThereNotes = false;        
		    });
			} else if(responseJson == 'NetworkError') {
        print("SnackBar4 _fetchNotificationData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError()); 
        setState(() {          
		        _isThereNotes = false;        
		    });
			} 
        else if(responseJson['success'] == false) {
        print("SnackBar5 _fetchNotificationData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data()); 
        setState(() {          
		        _isThereNotes = false;        
		    });
			}  else if(responseJson['notification'] != null) {
        print("SnackBar6 _fetchNotificationData home");
				//NetworkUtils.showSnackBar(_scaffoldKey, 'Today Notification'); // TODO: Err: Unhandled Exception: NoSuchMethodError: The method 'showSnackBar' was called on null.
        setState(() {
            notificationlist = responseJson['notification'];                   
            print("SnackBar8 _fetchNotificationData home");            
		        _isThereNotes = true;
            _isLoading = true;
            print("new note4");
          });
          }      
      else {
        _hideLoading();
        return responseJson;
			}

    }
  
_fetchTripIDs() async{
    String urL = widget.role_ID_Level == 5 ? "/ScheduleTrip/StudentTodayTrip" : "/ScheduleTrip/TodayTrip";
    setState(() {
		        supervisorID = driverID = tripID = "";                
		    });

		var responseJson = await NetworkUtils.fetchData(urL);		
      //print("@@@@@@@@@ _fetchTripIDs: " + responseJson['scheduleTrip'][0]['Supervisor_ID'].toString());
       print("@@@@@@@@@ _fetchTripIDs: " + responseJson.toString());

      if(responseJson == "" || responseJson == null) {
        print("SnackBar3 _fetchTripIDs home");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());       
			} else if(responseJson == 'NetworkError') {
        print("SnackBar4 _fetchTripIDs home");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());      
			} 
        else if(responseJson['success'] == false) {
        print("SnackBar5 _fetchTripIDs home");
				//NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());     
			}  else if(responseJson['scheduleTrip'] != null) {
        print("SnackBar6 _fetchTripIDs home");
				//NetworkUtils.showSnackBar(_scaffoldKey, 'Today Notification'); // TODO: Err: Unhandled Exception: NoSuchMethodError: The method 'showSnackBar' was called on null.
        setState(() {     
          //print(responseJson['scheduleTrip'].toString());
          if(widget.role_ID_Level == 5) {
            supervisorID = responseJson['scheduleTrip'][0]['Supervisor_ID'] != null && responseJson['scheduleTrip'][0]['Supervisor_ID'].length != 0 ? responseJson['scheduleTrip'][0]['Supervisor_ID'][0]: null;
            driverID = responseJson['scheduleTrip'][0]['Driver_ID'] != null ? responseJson['scheduleTrip'][0]['Driver_ID']: null;
            tripID = responseJson['scheduleTrip'][0]['_id'];
          } else {
            supervisorID = responseJson['scheduleTrip'][0]['Supervisor_ID'] != null &&  responseJson['scheduleTrip'][0]['Supervisor_ID'].length != 0 ? responseJson['scheduleTrip'][0]['Supervisor_ID'][0]['_id']: null;
            driverID = responseJson['scheduleTrip'][0]['Driver_ID'] != null ? responseJson['scheduleTrip'][0]['Driver_ID']['_id']: null;
            tripID = responseJson['scheduleTrip'][0]['_id'];
          }
          });
          }  
    }

	//_logout() {
//		NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
//	}

  @override
  Widget build(BuildContext context) {    
    //return _isLoading ?  _buildNotificationsContainer(notificationlist) : loadingScreenWidget();
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
      body: ///_isLoading ?  notification(notificationlist) : loadingScreenWidget(),
      (notificationlist != null) ? notification(notificationlist) : loadingScreenWidget(),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,        
        children: getFloatingActionButton(),        
      ),
    );
  }

List<Widget> getFloatingActionButton(){
List<Widget> widgets = new List<Widget>();

      FloatingActionButton schoolAction = new FloatingActionButton(
            backgroundColor:  (widget.schoolID != null && widget.schoolID != "")  ? Theme.of(context).textTheme.display4.color : Colors.grey,// Colors.pinkAccent[100] : Colors.grey, // Theme.of(context).accentColor,
            child: new Icon(
              Icons.school,
              color: (widget.schoolID != null && widget.schoolID != "")  ? Colors.white : Colors.black26,
            ),
            onPressed: () {
               //TODO: Send Complaint to School.
               //print("*********** widget.schoolID: "+ widget.schoolID);
               String msgType = widget.schoolBrID != null ? 'schoolBr': 'school';
               showNoteDialog(context, widget.schoolBrID != null ? widget.schoolBrID: widget.schoolID, widget.schoolBrID != null ? TranslateStrings.to_School_Branch(): TranslateStrings.to_School(), msgType,  msgSendCallBack);
            },
          );
          
          FloatingActionButton supervisorAction = new FloatingActionButton(
            backgroundColor: (supervisorID != null && supervisorID != "")  ? Theme.of(context).textTheme.display4.color : Colors.grey,// Colors.pinkAccent[100] : Colors.grey, // Theme.of(context).accentColor,
            child: new Icon(
              FontAwesomeIcons.user,
              color: (supervisorID != null && supervisorID != "")  ? Colors.white : Colors.black26,
            ),
            onPressed: () {
               //TODO: Send Complaint to Supervisor in Trip.
               //print("*********** widget.supervisorID: " + supervisorID.toString());
               if(supervisorID != null && supervisorID != "") 
                showNoteDialog(context, supervisorID, TranslateStrings.to_Supervisor(),  'direct', msgSendCallBack);
                //else
               //print("*********** widget.supervisorID is null ");
            },
          );  
          
          FloatingActionButton driverAction =new FloatingActionButton(
            backgroundColor: (driverID != null && driverID != "")  ? Theme.of(context).textTheme.display4.color : Colors.grey,// Colors.pinkAccent[100] : Colors.grey, // Theme.of(context).accentColor,
            child: new Icon(
              FontAwesomeIcons.bus,
              color: (driverID != null && driverID != "")  ? Colors.white : Colors.black26,
            ),
            onPressed: () {
               //TODO: Send Complaint to driverID in Trip.
               if(driverID != null && driverID != "") 
                showNoteDialog(context, driverID, TranslateStrings.to_Driver(),  'direct', msgSendCallBack);              
            },
          );   

          widgets.add(schoolAction);

          if(widget.role_ID_Level == 5){
            widgets.add(SizedBox(height: 10,));
            widgets.add(supervisorAction);
            widgets.add(SizedBox(height: 10,));
            widgets.add(driverAction);
          } else if(widget.role_ID_Level == 3){           
            widgets.add(SizedBox(height: 10,));
            widgets.add(driverAction);
          } else if(widget.role_ID_Level == 4){           
            widgets.add(SizedBox(height: 10,));
            widgets.add(supervisorAction);
          }
  return widgets;
}

  Widget nullNotification(){
    return new Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
                TranslateStrings.no_Notification_List(),
                style: new TextStyle(fontSize: 20.0, color: Theme.of(context).textTheme.display3.color),
          ),
          SizedBox(width: 10.0),
          new Icon(FontAwesomeIcons.frown, color: Theme.of(context).textTheme.display3.color ,
          size: Theme.of(context).textTheme.display3.fontSize * 1.5)
        ],
      ), //new TextStyle(fontSize: 20.0, color: Colors.pink[200]),),
    );
  }


  _showLoading() {
		setState(() {
      print("_showLoading");
		  _isLoading = true;
		});
	}

	_hideLoading() {
		setState(() {
      print("_hideLoading");
		  _isLoading = false;
		});
	}

void msgSendCallBack(String recieverID, String value, String msgRoute) {
  print(" ************************* StudentList Dialog value: " + value);
  print(" ************************* StudentList Dialog senderID: " +  widget.userID);
  print(" ************************* StudentList Dialog recieverID: " +  recieverID);
  //SocketIOClass.sendnotification(guardians_ID, "msg", msgRoute);
  NetworkUtils.sendNotification(
      msgRoute, recieverID, value, msgRoute, '/Notification/Add');
  _fetchNotificationData();    
}

 // Create vertical List of Contaner ( Notification)
Widget _buildNotificationsContainer(List list){
  print("@@@@@@@@@ _buildNotificationsContainer: " + list.toString());
 return Align(
   //key: _scaffoldKey,
   alignment: Alignment.topLeft,
   //child: Center(
     //margin: EdgeInsets.symmetric(vertical: 20.0),
     //height: 200.0,
     child: ListView.builder(
            itemCount: list != null ? list.length: 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, position) => new Column(       
                children: <Widget>[
                  SizedBox(width: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(list[position]["Content"],list[position]["Created_at"]),                    
                    //Text("fffffffffffffffffff"),
                  ),          
                ],
              )
     )

   //),
   ); 
}

Widget _buildNullContainer(){
  return Align(
   alignment: Alignment.bottomLeft,
   child: Container(
     margin: EdgeInsets.symmetric(vertical: 20.0),
     height: 200.0,
     child: ListView(
       scrollDirection: Axis.horizontal,
       children: <Widget>[ 
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: _boxes(
             TranslateStrings.no_Student_List(), ""
           ),
         ),
       ],
     )

   ),
   ); 
}

Widget _buildNullContainer2(){
  return Align(
   alignment: Alignment.bottomLeft,
   child: Container(
     margin: EdgeInsets.symmetric(vertical: 20.0),
     height: 200.0,
     child: Text(TranslateStrings.noData())
   ),
   ); 
}



Widget _boxes(String _content, String _created_at){
    return GestureDetector(
        onTap: () {
          //_gotoLocation(lat,long);
        }, 
        child: new FittedBox(
          child: Material(            
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                /*Container( //TODO: Add sender Image.
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.none,
                      //image: NetworkImage(_image),
                      image:  _image == null || _image =="" ? ExactAssetImage('lib/app/assets/Student/student_menu_icon96x96.png') : NetworkImage(_image), 
                    ),
                  ),             
                ),*/
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: myDetailsContainer(_content,_created_at),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
}

Widget myDetailsContainer(String _content, String _created_at) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Center(
              child: Text(_content == null || _content == "" ? "null": _content,
              style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
              )),
        ),           
        Center(
          child: Text(
            _created_at == null || _created_at == "" ? TranslateStrings.date_Time(): _created_at,
            style: TextStyle(
              color: Colors.black54,
                fontSize: 18.0,
            )
          ),
        ),       
            
        /*Container(
          child: Text(
            parentName == null || parentName == "" ? "Parent: null": parentName,
            style: TextStyle(
              color: Colors.black54,
                fontSize: 18.0,
            )
          ),
        ),*/       
       
        /*Container(
          child: new Row(children: <Widget>[
            IconButton(icon: new Icon(FontAwesomeIcons.comments,size: 18,), color: Colors.pink[300],
            onPressed: () {
              //TODO: Send Notification, 
              // TODO: dialog 
              //showParentNoteDialog(context, );
              print("**************** mapList: ");
              //showParentNoteDialog(context, guardians_ID, parentMsgSendCallBack, "direct", "Send Msg To " + parentName == null || parentName == "" ? "Parent": parentName);               
              
            },),
           Text(
            parentPhone == null || parentPhone == "" ? "Phone: null": parentPhone,
            style: TextStyle(
              color: Colors.black54,
                fontSize: 18.0,
            )
          ),
          IconButton(icon: new Icon(FontAwesomeIcons.phone,size: 18), color: Colors.pink[300],
            onPressed: () {
              //TODO: Make a Call , [Done]
              if(parentPhone != null && parentPhone != "")
              {
                  //phoneCall(parentPhone);
              }
            },),
              IconButton(icon: new Icon(FontAwesomeIcons.sms,size: 18), color: Colors.pink[300],
              onPressed: () {
              //TODO: Make a Call , [Done]
              if(parentPhone != null && parentPhone != "")
              {
                  //sms(parentPhone);
              }
            },),
          ]),
        ),     */  

    ],
    );
}

Future<void> _gotoLocation (double lat, double long) async{
    /*final GoogleMapController controller = await _controller.future;
    // Animate the camera position to that lat, long
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 15,
          tilt: 50.0,
          bearing: 45.0
        )
      )
    );*/
}

Widget notification(List list) { 
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
                          color: Theme.of(context).textTheme.display4.color, //Colors.red,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        new Text(
                          TranslateStrings.notes() + ": ${list[position]["Content"]}",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              //"${list[position]["Created_at"].toString().replaceAll('T', ' ')}",
                              //"${list[position]["Created_at"].toString().replaceAll('T', ' ')}",
                               //DateFormat('yyyy-MM-dd – kk:mm').format(now); //TODO:datetime
                               "${parsingDateTime(list[position]["Created_at"].toString())}",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: Theme.of(context).textTheme.display3.fontSize),
                            ),
                            //new Text(
                            //  "Phone: ${list[position]['Student_ID']['Guardians_ID'] != null? list[position]['Student_ID']['Guardians_ID'][0]['Phone']: ""}",
                            //  style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                            //),
                            //Container(                              
                              //child: Column(
                                //children: <Widget>[
                                   Text((list[position]["Type"] != null && list[position]["Type"] == "direct") ? 
                                    (list[position]["Created_By"]["_id"] == widget.userID ? TranslateStrings.msg_To() + ": ${list[position]["Receiver"] != null ? list[position]["Receiver"]["Name"]: "Null"}" :  TranslateStrings.msg_From() + ": ${list[position]["Created_By"]["Name"]}") 
                                    : // direct false: 
                                    (list[position]["Type"] != null && list[position]["Type"] == "school") ? 
                                    (list[position]["Created_By"]["_id"] == widget.userID ? TranslateStrings.msg_To() + ": ${list[position]["To_School_ID"] != null ? list[position]["To_School_ID"]["SC_Name_ar"]: "Null"}" : TranslateStrings.msg_From() + ": ${list[position]["Created_By"]["Name"]}")
                                    : // school false
                                    "null" , //TODO: Add schoolBr like school,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: Theme.of(context).textTheme.display3.fontSize,
                                        )),

                                  //new Row( 
                                   // mainAxisAlignment: MainAxisAlignment.center,
                                    //children: <Widget>[
                                    IconButton(
                                      icon: new Icon(
                                        FontAwesomeIcons.commentAlt,
                                        size: 18,
                                      ),
                                      color: Colors.pink[300],
                                      onPressed: () {
                                        //TODO: Send Notification
                                        if(list[position]["Type"] != null && list[position]["Type"] == "direct"){
                                        String _id = (list[position]["Created_By"]["_id"] == widget.userID) ? ((list[position]["Receiver"] != null)? list[position]["Receiver"]["_id"] : "Null" ): ((list[position]["Created_By"] != null) ? list[position]["Created_By"]["_id"] : "Null");
                                        String name = (list[position]["Created_By"]["_id"] == widget.userID) ? ((list[position]["Receiver"] != null)? list[position]["Receiver"]["Name"] : "Null" ): ((list[position]["Created_By"] != null) ? list[position]["Created_By"]["Name"] : "Null");
                                        showNoteDialog(context, _id, name, "direct", msgSendCallBack);                 
                                        } else if(list[position]["Type"] != null && list[position]["Type"] == "school"){
                                          String _id = (list[position]["Created_By"]["_id"] == widget.userID) ? ((list[position]["To_School_ID"] != null)? list[position]["To_School_ID"]["_id"] : "Null" ): ((list[position]["Created_By"] != null) ? list[position]["Created_By"]["_id"] : "Null");
                                        String name = (list[position]["Created_By"]["_id"] == widget.userID) ? ((list[position]["To_School_ID"] != null)? list[position]["To_School_ID"]["SC_Name_ar"] : "Null" ): ((list[position]["Created_By"] != null) ? list[position]["Created_By"]["Name"] : "Null");
                                        showNoteDialog(context, _id, name, "school", msgSendCallBack);  
                                        } else if(list[position]["Type"] != null && list[position]["Type"] == "schoolBr"){

                                        }            
                                      }
                                    ),                                 
                            
                             
                                  //]),
                                  
                                //],
                              //),
                            //),
                          ]),
                    ),
                  ),          
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            )
          ]),
    ),
  );
}


  } // end class