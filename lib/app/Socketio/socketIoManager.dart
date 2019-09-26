//import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
//import 'package:geolocator/geolocator.dart';
//import '../utils/GlobalIDs.dart';
//import 'dart:convert';
import 'dart:async';
//import 'package:flutter/material.dart';
//import '../geolocator/pages/location_stream_class.dart' as geoLocation;
//import 'package:geolocator/geolocator.dart';

//import 'package:provider/provider.dart';
//import 'package:bus_tracker/app/states/App_MapState.dart'  as geoLocationMap;

class SocketIOClass {

//TODO: Sample:
String _name = 'Abdo';
String get name => _name;
void changeName(String name){
  this._name = name;
  //notifyListeners();
}
//TODO: only three step above.
//TODO: how to use:
// import scoped_model packages and all custom Model in main page.
// in main function: new MyApp(user: User(),)
// in class MyApp: final User user;, 
// const MyApp({key key, this.user}) : supper(key: key);
// in build: return ScopeModel<User>(model: user,)
// in MyhomePageState: child: scopedMpdelDescendant<User>(builder: (context, child, model){})

SocketIOClass._privateConstructor();
//static final SocketIOClass _instance = SocketIOClass._privateConstructor();

factory SocketIOClass() {
    if (_instance == null) {
      _instance = SocketIOClass._privateConstructor();
    }
    return _instance;
  }

static SocketIOClass _instance;


  StreamController<dynamic> trip_Rec_updateLocationStreamController;
  //static Stream<int> clickStream;
  StreamController<dynamic> onRec_bus_speed_alertStreamController;
  StreamController<dynamic> onRec_Trip_noteStreamController;
  StreamController<dynamic> onRec_student_pick_upStreamController;
  StreamController<dynamic> onRec_student_leaveStreamController;
  StreamController<dynamic> onRec_BusTrip_update_OSM_RouteStreamController;
  StreamController<dynamic> onSchoolRec_updateLocationStreamController;
  StreamController<dynamic> onUserRec_notificationStreamController;
  StreamController<dynamic> onRec_zoon_alertStreamController;
  StreamController<dynamic> onRec_zoonStreamController;
  StreamController<dynamic> onRec_student_absentStreamController;
  StreamController<dynamic> onRec_student_AttendanceStreamController;
  StreamController<dynamic> onRec_advertiseStreamController;

