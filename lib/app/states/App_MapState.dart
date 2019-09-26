import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:image/image.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'package:bus_tracker/app/utils/network_utils.dart';
import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

import 'package:bus_tracker/app/Socketio/socketIoManager.dart' as sockets;
import 'package:bus_tracker/app/requests/maps_requests.dart'  as MapRequest;

//import 'package:bus_tracker/app/states/App_NotificationState.dart'; // stop App_NotificationState 2019-08-23
//import 'package:provider/provider.dart';

//import 'dart:async';
//import 'dart:io';
//import 'dart:typed_data';
//import 'dart:ui';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bus_tracker/app/Notification/local_notications_helper.dart';
import 'package:bus_tracker/app/Notification/second_page.dart';
//import 'package:http/http.dart' as http;
//import 'package:path_provider/path_provider.dart';


class AppMapState with ChangeNotifier {
final notifications = FlutterLocalNotificationsPlugin();

  //AppNotificationState _appNotificationState; // stop App_NotificationState 2019-08-23

  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  //final Set<Marker> _markers = {};
  Map<PolylineId, Polyline> _polyLines = {};
  //GoogleMapController _mapController;
  //GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  //GoogleMapsServices get googleMapsServices => _googleMapsServices;
  Completer<GoogleMapController> get mapController => _controller;
  Completer<GoogleMapController> _controller = Completer();
  //Set<Marker> get markers => _markers;
  //Map<PolylineId, Polyline> get polyLines => _polyLines; // 
Set<Polyline> get polyLines {
  print(" AppMapState polyLines count: " +_polyLines.length.toString() );
  return Set<Polyline>.of(_polyLines.values); // 
} 

 Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

//Completer<GoogleMapController> _controller = Completer();
//var dialogTextMessageController = new TextEditingController();
final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
//Map<MarkerId, Marker> get markers => _markers; 
Set<Marker> get markers => Set<Marker>.of(_markers.values);
MarkerId selectedMarker, selectedPickupMarker;
MarkerId currentAppMarkerId = MarkerId("Current_App_id");
MarkerId trip_bus_markerId;
//bool isMyMarkerSet = false;
//  int _markerIdCounter = 1;

bool _dataChanged = true;
//bool set ddd => _dataChanged;
bool get dataChanged => _dataChanged;
//set doors(int numberOfDoors) {
static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(15.78025, 32.50743),
    zoom: 9.0,
  );
  Position currentApp_position;
  CameraPosition _position = _kInitialPosition;
  bool _isMapCreated = false;
  bool _isMoving = false;
  bool _compassEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  MapType _mapType = MapType.normal;
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = false;

bool _myLocationButtonEnabled = false;
 
  CameraPosition get initposition => _kInitialPosition;
  bool get isMapCreated => _isMapCreated;
  bool get isMoving => _isMoving;
  bool get compassEnabled => _compassEnabled;
  CameraTargetBounds get cameraTargetBounds => _cameraTargetBounds;
  MinMaxZoomPreference get minMaxZoomPreference => _minMaxZoomPreference;
  MapType get mapType => _mapType;
  bool get rotateGesturesEnabled => _rotateGesturesEnabled;
  bool get scrollGesturesEnabled => _scrollGesturesEnabled;
  bool get tiltGesturesEnabled => _tiltGesturesEnabled;
  bool get zoomGesturesEnabled => _zoomGesturesEnabled;
  bool get myLocationEnabled => _myLocationEnabled;
  bool get myLocationButtonEnabled => _myLocationButtonEnabled;

  String  userName, user_id, schoolid, schoolbid, token; 
  bool isParent ;
  int role_ID_Level;

  //Stream<int> clickStream;
 // First method
  StreamSubscription<int> clickSubscription;

  var currentTrip, scheduleTripList, studentslist;
  String _tripID = "", _schTripID= "";
  String get tripID => _tripID;
  void setTripID(String value){
    _tripID = value;
  }

 String get schTripID => _schTripID;
  void setSchTripID(String value){
    _schTripID = value;
  }

 BitmapDescriptor _markerIconStudnet, _markerIconSchool, _markerIconBus, _markerIconCurrentAppPosition, _markerIconStudentHome;
 void set_markerIconStudnet(BitmapDescriptor value) => _markerIconStudnet = value;
 void set_markerIconSchool(BitmapDescriptor value) => _markerIconSchool = value;
 void set_markerIconBus(BitmapDescriptor value) => _markerIconBus = value; 
 void set_markerIconCurrentAppPosition(BitmapDescriptor value) => _markerIconCurrentAppPosition = value;
 void set_markerIconStudentHome(BitmapDescriptor value) => _markerIconStudentHome = value;
BitmapDescriptor get markerIconStudnet => _markerIconStudnet;
BitmapDescriptor get markerIconSchool => _markerIconSchool;
BitmapDescriptor get markerIconBus => _markerIconBus;
BitmapDescriptor get markerIconCurrentAppPosition => _markerIconCurrentAppPosition;
BitmapDescriptor get markerIconStudentHome => _markerIconStudentHome;

GlobalKey<ScaffoldState> _scaffoldKey;// = new GlobalKey<ScaffoldState>();
void set_scaffoldKey(GlobalKey<ScaffoldState> value) => _scaffoldKey = value;