  // Keys to store and fetch data from SharedPreferences
  static String token = ""; //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjVjODgwMDVlNzc5ZjVmM2Q5MDlkNGRmZSIsIk5hbWUiOiLYudin2KbYtNipINi52KjYr9in2YTZhdit2YXZiNivIiwidXNlcm5hbWUiOiJfMiIsInBhc3N3b3JkIjoiJDJhJDEwJDVqeTJiMzlRSlYyMmh0RWFFNDl6Wi5vUS5BdEVuYUJuN3lrY2xQaTkwQW9yOXVMNlpPb042IiwiRW1haWwiOiIiLCJQaG9uZSI6IjEyMzEyMzEyMyIsIlJvbGVfSUQiOnsiX2lkIjoiNWM4MzU1MmJjMWE0NDcyZDVjZDVkYzI0IiwiUm9sZV9JRCI6MywiUm9sZV9OYW1lX2FyIjoiU3VwZXJ2aXNvciIsIlJvbGVfTmFtZV9lbiI6IlN1cGVydmlzb3IiLCJDcmVhdGVkX2J5IjoiNWM2NmZlYmUyZTMyNmEyZWM0MmMyZWIxIiwiQ3JlYXRlZF9hdCI6IjIwMTktMDMtMDlUMDU6NTQ6NTEuNTc1WiIsIlN0YXR1cyI6dHJ1ZSwiSURfUmVmIjozLCJfX3YiOjB9LCJJTUVJIjoiTlVMTCIsIlJlZ19JRCI6Ik5VTEwiLCJVc2VyX1R5cGUiOiIzIiwiTGF0aXR1ZGUiOjE1LCJMb25naXR1ZGUiOjMyLCJTY2hvb2xfSUQiOnsiX2lkIjoiNWM4MzViYzkwYTAwZjYzNGQ4NGEzYjI1IiwiU0NfTmFtZV9hciI6ItmF2K_Yp9ix2LMg2KfZhNmC2KjYsyDYqNit2LHZiiIsIlNDX05hbWVfZW4iOiLZhdiv2KfYsdizINin2YTZgtio2LMg2KjYrdix2YoiLCJTQ19tYW5hZ2VyX05hbWUiOiIxNCIsIlNjX01hbmFnZXJfQ29udGFjdCI6IjE0IiwiU2NfbWFuYWdlcl9FbWFpbCI6IjE0IiwiU2NfQWRkcmVzc19hciI6IiIsIkxhdGl0dWRlIjoxNS42Nzg5ODUsIkxvbmdpdHVkZSI6MzIuNTQ0NTM3LCJTY19JbWciOiIiLCJDcmVhdGVkX2J5IjoiNWM2NmZlYmUyZTMyNmEyZWM0MmMyZWIxIiwiQ3JlYXRlZF9hdCI6IjIwMTktMDMtMDlUMDY6MjM6MDUuODExWiIsIlN0YXR1cyI6dHJ1ZSwiSURfUmVmIjoxNCwiX192IjowLCJTY19Dc3NJbWciOltdfSwiU2Nob29sX0JyX0lEIjpudWxsLCJDcmVhdGVkX2J5IjoiNWM2NmZlYmUyZTMyNmEyZWM0MmMyZWIxIiwiQ3JlYXRlZF9ieV9SZWYiOiI3MTQ0IiwiQ3JlYXRlZF9hdCI6IjIwMTktMDMtMTJUMTg6NTQ6MjIuNTkwWiIsIlN0YXR1cyI6dHJ1ZSwiSURfUmVmIjo3NjAzLCJfX3YiOjAsIlVwZGF0ZWRfYXQiOiIyMDE5LTAzLTI1VDA2OjUwOjI2Ljk2MloifSwiaWF0IjoxNTY0MTI2MTk0LCJleHAiOjE1NjQ3MzA5OTR9.urcbvNFBDNJ7zR07j7vdh6wQM480WxfX_RJZx14u6EE";
  static String userId = ""; //"5c88005e779f5f3d909d4dfe";
  static String username = ""; //"عائشة عبدالمحمود";
  //static String password = "";
  //static int roleID = 0;
  static String roleIDstr = ""; //"5c83552bc1a4472d5cd5dc24";
  static int roleLevel = 0 ; //3;
  static String email = "";
  static String schoolID = ""; //"5c835bc90a00f634d84a3b25";
  static String schoolBrID = ""; //null;
  static String tripID = "";
  static String companyName = ""; //"sidco";
  static String socketId = "";
  //static String ipAddress = "http://10.0.2.2:3000"; // to run localy
  static String ipAddress = "http://localhost:3000"; // to run in device

  static String getiDs() {
    String jsonData =
        '{"token": "$token", "User_ID": "$userId", "username": "$username", "roleID_str": "$roleIDstr", "roleLevel": "$roleLevel", "email": "$email", "schoolID": "$schoolID", "schoolBrID": "$schoolBrID", "tripID": "$tripID"}';
    return jsonData;
  }

  static String schoolIDs() {
    return schoolID != null && schoolID != ""
        ? schoolID
        : "" + schoolBrID != null ? schoolBrID : "";
  }

  //static int  counter = 0;
  //var mTextMessageController = new TextEditingController();
  static SocketIO socketIO = null;
  //static SocketIO socketIO02;

   void initValues(
      String _token,
      String _roleIDstr,
      int _roleLevel,
      String _userId,
      String _username,
      String _email,
      String _schoolID,
      String _schoolBrID,
      String _tripID
      ) {
    print("############  initValues:");
    print("############  socketIO != null:" + (socketIO != null).toString());
    if (socketIO != null) return;

    token = _token;
    userId = _userId;
    username = _username;
    //password = _password;
    //static int roleID = 0;
    roleIDstr = _roleIDstr;
    roleLevel = _roleLevel;
    email = _email;
    schoolID = _schoolID;
    schoolBrID = _schoolBrID;
    tripID = _tripID;
    //companyName = "sidco";
    //socketId = "";

   initStreams();

  }

  void connectSocket02() {
    /*print("########### token: " + token);
print("########### userId:" + userId);
print("########### username:" + username);
print("########### roleIDstr:" + roleIDstr);
print("########### roleLevel:" + roleLevel.toString());
print("########### schoolID:" + schoolID.toString());
print("########### schoolBrID:" + schoolBrID.toString());
print("########### tripID:" + tripID.toString());*/

    connectSocket01(token, roleIDstr, roleLevel, userId, username, email,
        schoolID, schoolBrID, tripID);
  }

  void connectSocket01(
      String _token,
      String _roleIDstr,
      int _roleLevel,
      String _userId,
      String _username,
      String _email,
      String _schoolID,
      String _schoolBrID,
      String _tripID
      ) {
    print("############  connectSocket01:");

    /*print("############  connectSocket01 _token :" + _token);
    print("############  connectSocket01 _userId :" + _userId);
    print("############  connectSocket01 _username :" + _username);
    print("############  connectSocket01 _roleIDstr :" + _roleIDstr);
    print("############  connectSocket01 _roleLevel :" + _roleLevel.toString());
    print("############  connectSocket01 _email :" + _email);
    print("############  connectSocket01 _schoolID :" + _schoolID);
    print("############  connectSocket01 _schoolBrID :" + _schoolBrID);*/

    //if (socketIO != null) return;

    token = _token;
    userId = _userId;
    username = _username;
    //password = _password;
    //static int roleID = 0;
    roleIDstr = _roleIDstr;
    roleLevel = _roleLevel;
    email = _email;
    schoolID = _schoolID;
    schoolBrID = _schoolBrID;
    tripID = _tripID;
    //companyName = "sidco";
    //socketId = "";

//print("########### token: " + token);
//print("########### userId:" + userId);
//print("########### username:" + username);
//print("########### roleIDstr:" + roleIDstr);
//print("########### roleLevel:" + roleLevel.toString());
//print("########### schoolID:" + schoolID.toString());
//print("########### schoolBrID:" + schoolBrID.toString());
    //print("########### tripID:" + tripID.toString());

    try {

    initStreams();

      //update your domain before using
      /*socketIO = new SocketIO("http://127.0.0.1:3000", "/chat",
        query: "userId=21031", socketStatusCallback: _socketStatus);*/
      //socketIO = SocketIOManager().createSocketIO("http://10.0.2.2:3000", "/chat", query: "userId=21031", socketStatusCallback: _socketStatus);
      print("########## Socket prepeare connecton ");
      //socketIO = SocketIOManager().createSocketIO(ipAddress, "/", query: "userId=21031", socketStatusCallback:  socketStatus);
      socketIO = SocketIOManager()
          .createSocketIO(ipAddress, "/", socketStatusCallback: _socketStatus);

      //call init socket before doing anything
      socketIO.init();

      //subscribe event
      //socketIO.subscribe("socket_info",  onSocketInfo);
      //socketIO.subscribe("socket_info2",  onSocketInfo2);
      // Auto Alert guardians when vehicles reach latest vehicles stop location or when specific time.
      // Supervisor app: send notice to parent
      // calc. student pickup location distance, get time to alert . the generate alert
      // require: {type:  updateLocation, parent id, msg, ETA, Distance}, queue sending: notice, queue receiving by: noted
      // save bus tracker in DB.
      bool nott = false;

      // updateLocation
      if (schoolIDs() != "")
        socketIO.subscribe(schoolIDs() + "rec_updateLocation", _onSchoolRec_updateLocation);
      else
        print("########## rec_updateLocation is nul");
      //sendUpdateLocation(msg);

      // user note
      if (userId != null)
        socketIO
            .subscribe(userId + "rec_notification", _onUserRec_notification);
      else
        print("########## rec_notification1 is nul");
      
      print("########## setTripIdSubscribe0 true");
      setTripIdSubscribe0(true);
      
     
        

        // user note
        //if(userId != null)
        //socketIO.subscribe(userId + "rec_notification", onSocketInfonote);
        //else print("########## rec_notification1 is nul");

        // TODO: grade note
        //if(schoolIDs() != null)
        //socketIO.subscribe(schoolIDs() + "rec_notification", onSocketInfonote);
        //else print("########## rec_notification4 is nul");
   
        // zoon.alert
        if (schoolIDs() != null)
          socketIO
              .subscribe(schoolIDs() + "rec_zoon.alert", _onRec_zoon_alert);
        else
          print("########## rec_zoon.alert is nul");

        // zoon
        if (schoolIDs() != null)
          socketIO
              .subscribe(schoolIDs() + "rec_zoon", _onRec_zoon);
        else
          print("########## rec_zoon is nul");

        // student.absent
        if (schoolIDs() != null)
          socketIO
              .subscribe(schoolIDs() + "rec_student.absent", _onRec_student_absent);
        else
          print("########## rec_student.absent is nul");
        // student.Attendance
        if (schoolIDs() != null)
          socketIO
              .subscribe(schoolIDs() + "rec_student.Attendance", _onRec_student_Attendance);
        else
          print("########## rec_student.Attendance is nul");
        
        // advertise
        if (companyName != null)
          socketIO
              .subscribe(companyName + "rec_advertise", _onRec_advertise);
        else
          print("########## rec_advertise is nul");

        // Error in handler
        if (socketId != null)
          socketIO
              .subscribe(socketId + "error.messages", _onErrorCallback);
        else
          print("########## error.messages is nul");
      
      //connect socket
      socketIO.connect();
      print("########## socketIO connect: " + (socketIO != null).toString());
    } catch (e) {
      print("########## connectSocket01 Error: " + e.toString());
    }
    
  }

void initStreams(){
 print("########## Create StreamController in initStreams");
      // Create a controller for a stream that can broadcast
  trip_Rec_updateLocationStreamController = new StreamController<dynamic>.broadcast();
    //clickStream = trip_Rec_updateLocationStreamController.stream;
    ///print("########## clickStream Created in initValues");

  onRec_bus_speed_alertStreamController = new StreamController<dynamic>.broadcast();
  onRec_Trip_noteStreamController = new StreamController<dynamic>.broadcast();
  onRec_student_pick_upStreamController = new StreamController<dynamic>.broadcast();
  onRec_student_leaveStreamController = new StreamController<dynamic>.broadcast();
  onRec_BusTrip_update_OSM_RouteStreamController = new StreamController<dynamic>.broadcast();
  onSchoolRec_updateLocationStreamController = new StreamController<dynamic>.broadcast();
  onUserRec_notificationStreamController = new StreamController<dynamic>.broadcast();
  onRec_zoon_alertStreamController = new StreamController<dynamic>.broadcast();
  onRec_zoonStreamController = new StreamController<dynamic>.broadcast();
  onRec_student_absentStreamController = new StreamController<dynamic>.broadcast();
  onRec_student_AttendanceStreamController = new StreamController<dynamic>.broadcast();
  onRec_advertiseStreamController = new StreamController<dynamic>.broadcast();

}

Future setTripId(String _tripId) async
{
  tripID = _tripId;
  print("########## setTripIdSubscribe0 true setTripId");
  await setTripIdSubscribe0(true);
}

Future clearTripId() async
{
  tripID = "";
  print("########## setTripIdSubscribe0 false clearTripId");
  await setTripIdSubscribe0(false);
}

Future setTripIdSubscribe0(bool subscribe) async{
print("########## call setTripIdSubscribe0");

//return;

  // Bus Trip updatelocation
      if (tripID != null)
        socketIO.subscribe(tripID + "rec_BusTrip.updatelocation",
            _onSocketInfoBusTripLocationChange);
      else
        print("########## rec_BusTrip.updatelocation is nul");
        
// bus.speed.alert
        print("########## setTripIdSubscribe0 tripID:" + tripID);
        if (tripID != null && tripID != ""){
          if(subscribe) socketIO.subscribe(tripID + "rec_bus.speed.alert", _onRec_bus_speed_alert);
          else socketIO.unSubscribe(tripID + "rec_bus.speed.alert", _onSocketInfo3);
        }
        else
          print("########## rec_bus.speed.alert is null 2");

// Trip.note
        if (tripID != null && tripID != ""){
          if(subscribe) socketIO
              .subscribe(tripID + "rec_Trip.note", _onRec_Trip_note);
            else   socketIO.unSubscribe(tripID + "rec_Trip.note", _onSocketInfo3);
        }
        else
          print("########## rec_Trip.note is null 2");

// student.pick_up_change
        if (tripID != null && tripID != ""){
          if(subscribe) socketIO
              .subscribe(tripID + "rec_student.pick_up_change", _onRec_student_pick_up);
          else socketIO
              .unSubscribe(tripID + "rec_student.pick_up_change", _onSocketInfo3);
        }
        else
          print("########## rec_student.pick_up_change is null 2");

// student.leave
        if (tripID != null && tripID != ""){
          if(subscribe)socketIO
              .subscribe(tripID + "rec_student.leave", _onRec_student_leave);
              else socketIO
              .unSubscribe(tripID + "rec_student.leave", _onSocketInfo3);
        }
        else
          print("########## rec_student.leave is null 2");

// rec_BusTrip.update_OSM_Route
        if (tripID != null && tripID != ""){
          if(subscribe)socketIO
              .subscribe(tripID + "rec_BusTrip.update_OSM_Route", _onRec_BusTrip_update_OSM_Route);
              else socketIO
              .unSubscribe(tripID + "rec_BusTrip.update_OSM_Route", _onSocketInfo3);
        }
        else
          print("########## rec_student.leave is null 2");

 /*if (tripID != null && tripID != "" && (roleLevel == 3)) // || roleLevel == 4))
    geoLocation.LocationStream.streamBroadcastController.stream
        .listen((Position position) {
      //print("##########  position : " + position.toString());
      //print("##########  tripID : " + tripID);
      if(tripID != "" && tripID != null) sendUpdateLocation(position);
    });*/

    if (tripID != null && tripID != "" && (roleLevel == 3)) // || roleLevel == 4))
    {
    //  geoLocationMap.AppMapState.positionStream
    //    .listen((Position position) {
    //  print("##########  position : " + position.toString());
    //  //print("##########  tripID : " + tripID);
    //  if(tripID != "" && tripID != null) sendUpdateLocation(position);
    //  });
    }

 }