bool currentAppLocationlistener = false;
BuildContext context;

 List<String> _advertisementList = new List<String>();
 int _advetiseIndex = 0;
 String getAdvertisementData(){  
  if(_advertisementList.length == 0) return "";
  if(_advetiseIndex != _advertisementList.length){    
    return _advertisementList[_advetiseIndex++];
  }else {    
    _advetiseIndex =0;
    return _advertisementList[_advetiseIndex++];
  }
}
bool isAdvertisement(){  
  if(_advertisementList.length == 0) fetchAdvertiseData();
  return _advertisementList.length != 0;
}

@override
  void dispose() {
    super.dispose();
    if(clickSubscription != null)
     clickSubscription.cancel();
  }

  AppMapState() {     
    //fetchTripData(); 
    ////_getUserLocation();
    //initUserLocation();
    ////_initPlatformState(); // get current GPS position.     
    print("999999999999999999999 AppMapState() ");

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

/*
    // 'Show notification'
    showOngoingNotification(notifications, title: 'Tite', body: 'Body');
    // 'Replace notification'
    showOngoingNotification(notifications, title: 'ReplacedTitle', body: 'ReplacedBody');
    // 'Other notification'
    showOngoingNotification(notifications, title: 'OtherTitle', body: 'OtherBody', id: 20);
    /// 'Silent notification'
    showSilentNotification(notifications,  title: 'SilentTitle', body: 'SilentBody', id: 30);
    //'Cancel all notification' notifications.cancelAll
*/
  }


 Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondPage(payload: payload)),
      );

bool _isLoadData = true;
void resetParameters(){
  _isLoadData = true;

}

void loadData(){
  print("999999999999999999999 loadData() ");
 fetchTripData();
  initStreamLocation();       
  
}

//bool _issetInitValues = false;
void setInitValues(String _username, String _user_id, String _schoolid, String _schoolbid, String _token, bool _isParent, int _role_ID_Level)  {
  /*if(_issetInitValues == false){
    _issetInitValues = true;
  }else {
    return ;
  }*/

  userName = _username; user_id = _user_id; schoolid = _schoolid; schoolbid = _schoolbid; token = _token;
  isParent = _isParent; role_ID_Level = _role_ID_Level;
  print("999999999999999999999 setInitValues ");
 
  /*print("999999999999999999999 call fetchTripData user_id: " + user_id ?? "null" );
  print("999999999999999999999 call fetchTripData role_ID_Level.toString(): " + role_ID_Level.toString() );
  print("999999999999999999999 call fetchTripData schoolid: " + schoolid );
  print("999999999999999999999 call fetchTripData schoolbid: " + schoolbid ?? "is null" );
  print("999999999999999999999 call fetchTripData token: " + token );
  */

  /*if(context != null){
    _appNotificationState = Provider.of<AppNotificationState>(context);
    _appNotificationState.showNotification();
  }*/

}

// ! TO GET THE USERS LOCATION
  void _getUserLocation() async {
    
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print("###########  Position:" + position.toString());
      try{
        List<Placemark> placemark = await Geolocator()
            .placemarkFromCoordinates(position.latitude, position.longitude);
            locationController.text = placemark[0].name;
      }catch(e){ print("Err :" + e.toString());
      //TODO: if error like this: Err:PlatformException(ERROR_GEOCODING_COORDINATES, grpc failed, null),
      // then use proxy, becuase your country not allow to use google
      }

    _initialPosition = LatLng(position.latitude, position.longitude);
    print("initial position is : ${_initialPosition.toString()}");
    
    
    notifyListeners();
  }

 initStreamLocation() {
    
    //TODO: Add iOS code
    /*try { 
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
    
    } on PlatformException {    
      print("********* PlatformException:")  ;
    }*/
      if(currentAppLocationlistener == true) return;
      if(role_ID_Level != 3 && role_ID_Level != 4)  return;
      if(tripID == null || tripID == "") return;

      const LocationOptions locationOptions =
          LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);
      final Stream<Position> positionStream =
          Geolocator().getPositionStream(locationOptions);
          positionStream.listen(
         (Position position) {  
           currentAppLocationlistener = true;
           if(tripID == null || tripID == "") return;
           //TODO: Update App location, send it to server.
            //_markers   
            if(role_ID_Level == 3){
              
                if(trip_bus_markerId != null && _markers.containsKey(trip_bus_markerId)){
                    print("999999999999999999999 trip Bus updateLocation...: " + position.toString());
                    sockets.SocketIOClass().sendTripUpdateLocation(position);
                    _changePosition(trip_bus_markerId, position.latitude, position.longitude);
                } else{                    
                      addTripBus(tripID, position.latitude, position.longitude);
                    
                }
                getDistanceForNextStudent(position);
                getSpeed(position);
            } else {

              /*if(_markers.containsKey(currentAppMarkerId)){                  
                  _changePosition(currentAppMarkerId, position.latitude, position.longitude);
              }else {
                  updateCurrentMarker(position, "Me", null); 
              }*/
            }

               
          }
          ); 
 
  }

//////////////////////  Current position  ////////////////////////

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } on PlatformException {
      position = null;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) {
    //  return;
    //}
      //updateCurrentMarker(position, "Me", null);
   
  }

  ///////////////////////////////////////////////////////////////////
  ///
  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
  /*  _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black));
    notifyListeners();*/
  }