  _onErrorCallback(dynamic data) {
    print("########## Socket onError: " + data);
  }

  _onSocketInfo(dynamic data) {
    print("########## Socket info: " + data);
  }

  _onSocketInfo2(dynamic data) {
    print("########## Socket info2: " + data);
  }

  _onSocketInfo3(dynamic data) {
    print("########## Socket info3: " + data);
  }

  _onSocketInfoBusTripLocationChange(dynamic data) {
    print("########## Socket _onSocketInfoBusTripLocationChange: " + data);
    trip_Rec_updateLocationStreamController.add(data);
  }

  _onRec_bus_speed_alert(dynamic data) {
    print("########## Socket _onRec_bus_speed_alert: " + data);
    onRec_bus_speed_alertStreamController.add(data);
  }

  _onRec_Trip_note(dynamic data) {
    print("########## Socket _onRec_Trip_note: " + data);
    onRec_Trip_noteStreamController.add(data);
  }

  _onRec_student_pick_up(dynamic data) {
    print("########## Socket _onRec_student_pick_up: " + data);
    onRec_student_pick_upStreamController.add(data);
  }

  _onRec_student_leave(dynamic data) {
    print("########## Socket _onRec_student_leave: " + data);
    onRec_student_leaveStreamController.add(data);
  } 