void addPolyLine(PolylineId polylineId, List<LatLng> _points){
  _polyLines[polylineId] = Polyline(
        polylineId: polylineId,
        width: 5,
        points:_points,
        color: Colors.blueAccent);
        notifyListeners();
}

  void updateTripRoute(tripRoute){
    try{
      List<LatLng> points = new List<LatLng>();
      for(int i=0;i< tripRoute['OSM_Route'].length ; i++){
        points.addAll(tripRoute['OSM_Route'][i]['coordinates']);
      }
      PolylineId line = new  PolylineId(tripRoute['SchTrip_ID']);
      if( _polyLines.containsKey(line)){
        Polyline newRoute = _polyLines[line].copyWith(pointsParam: points);
          _polyLines[line] = newRoute;
          notifyListeners();
      }else {
        addPolyLine(line, points);
      }           
      //TODO: why used?? _updateStudentsMarker(tripRoute);
      
    }catch(e){print("############# updateTripRoute:"+ e.toString());}
  }

  void updateRoute(String encondedPoly) {
   /* _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black));
    notifyListeners();*/
  }

    // ! Update A Students MARKER ON THE MAO
  void _updateStudentsMarker(tripRoute) {
    for(int i=0;i< tripRoute['OSM_Route'].length ; i++){        
          try{
            String markerKey = 'student_id_${tripRoute['OSM_Route']["Student_ID"]}';
            if(!_markers.containsKey(markerKey)) continue;
            MarkerId markerId = MarkerId(markerKey);
           _markers[markerId] = _markers[markerId].copyWith(infoWindowParam:  InfoWindow(title: tripRoute['OSM_Route'][i]["Student_Name"] ));            
            } catch(e) {print("********** studentslist for err: " + e.toString());}
        } 
    notifyListeners();
  }

  // ! ADD A MARKER ON THE MAO
  void _addMarker(LatLng location, String address) {
    /*_markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));*/
    notifyListeners();
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // ! SEND REQUEST
  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation); // TODO: error google services, change to openstreat
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    //String route = await _googleMapsServices.getRouteCoordinates( 
    //    _initialPosition, destination); // TODO: error google services [need money], change to openstreat
    //createRoute(route);
    notifyListeners();
  }

  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _controller.complete(controller); 
    print("*********** onMapCreated..");         
    notifyListeners();
  }

void updateCameraPosition(CameraPosition position) { 
      _position = position;
      if(_myLocationButtonEnabled){_changePosition(selectedPickupMarker, position.target.latitude, position.target.longitude);}
      notifyListeners();
  }

  void remove(MarkerId markerId) {    
      if (_markers.containsKey(markerId)) {
        _markers.remove(markerId);
        notifyListeners();
      }  
  }

  void _changePosition(MarkerId markerId, double latitude, double longitude) {
    final Marker marker = _markers[markerId];  
    if(marker != null)           
      _markers[markerId] = marker.copyWith(
        positionParam: LatLng(
          latitude,
          longitude,
        ),
      );
      notifyListeners();
  }

void select_StudentMarker(String student_ID){
  selectedPickupMarker = new MarkerId('student_id_${student_ID}');
  _myLocationButtonEnabled = true;  
  onMarkerTapped(new MarkerId('student_id_${student_ID}'));
  notifyListeners();
}

void save_StudentMarker(){
  if(selectedPickupMarker != null && _markers.containsKey(selectedPickupMarker)){
  _myLocationButtonEnabled = false;  
  Marker student = _markers[selectedPickupMarker];
  print("999999999999999999999 save_StudentMarker");
  sockets.SocketIOClass().sendStudentPickupChange(student.markerId.value.replaceAll("student_id_", ""), student.position.latitude, student.position.longitude, tripID, schTripID);
  if(role_ID_Level == 3) getTripRoute(tripID, studentslist);
  notifyListeners();
  }
}