  _onRec_BusTrip_update_OSM_Route(dynamic data) {
    print("########## Socket _onRec_BusTrip_update_OSM_Route: " + data);
    onRec_BusTrip_update_OSM_RouteStreamController.add(data);
  } 

  _onSchoolRec_updateLocation(dynamic data) {
    print("########## Socket _onSchoolRec_updateLocation: " + data);
    onSchoolRec_updateLocationStreamController.add(data);
  }

  _onUserRec_notification(dynamic data) {
    print("########## Socket _onUserRec_notification: " + data);
    onUserRec_notificationStreamController.add(data);
  }

  _onRec_zoon_alert(dynamic data) {
    print("########## Socket _onRec_zoon_alert: " + data);
    onRec_zoon_alertStreamController.add(data);
  }

  _onRec_zoon(dynamic data) {
    print("########## Socket _onRec_zoon: " + data);
    onRec_zoonStreamController.add(data);
  }

  _onRec_student_absent(dynamic data) {
    print("########## Socket _onRec_student_absent: " + data);
    onRec_student_absentStreamController.add(data);
  }

  _onRec_student_Attendance(dynamic data) {
    print("########## Socket _onRec_student_Attendance: " + data);
    onRec_student_AttendanceStreamController.add(data);
  }

  _onRec_advertise(dynamic data) {
    print("########## Socket _onRec_advertise: " + data);
    onRec_advertiseStreamController.add(data);
  }

  //Stream<int> getclickStream(){
  //  return clickStream;
  //}

  _onSocketInfonote(dynamic data) {
    print("########## Socket info note: " + data);
  }

  bool socketConnection = false;
  _socketStatus(dynamic data) {
    print("########## Socket status: " + data);
    if (socketIO == null) {
      print('########## socketIO is null,  socketStatus');
    }
    if (data == "connect") {
      socketConnection = true;
      _logintoServer();
    } else {
      socketConnection = false;
    }
  }