Map<MarkerId, Marker> _createMarkers()
{     
     //_markers.clear();
     
     if(studentslist != null)
     {
     print("999999999999999999999 _createMarkers studentslist count: " + studentslist.length.toString());  
       //print("********** studentslist *************");
       //print("********* :: " + studentslist[0]["Student_ID"].toString());
       //print(studentslist.toString());
       List<LatLng> _points = new List<LatLng>();
       //TODO: Add Student marker.
        for(int i=0;i<studentslist.length;i++)
        {
          try{
            String markerKey = 'student_id_${(isParent == true) ? studentslist[i]["_id"] : studentslist[i]["Student_ID"]["_id"]}';
            if(_markers.containsKey(markerKey)) continue;

            MarkerId markerId = MarkerId(markerKey);
            Marker student = Marker( // 'marker_id_$_markerIdCounter'
              markerId: markerId, // ID
              position: LatLng(double.parse((isParent == true) ? studentslist[i]["Latitude"].toString(): studentslist[i]["Student_ID"]["Latitude"].toString()), 
                        double.parse((isParent == true) ? studentslist[i]["Longitude"].toString() : studentslist[i]["Student_ID"]["Longitude"].toString())),
              infoWindow: InfoWindow(title: (isParent == true) ? studentslist[i]["Student_Name_ar"] : studentslist[i]["Student_ID"]["Student_Name_ar"]),
              //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
              icon: _markerIconStudnet != null ? _markerIconStudnet : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
              onTap: () {
                onMarkerTapped(markerId);
              },
              draggable: true,              

            );
            //print("*********** markers student length1: " + markers.length.toString());
            _markers[student.markerId] = student;
            _points.add(student.position);
            //print("*********** markers student length: " + markers.length.toString());
            //print("***** Student : " + studentslist[i]["Student_ID"]["Latitude"].toString() + " , " + studentslist[i]["Student_ID"]["Longitude"].toString());
            } catch(e) {print("********** studentslist for err: " + e.toString());}
        }      
      PolylineId polylineId = PolylineId("Trip_ID_Polyline_" + scheduleTripList['_id'].toString());
      addPolyLine(polylineId, _points);

     } else {
       print("999999999999999999999 _createMarkers studentslist is null...");
     }

     if(scheduleTripList != null && scheduleTripList["School_ID"] != null) {

try{
        //print("********** scheduleTripList *************");
       //print(scheduleTripList.toString());

    //TODO: Add School marker, School Branch marker.
    String markerKey = 'school_id_${scheduleTripList["School_ID"]["_id"]}';
    if(!_markers.containsKey(markerKey)) {
        MarkerId markerId = MarkerId(markerKey);
        //MarkerId markerId = MarkerId('school_id_11');
        //print("scheduleTripList markerId:"+ markerId.toString());
        Marker school = new Marker(
          markerId: markerId, // ID
          position: LatLng(double.parse(scheduleTripList["School_ID"]["Latitude"].toString()), double.parse(scheduleTripList["School_ID"]["Longitude"].toString())),
          infoWindow: InfoWindow(title: scheduleTripList["School_ID"]["SC_Name_ar"]),
          //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,) ,
          //icon: BitmapDescriptor.fromAsset('lib/app/assets/Schedule/school_icon34x53.png'),          
          icon: _markerIconSchool != null ? _markerIconSchool : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,) ,
           onTap: ()  {
            onMarkerTapped(markerId);
          },
          draggable: true,
        );
        //print("scheduleTripList school:"+ school.position.toString());
        _markers[school.markerId] = school;
        //print("scheduleTripList markers length:"+ markers.length.toString());
    }
} catch(e) {print("********** School_ID err: " + e.toString());}

try{
    if(scheduleTripList["School_Br_ID"] != null){
       String markerKey = 'school_Br_id_${scheduleTripList["School_Br_ID"]["_id"]}';
        if(!_markers.containsKey(markerKey)) {
          MarkerId markerId = MarkerId(markerKey);
          Marker schoolBranch = Marker(
            markerId: markerId, // ID
            position: LatLng(double.parse(scheduleTripList["School_Br_ID"]["Latitude"]), double.parse(scheduleTripList["School_Br_ID"]["Longitude"])),
            infoWindow: InfoWindow(title: scheduleTripList["School_Br_ID"]["Br_Name"]),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
            //icon: BitmapDescriptor.fromAsset('lib/app/assets/Schedule/school_icon34x53.png'),
            icon: _markerIconSchool != null ? _markerIconSchool : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,) ,
            onTap: () {
              onMarkerTapped(markerId);
            },
            draggable: true,
          );        
          _markers[schoolBranch.markerId] = schoolBranch;
      }
    }
} catch(e) {print("********** School_Br_ID err: " + e.toString());}

        try{
    //TODO: Add Bus Marker.
    /*String markerKey = 'bus_id_${scheduleTripList["Bus_ID"]["_id"]}';
      if(!markers.containsKey(markerKey)) {
        if(scheduleTripList["Bus_ID"] != null){
            MarkerId markerId = MarkerId(markerKey);
            Marker bus = Marker(
              markerId: markerId, // ID
              position: LatLng(double.parse(scheduleTripList["Bus_ID"]["Latitude"]), double.parse(scheduleTripList["Bus_ID"]["Longitude"])),
              infoWindow: InfoWindow(title: scheduleTripList["Bus_ID"]["Dr_Name_ar"]),
              //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
              //icon: BitmapDescriptor.fromAsset('lib/app/assets/bus/school-bus-icon-9.png'),
              icon: _markerIconBus != null ? _markerIconBus : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,) ,
              onTap: () {
                _onMarkerTapped(markerId);
              },
              draggable: true,  
            );        
            markers[bus.markerId] = bus;
      }
    }*/
        } catch(e) {print("********** Bus err: " + e.toString());}

     
  } // end if scheduleTripList  
  
      //TODO: Add Trip Bus Marker.
      //if(widget.role_ID_Level == 3 || widget.role_ID_Level == 4)
      //      addTripBus();
      
     //TODO: Add Supervisors and drivers

//print("*********** markers ***************");
//print("*********** markers length: " + markers.length.toString());
//print("*********** markers: " + markers.values.toList().toString());
  notifyListeners();
     //return _markers ;
}

void addTripBus(String tripID, double lat, double long)
{
    try{
    //TODO: Add Trip Bus Marker.
    
      String markerKey = 'Trip_ID_$tripID';
      if(!_markers.containsKey(markerKey)) {
          trip_bus_markerId = MarkerId(markerKey);
          Marker trip_bus_marker = Marker(
            markerId: trip_bus_markerId, // ID
            position: LatLng(lat, long),
            infoWindow: InfoWindow(title: "School Bus"),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
            //icon: BitmapDescriptor.fromAsset('lib/app/assets/bus/school-bus-icon-9.png'),
            icon: _markerIconBus != null ? _markerIconBus : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
            onTap: () {
              onMarkerTapped(trip_bus_markerId);
            },
            draggable: true,  
          );        
          _markers[trip_bus_markerId] = trip_bus_marker;
            notifyListeners();
      }
    
        } catch(e) {print("********** trip bus marker err: " + e.toString());}
}

void updateCurrentMarker(Position position, String name)
{  
    Marker currentAppMarker = _markers[currentAppMarkerId];
    if (currentAppMarker == null) {        
              currentAppMarker = Marker(
              markerId: currentAppMarkerId, // ID
              position: LatLng(position.latitude, position.longitude),
              //infoWindow: InfoWindow(title: "it is me"), //TODO: change to current own app name.
              infoWindow: InfoWindow(title: name), 
              //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,), 
              //BitmapDescriptor.defaultMarker,
              // or BitmapDescriptor.fromAsset('assets/asset_name.png')
              icon: _markerIconCurrentAppPosition != null ? _markerIconCurrentAppPosition : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
              onTap: () {
                onMarkerTapped(currentAppMarkerId);
              },
              draggable: true,  
            );     
             _markers[currentAppMarkerId] = currentAppMarker; print("******** new Marker..");;            
             notifyListeners();
        }
        else
        {
          _changePosition(currentAppMarkerId, position.latitude, position.longitude);
        }  
        
}

  Marker nullMarker(){
    return new Marker(markerId: new MarkerId(DateTime.now().toString()), position: LatLng(15.36, 32.45));
  }


 void onMarkerTapped(MarkerId markerId) {
     final Marker tappedMarker = _markers[markerId];
    if (tappedMarker != null) {      
        if (_markers.containsKey(selectedMarker)) {
          final Marker resetOld = _markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          _markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        _markers[markerId] = newMarker;    
          notifyListeners();
    }
  }

void setDefaultMarkerSymbol(MarkerId markerId){ 
 if (_markers.containsKey(markerId)) {
          final Marker resetOld = _markers[markerId]
              .copyWith(iconParam: _markerIconStudnet != null ? _markerIconStudnet : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),);
          _markers[markerId] = resetOld;
          notifyListeners();
        }
}