  //_onSocketInfo02(dynamic data) {
  //  print("Socket 02 info: " + data);
  //}

  //_socketStatus02(dynamic data) {
  //  print("Socket 02 status: " + data);
  //}

   subscribes() {
    print("########## subscribes " + (socketIO != null ? "Not null" : "Null"));
    if (socketIO != null) {
      socketIO.subscribe("chat_direct", onReceiveChatMessage);
    } else {
      print('########## socketIO is null,  subscribes');
    }
  }

   unSubscribes() {
    print(
        "########## unSubscribes " + (socketIO != null ? "Not null" : "Null"));
    if (socketIO != null) {
      socketIO.unSubscribe("chat_direct", onReceiveChatMessage);
    } else {
      print('########## socketIO is null,  unSubscribes');
    }
  }

   reconnectSocket() {
    print("########## reconnect Socket, socketIO is " + (socketIO != null? "Not null": "Null"));
    if (socketIO == null) {
       connectSocket02();
    } else {
      socketIO.connect();
    }
  }

   disconnectSocket() {
    print("########## disconnectSocket socketIO is " +
        (socketIO != null ? "Not null" : "Null"));
    if (socketIO != null) {
      socketIO.disconnect();
    } else {
      print('########## socketIO is null,  disconnectSocket');
    }
  }

   destroySocket() {
    print(
        "########## destroySocket " + (socketIO != null ? "Not null" : "Null"));
    if (socketIO != null) {
      SocketIOManager().destroySocket(socketIO);
    } else {
      print('########## socketIO is null, destroySocket ');
    }
  }

//TODO: Login
   void _logintoServer() async {
    if (socketIO != null) {
      print('##########  SEND Login  ##########');
      //String jsonData = '{"token" : "${GlobalIDs.token}", "username" : "${GlobalIDs.username}", "password" : "${GlobalIDs.password}"}';
      String jsonData = getiDs();
      print('########## jsonData logintoServer');
      socketIO.sendMessage("login", jsonData, onReceiveChatMessage);
      print('########## socketIO login isSocketNullable : ' + isSocketNullable().toString());
    } else {
      print('########## socketIO is null,  logintoServer');
    }
  }