void getMarker(MarkerId markerId) {
     final Marker marker = _markers[markerId];
    if (marker != null) {      
        if (_markers.containsKey(selectedMarker)) {
          final Marker resetOld = _markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          _markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = marker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        _markers[markerId] = newMarker;
       notifyListeners();
    }
  }

 fetchTripData() async{
print("999999999999999999999 call fetchTripData ");
    String _url = "";
    if(role_ID_Level.toString() == "5")
        _url = "/Students/list";
      else
        _url = "/ScheduleTrip/TodayTrip";
  /*print("999999999999999999999 call fetchTripData user_id: " + user_id.toString() ?? "null" );
  print("999999999999999999999 call fetchTripData role_ID_Level.toString(): " + role_ID_Level.toString() );
  print("999999999999999999999 call fetchTripData schoolid: " + schoolid.toString()  );
  print("999999999999999999999 call fetchTripData schoolbid: " + schoolbid.toString()  );
  print("999999999999999999999 call fetchTripData token: " + token.toString()  );
  print("999999999999999999999 call fetchTripData _url: " + _url.toString()  );
  */


        var responseJson = await NetworkUtils.fetchTrip(user_id, role_ID_Level.toString(), schoolid, schoolbid, token ,"Guardians_ID", true ,_url);
      
          // get TRip from Trip schedule by _id, today, if there record then loadcurrentTrip, else loadCreateNewTrip

          //print("Login Page Line 70, responseJson: " + responseJson);

          print("######### mapList responseJson: " + responseJson.toString());
          
          print("new mapList");
          
          if(responseJson == "" || responseJson == null) {
            print("SnackBar3 App_MapState.dart fetchTripData mapList");
            //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());           
          } else if(responseJson == 'NetworkError') {
            print("SnackBar4 App_MapState.dart fetchTripData mapList");
            //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());         
          } //else if(responseJson['errors'] != null) {
            else if(responseJson['success'] == false) {
            print("SnackBar5 App_MapState.dart fetchTripData mapList");
            //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());            
          }  else if(responseJson['scheduleTrip'] != null) {
            print("SnackBar6 App_MapState.dart fetchTripData mapList");
            //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.today_Schedule_Trip());
            //TODO: save TripId, and add to SocketIO.
            _tripID = responseJson['scheduleTrip'][0]["Trip_ID"]["_id"];
            _schTripID = responseJson['scheduleTrip'][0]["_id"];

              currentTrip = responseJson;          
            
                print("SnackBar8 App_MapState.dart fetchTripData mapList");
                //print("currentTrip['scheduleTrip'] != null" );
              scheduleTripList = currentTrip['scheduleTrip'][0];
                studentslist = scheduleTripList['WaypointList'];
                //_isThereTrip = true;
                //_isLoading = true;
                _createMarkers();
                print("new mapList4");
                notifyListeners();
              await saveTripId(tripID); // stop 10-05-2019
              }
              else if(currentTrip != null && currentTrip['scheduletrip'] != null)
              {  
               
                //print("currentTrip['scheduletrip'] != null" );
                print("SnackBar9 App_MapState.dart fetchTripData mapList");
                scheduleTripList = currentTrip['scheduletrip'];  
                studentslist = scheduleTripList['WaypointList'];
                //_isThereTrip = true;
                //_isLoading = true;
                _createMarkers();
                  notifyListeners();
            
          }
          else if(responseJson['trip'] != null) {
            print("SnackBar7 App_MapState.dart fetchTripData mapList");
            //NetworkUtils.showSnackBar(_scaffoldKey,TranslateStrings.there_is_no_Schedule_Trip_Today_Select_New_Trip() );
            //TODO: Clear TripId, SocketIO
            _tripID = "";
            await clearTripId();  // stop 10-05-2019            
              currentTrip = responseJson;          
                //_isThereTrip = false;        
              notifyListeners();        
          }
          else  if(responseJson['students'] != null) {            
              studentslist = responseJson['students'];
                notifyListeners();  
          } 
            else {            
            //List list = List();
            //list = responseJson as List;
            print("SnackBar8 App_MapState.dart fetchTripData mapList");
            //print("responseJson:");
            //print(list[0].toString());
          //_hideLoading();
          //  return responseJson;
          }

    }

 fetchAdvertiseData() async{
print("999999999999999999999 call fetchAdvertiseData ");

        var responseJson = await NetworkUtils.fetchAdvertisementData('/Advertisements/upload');
      
          // get TRip from Trip schedule by _id, today, if there record then loadcurrentTrip, else loadCreateNewTrip

          //print("Login Page Line 70, responseJson: " + responseJson);

          print("######### fetchAdvertiseData responseJson: " + responseJson.toString());          
   
          
          if(responseJson == "" || responseJson == null) {
            print("SnackBar3 App_MapState.dart fetchAdvertiseData");
            //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());           
          } else if(responseJson == 'NetworkError') {
            print("SnackBar4 App_MapState.dart fetchAdvertiseData");
            //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());         
          } //else if(responseJson['errors'] != null) {
            else if(responseJson['success'] == false) {
            print("SnackBar5 App_MapState.dart fetchAdvertiseData");
            //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());            
          }  else if(responseJson['success'] == true) {
            print("SnackBar6 App_MapState.dart fetchAdvertiseData");
            //NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.today_Schedule_Trip());              
                print("SnackBar8 App_MapState.dart fetchAdvertiseData");
                responseJson['filenames'].forEach((element) => _advertisementList.add( NetworkUtils.developmentHost +  '/uploads/' + element));          
                _advertisementList.forEach((f) => print(f));
                notifyListeners();              
              }                       
                else {                  
                  print("SnackBar8 App_MapState.dart fetchAdvertiseData");            
              }

    }

    Future saveTripId(String tripId) async {
	    _sharedPreferences = await _prefs;		  
		  _sharedPreferences.setString(AuthUtils.tripIDKey, tripId);
      //await sockets.SocketIOClass.setTripId(tripId);
      print("999999999999999999999 saveTripId at App_MapState");
      await sockets.SocketIOClass().setTripId(tripId);
      print("############# saveTripId: at homepage" + tripId);
        notifyListeners();
}

Future clearTripId() async {
	_sharedPreferences = await _prefs;		  
		  _sharedPreferences.setString(AuthUtils.tripIDKey, "");
      //await sockets.SocketIOClass.clearTripId();
      print("999999999999999999999 clearTripId");
      await sockets.SocketIOClass().clearTripId();
        notifyListeners();
}

void receiveSocketIO_Data(){
  print("999999999999999999999 receiveSocketIO_Data");
  sockets.SocketIOClass().trip_Rec_updateLocationStreamController.stream.listen(
     (dynamic tripLocation) {  
      if(role_ID_Level != 3) {
        //addTripBus(tripLocation.Trip_ID,  tripLocation.latitude, tripLocation.longitude);
        _changePosition(tripLocation.Trip_ID,  tripLocation.latitude, tripLocation.longitude);
      }
     }  
  );
  
  // stop App_NotificationState 2019-08-23

  
  sockets.SocketIOClass().onRec_student_absentStreamController.stream.listen((dynamic value) {print("999999999999999999999 onRec_student_absentStreamController "); reLoadData(); if(role_ID_Level == 3) getTripRoute(tripID, studentslist); showOngoingNotification(notifications, title: 'OtherTitle', body: 'onRec_student_absentStreamController', id: 20);});
  sockets.SocketIOClass().onRec_student_AttendanceStreamController.stream.listen((dynamic value) {print("999999999999999999999 onRec_student_AttendanceStreamController "); reLoadData();  getETA_Distance(value); showOngoingNotification(notifications, title: 'OtherTitle', body: 'onRec_student_AttendanceStreamController', id: 20);});
  sockets.SocketIOClass().onRec_student_leaveStreamController.stream.listen((dynamic value) { print("999999999999999999999 onRec_student_leaveStreamController ");reLoadData(); showOngoingNotification(notifications, title: 'OtherTitle', body: 'onRec_student_leaveStreamController', id: 20);});
  sockets.SocketIOClass().onRec_student_pick_upStreamController.stream.listen((dynamic value) { print("999999999999999999999 onRec_student_pick_upStreamController ");reLoadData(); if(role_ID_Level == 3) getTripRoute(tripID, studentslist); showOngoingNotification(notifications, title: 'OtherTitle', body: 'onRec_student_pick_upStreamController', id: 20);});  
  sockets.SocketIOClass().onSchoolRec_updateLocationStreamController.stream.listen((dynamic value) {print("999999999999999999999 onSchoolRec_updateLocationStreamController "); reLoadData();showOngoingNotification(notifications, title: 'OtherTitle', body: 'onSchoolRec_updateLocationStreamController', id: 20); });
  sockets.SocketIOClass().onRec_BusTrip_update_OSM_RouteStreamController.stream.listen((dynamic tripRoute) { print("999999999999999999999 onRec_BusTrip_update_OSM_RouteStreamController "); updateTripRoute(tripRoute);  showOngoingNotification(notifications, title: 'OtherTitle', body: 'onRec_BusTrip_update_OSM_RouteStreamController', id: 20);});

  sockets.SocketIOClass().onRec_bus_speed_alertStreamController.stream.listen((dynamic value) { print("999999999999999999999 onRec_bus_speed_alertStreamController "); raiseSpeedAlertNotice(value); showOngoingNotification(notifications, title: 'OtherTitle', body: 'onRec_bus_speed_alertStreamController', id: 20);});

  sockets.SocketIOClass().onRec_advertiseStreamController.stream.listen((dynamic trip) {  print("999999999999999999999 onRec_advertiseStreamController "); showOngoingNotification(notifications, title: 'OtherTitle', body: 'onRec_advertiseStreamController', id: 20);});
  
  sockets.SocketIOClass().onRec_Trip_noteStreamController.stream.listen((dynamic value) { print("999999999999999999999 onRec_Trip_noteStreamController "); showOngoingNotification(notifications, title: 'OtherTitle', body: 'onRec_Trip_noteStreamController', id: 20);});
  sockets.SocketIOClass().onRec_zoon_alertStreamController.stream.listen((dynamic value) { print("999999999999999999999 onRec_zoon_alertStreamController "); showOngoingNotification(notifications, title: 'OtherTitle', body: 'onRec_zoon_alertStreamController', id: 20); });
  sockets.SocketIOClass().onRec_zoonStreamController.stream.listen((dynamic value) { print("999999999999999999999 onRec_zoonStreamController "); showOngoingNotification(notifications, title: 'OtherTitle', body: 'onRec_zoonStreamController', id: 20); });  
  sockets.SocketIOClass().onUserRec_notificationStreamController.stream.listen((dynamic value) {  print("999999999999999999999 onUserRec_notificationStreamController "); showOngoingNotification(notifications, title: 'OtherTitle', body: 'onUserRec_notificationStreamController', id: 20);});
  

/*
  sockets.SocketIOClass().onRec_student_absentStreamController.stream.listen((dynamic value) {print("999999999999999999999 onRec_student_absentStreamController "); reLoadData(); if(role_ID_Level == 3) getTripRoute(tripID, studentslist);});
  sockets.SocketIOClass().onRec_student_AttendanceStreamController.stream.listen((dynamic value) {print("999999999999999999999 onRec_student_AttendanceStreamController "); reLoadData();  getETA_Distance(value);});
  sockets.SocketIOClass().onRec_student_leaveStreamController.stream.listen((dynamic value) { print("999999999999999999999 onRec_student_leaveStreamController ");reLoadData(); });
  sockets.SocketIOClass().onRec_student_pick_upStreamController.stream.listen((dynamic value) { print("999999999999999999999 onRec_student_pick_upStreamController ");reLoadData(); if(role_ID_Level == 3) getTripRoute(tripID, studentslist);});  
  sockets.SocketIOClass().onSchoolRec_updateLocationStreamController.stream.listen((dynamic value) {print("999999999999999999999 onSchoolRec_updateLocationStreamController "); reLoadData(); });
  sockets.SocketIOClass().onRec_BusTrip_update_OSM_RouteStreamController.stream.listen((dynamic tripRoute) { updateTripRoute(tripRoute); });

  sockets.SocketIOClass().onRec_bus_speed_alertStreamController.stream.listen((dynamic value) { raiseSpeedAlertNotice(value); });

  sockets.SocketIOClass().onRec_advertiseStreamController.stream.listen((dynamic trip) {  });
  
  sockets.SocketIOClass().onRec_Trip_noteStreamController.stream.listen((dynamic value) { });
  sockets.SocketIOClass().onRec_zoon_alertStreamController.stream.listen((dynamic value) { });
  sockets.SocketIOClass().onRec_zoonStreamController.stream.listen((dynamic value) {  });  
  sockets.SocketIOClass().onUserRec_notificationStreamController.stream.listen((dynamic value) { });
*/

}

void reLoadData(){
  print("999999999999999999999 reLoadData ");
  fetchTripData();
  initStreamLocation();       
  _createMarkers(); 
}

MapRequest.OSMServices osm = new MapRequest.OSMServices();

List<dynamic> tripRoute = null;
void getTripRoute(String schTripID, List studentslist) async{
  if(schTripID == null || studentslist == null) return;
  tripRoute = new List();  
for(int i =1;i<studentslist.length; i++) {  
  if(studentslist[i]['Student_ID'] == null||
  studentslist[i-1]['Student_ID']['latitude'] == null || studentslist[i-1]['Student_ID']['longitude'] ||
  studentslist[i]['Student_ID']['latitude'] == null || studentslist[i]['Student_ID']['longitude']
  ) continue;
  //if(double.parse(studentslist[i]['Student_ID']['latitude']) == 15.0  || double.parse(studentslist[i]['Student_ID']['longitude']) == 15.0) continue;
  LatLng p1 = new LatLng(double.parse(studentslist[i-1]['Student_ID']['latitude']),double.parse(studentslist[i-1]['Student_ID']['longitude']));
  LatLng p2 = new LatLng(double.parse(studentslist[i]['Student_ID']['latitude']),double.parse(studentslist[i]['Student_ID']['longitude']));
    var route = await osm.getRoute(p1, p2, MapRequest.OSMServices.CAR);
    //TODO: Calc: heading, speedAccuracy, altitude, accuracy
    double speed = double.tryParse(route['distance']) == 0 || double.tryParse(route['traveltime'])  == 0 ? 0: double.tryParse(route['distance']) / (double.tryParse(route['traveltime']) / 3600.0) ;
    Map routeMap = {"type": route['type'], "coordinates": route['coordinates'], "distance": route['distance'], "description": route['description'], "traveltime": route['traveltime'], "speed": speed, 
    "Student_ID": studentslist[i]['Student_ID']['_id'], "Student_Name": (isParent == true) ? studentslist[i]["Student_Name_ar"] : studentslist[i]["Student_ID"]["Student_Name_ar"]};
  tripRoute.add(routeMap);
}
print("999999999999999999999 getTripRoute");
//TODO: Save Route by Sch_ID.
sockets.SocketIOClass().sendTripRoute(schTripID, tripRoute);
} 

var current_Student_rec;
DateTime current_student_time;
double current_Student_Distance;
void getETA_Distance(var student_rec) {  
    if(student_rec != null)
    {
      //TODO: Change Current Student Symbol or Color in Map. 
      setDefaultMarkerSymbol(new MarkerId('student_id_${student_rec['student_ID']}'));
      if(role_ID_Level ==3){
        current_Student_rec = student_rec;       
        current_student_time = DateTime.now();   
      }
      //TODO: Change Current Student Symbol or Color in Map. 
      onMarkerTapped(new MarkerId('student_id_${current_Student_rec['student_ID']}'));
    }else {
      current_Student_rec = null;
    }
}

void getDistanceForNextStudent(Position newLocation) async{  
    if(current_Student_rec == null) return;
    if(role_ID_Level ==3){
      if(DateTime.now().difference(current_student_time).inSeconds < 60) return;
        current_student_time = DateTime.now(); 
        LatLng p1 = new LatLng(newLocation.latitude,newLocation.longitude);
        LatLng p2 = new LatLng(current_Student_rec['latitude'],current_Student_rec['longitude']);
        var route = await osm.getRoute(p1, p2, MapRequest.OSMServices.CAR); 
        double dis =  double.tryParse(route['properties']['distance']);
        print("999999999999999999999 getDistanceForNextStudent");
        if(current_Student_Distance - dis> 0.5) // 0.5 => 500 meter, then send.
          sockets.SocketIOClass().sendMultiplenotification(current_Student_rec['Guardians_ID'] , TranslateStrings.busDistanceLeft() + current_Student_Distance.toString() , 'direct');
    }
}

void sendStudentAttendance(String tripID, String waypointListID, String student_ID){ 
  print("999999999999999999999 sendStudentAttendance");
  sockets.SocketIOClass().sendStudentAttendance(tripID, waypointListID, student_ID);
}

Position currentLocation;
void getSpeed(Position newLocation) async{ 
  print("########### getSpeed newLocation.timestamp: " + newLocation.timestamp.toString());
  if(currentLocation == null)  {
    currentLocation = newLocation;
    return;
  }  
  double distanceInMeters = await Geolocator().distanceBetween(currentLocation.latitude, currentLocation.longitude, 
                                newLocation.latitude, newLocation.longitude) / 1000.0; // to km
  double time = double.parse(newLocation.timestamp.difference(currentLocation.timestamp).inSeconds.toString()) / 3600.0; // to hour
  double speed = distanceInMeters / time; // speed in km/h
  print("999999999999999999999 getSpeed");
  if(speed> 60) 
    sockets.SocketIOClass().sendBusSpeedAlert(tripID, newLocation.timestamp, newLocation.latitude, newLocation.longitude, speed);
    current_Student_rec = newLocation;
}

void raiseSpeedAlertNotice(dynamic value){
 //TODO: alert notification with data:  
 // "Trip_ID" : ${tripID}, "Date" : ${timestamp},"Latitude" : ${latitude},"Longitude" : ${longitude},"Speed" : ${speed},
 
}

void sendStudentAbsent(String student_ID, String absent_ID){
  print("999999999999999999999 sendStudentAbsent");
  sockets.SocketIOClass().sendStudentAbsent(student_ID, absent_ID);
}

void trip_Finished(){
  //List<dynamic> students_List = new List();  
  String students_List = "";
  for(int i =1;i<studentslist.length; i++) {  
    if(studentslist[i]['Student_ID'] == null) continue;  
    //students_List.add(studentslist[i]['Student_ID']['_id']);
    students_List +=  (students_List != ""? ',' + studentslist[i]['Student_ID']['_id']: studentslist[i]['Student_ID']['_id']);
  }  
  print("999999999999999999999 trip_Finished Send Students ID");
  print("999999999999999999999 " + students_List.toString());
  if(_schTripID != "")
    sockets.SocketIOClass().sendStudents_TripFinish(_schTripID, students_List);
  studentslist = null;  
  notifyListeners();
}

}