  void sendChatMessage(String msg) async {
    if (socketIO != null) {
      print('##########  SEND MESSAGE  ##########');
      String jsonData =
          '{"message":{"type":"Text","content": ${(msg != null && msg.isNotEmpty) ? '"${msg}"' : '"Hello SOCKET IO PLUGIN :))"'},"owner":"589f10b9bbcd694aa570988d","avatar":"img/avatar-default.png"},"sender":{"userId":"589f10b9bbcd694aa570988d","first":"Ha","last":"Test 2","location":{"lat":10.792273999999999,"long":106.6430356,"accuracy":38,"regionId":null,"vendor":"gps","verticalAccuracy":null},"name":"Ha Test 2"},"receivers":["587e1147744c6260e2d3a4af"],"conversationId":"589f116612aa254aa4fef79f","name":null,"isAnonymous":null}';
      socketIO.sendMessage("chat_direct", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null,  sendChatMessage');
    }
  }

//TODO: send update location to server
  void sendUpdateLocation(var location) async {
    if (socketIO != null) {
      //print('##########  SEND sendUpdateLocation  ##########');
      String jsonData =
          '{ "latitude" : ${location.latitude} , "longitude" : ${location.longitude} , "Sender" : ${getiDs()}}';
      socketIO.sendMessage("updateLocation", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null,  sendUpdateLocation');
    }
  }

//TODO: send update location to server
  void sendTripUpdateLocation(var location) async {
    if (socketIO != null) {
      //print('##########  SEND sendTripUpdateLocation  ##########');
      String jsonData =
          '{ "latitude" : ${location.latitude} , "longitude" : ${location.longitude} , "Sender" : ${getiDs()}}';
      socketIO.sendMessage("TripUpdateLocation", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null,  sendTripUpdateLocation');
    }
  }

//TODO: send update location to server
  void sendTripRoute(String scheduleTrip_ID, var route) async {
    if (socketIO != null) {
      //print('##########  SEND sendTripRoute  ##########');
      String jsonData =
          '{ "ScheduleTrip_ID" : ${scheduleTrip_ID} , "Route" : ${route}, "Sender" : ${getiDs()}}';
      socketIO.sendMessage("TripRouteUpdate", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null,  TripRouteUpdate');
    }
  } 

//TODO: send sendBusSpeedAlert to server
  void sendBusSpeedAlert(String tripID, var timestamp, var latitude, var longitude, var speed) async {
    if (socketIO != null) {
      //print('##########  SEND sendBusSpeedAlert  ##########');
      String jsonData =
          '{ "Trip_ID" : ${tripID}, "Date" : ${timestamp},"Latitude" : ${latitude},"Longitude" : ${longitude},"Speed" : ${speed},"Sender" : ${getiDs()}}';
      socketIO.sendMessage("bus.speed.alert", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null,  sendBusSpeedAlert');
    }
  }

//TODO: current work in Notification
  void sendnotification(
      String guardians_ID, String msg, String msgRoute) async {
    if (socketIO != null) {
      print('##########  SEND notification MESSAGE  ##########');
      String type = msgRoute == "direct"
          ? '"Type":"direct", "Receiver": "$guardians_ID"'
          : '"Type":"room", "Receiver": "aaa"';
      //String jsonData = '{ $type, "Content" : "$msg" , "Sender" : "${getiDs()}", "token" : "${token}", "username" : "${username}"}';
      String jsonData = '{$type, "Content" : "$msg" , "Sender" : ${getiDs()}}';
      //var ff= msgRoute == "direct"?  "Type:direct, Receiver: $guardians_ID" : "Type:room, Receiver: aaa";
      //ff = "$type, Content : $msg";
//jsonData = json.encode(ff);
      //print("########## is socket Connected: " + socketConnection.toString());
      //if(!socketConnection) socketIO.connect();
      socketIO.sendMessage("notification", jsonData, onReceiveChatMessage);
      //socketIO.sendMessage("notification", jsonData,  onReceiveChatMessage);    

    } else {
      print("########## socketIO is null, reconnecting.. ");
      reconnectSocket();
    }
  }

//TODO: current work in Notification
  void sendMultiplenotification(
      var guardians_ID, String msg, String msgRoute) async {
    if (socketIO != null) {
      print('##########  SEND notification MESSAGE  ##########');
      String type = msgRoute == "direct"
          ? '"Type":"direct", "Receiver": "$guardians_ID"'
          : '"Type":"room", "Receiver": "aaa"';
      //String jsonData = '{ $type, "Content" : "$msg" , "Sender" : "${getiDs()}", "token" : "${token}", "username" : "${username}"}';
      String jsonData = '{$type, "Content" : "$msg" , "Sender" : ${getiDs()}}';
      //var ff= msgRoute == "direct"?  "Type:direct, Receiver: $guardians_ID" : "Type:room, Receiver: aaa";
      //ff = "$type, Content : $msg";
//jsonData = json.encode(ff);
      //print("########## is socket Connected: " + socketConnection.toString());
      //if(!socketConnection) socketIO.connect();
      socketIO.sendMessage("notificationM", jsonData, onReceiveChatMessage);
      //socketIO.sendMessage("notification", jsonData,  onReceiveChatMessage);    

    } else {
      print("########## socketIO is null, reconnecting.. ");
      reconnectSocket();
    }
  }

  void sendStudentAbsent(String student_ID, String absent_ID) async {
    if (socketIO != null) {
      print('##########  SEND sendStudentAbsent  ##########');
      String jsonData =
          '{ "Student_ID": ${student_ID}, "Absent_ID":  ${absent_ID}, "Sender" : ${getiDs()}}';
      socketIO.sendMessage("student.absent", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null, sendStudentAbsent');
    }
  }

  void sendStudents_TripFinish(String scheduleTrip_ID, String student_ID) async {
    if (socketIO != null) {
      print('########## SEND sendStudents_TripFinish ##########');
      String jsonData =
          '{ "Student_ID": ${student_ID}, ScheduleTrip_ID" : ${scheduleTrip_ID}, "Sender" : ${getiDs()}}';
      socketIO.sendMessage("student.schTripFinish", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null, sendStudents_TripFinish');
    }
  }

  void sendZoon(String msg) async {
    if (socketIO != null) {
      print('########## SEND sendZoon ##########');
      String jsonData =
          '{"message":{"type":"Text","content": ${(msg != null && msg.isNotEmpty) ? '"${msg}"' : '"Hello SOCKET IO PLUGIN :))"'},"owner":"589f10b9bbcd694aa570988d","avatar":"img/avatar-default.png"},"sender":{"userId":"589f10b9bbcd694aa570988d","first":"Ha","last":"Test 2","location":{"lat":10.792273999999999,"long":106.6430356,"accuracy":38,"regionId":null,"vendor":"gps","verticalAccuracy":null},"name":"Ha Test 2"},"receivers":["587e1147744c6260e2d3a4af"],"conversationId":"589f116612aa254aa4fef79f","name":null,"isAnonymous":null}';
      socketIO.sendMessage("zoon", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null, sendZoon');
    }
  }

  void sendZoonAlert(String msg) async {
    if (socketIO != null) {
      print('##########  SEND sendZoonAlert  ##########');
      String jsonData =
          '{"message":{"type":"Text","content": ${(msg != null && msg.isNotEmpty) ? '"${msg}"' : '"Hello SOCKET IO PLUGIN :))"'},"owner":"589f10b9bbcd694aa570988d","avatar":"img/avatar-default.png"},"sender":{"userId":"589f10b9bbcd694aa570988d","first":"Ha","last":"Test 2","location":{"lat":10.792273999999999,"long":106.6430356,"accuracy":38,"regionId":null,"vendor":"gps","verticalAccuracy":null},"name":"Ha Test 2"},"receivers":["587e1147744c6260e2d3a4af"],"conversationId":"589f116612aa254aa4fef79f","name":null,"isAnonymous":null}';
      socketIO.sendMessage("zoon.alert", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null, sendZoonAlert');
    }
  }

  void sendStudentAttendance(String tripID, String waypointListID, String student_ID) async {
    if (socketIO != null) {
      print('##########  SEND sendStudentAttendance  ##########');
      String jsonData =
          '{ "Student_ID": ${student_ID}, "WaypointListID":  ${waypointListID}, "Trip_ID": ${tripID}, "Sender" : ${getiDs()}}';
      socketIO.sendMessage(
          "student.Attendance", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null, sendStudentAttendance');
    }
  }

  void sendStudentPickupChange(String student_id, double latitude, double longitude, String tripID, String schTripID) async {
    if (socketIO != null) {
      print('##########  SEND sendStudentPickupChange  ##########');
      //print('##########  SEND student_id  ##########: ' + student_id);
      String jsonData =
           '{ "Student_ID":  ${student_id},  "latitude" : ${latitude} , "longitude" : ${longitude} , "Trip_ID": ${tripID}, "ScheduleTrip_ID": ${schTripID},  "Sender" : ${getiDs()}}';
      socketIO.sendMessage("student.pick_up_change", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null, sendStudentPickupChange');
    }
  }

  void sendStudentLeave(String msg) async {
    if (socketIO != null) {
      print('##########  SEND MESSAGE  ##########');
      String jsonData =
          '{"message":{"type":"Text","content": ${(msg != null && msg.isNotEmpty) ? '"${msg}"' : '"Hello SOCKET IO PLUGIN :))"'},"owner":"589f10b9bbcd694aa570988d","avatar":"img/avatar-default.png"},"sender":{"userId":"589f10b9bbcd694aa570988d","first":"Ha","last":"Test 2","location":{"lat":10.792273999999999,"long":106.6430356,"accuracy":38,"regionId":null,"vendor":"gps","verticalAccuracy":null},"name":"Ha Test 2"},"receivers":["587e1147744c6260e2d3a4af"],"conversationId":"589f116612aa254aa4fef79f","name":null,"isAnonymous":null}';
      socketIO.sendMessage("student.leave", jsonData, onReceiveChatMessage);
    } else {
      print('########## socketIO is null, sendStudentLeave');
    }
  }

  //void socketInfo(dynamic message) { updateLocation
  //  print("Socket Info: " + message);
  //}

  void onReceiveChatMessage(dynamic message) {
    print("########## Message from UFO: " + message);
    //print("########## onReceiveChatMessage: " + message);
  }

  //void  incrementCounter() {
  //setState(() {
  // This call to setState tells the Flutter framework that something has
  // changed in this State, which causes it to rerun the build method below
  // so that the display can reflect the updated values. If we changed(
  // _counter without calling setState(), then the build method would not be
  // called again, and so nothing would appear to happen.
  //counter++;
  //});
  //}

  void showToast(msg) {
    //sendChatMessage(mTextMessageController.text);
    sendChatMessage(msg);
  }

  bool isSocketNullable() => socketIO == null;
  String getSocket() => socketIO == null ? "Socket is Null": socketIO.toString();

}