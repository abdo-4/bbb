import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/components/PhoneCall.dart';
//import '../socketio/socketIoManager.dart' as sockets; 
import 'package:bus_tracker/app/components/Notification.dart';
import 'package:geolocator/geolocator.dart';
//import '../geolocator/pages/location_stream_class.dart' as geoLocation;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
//import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

class MapStudentList extends StatefulWidget{
  final name, user_id, schoolid, schoolbid, token; 
  final bool isParent ;
  final int role_ID_Level;
  MapStudentList(this.name, this.isParent, this.user_id, this.role_ID_Level, this.schoolid, this.schoolbid, this.token);

    @override 
    HomePageState createState() { 
      //print("**************** MapStudentList ****************");   
         //print("********** scheduleTripList:" + scheduleTripList.toString());
         //print("********** studentslist:" + studentslist.toString());
         
      return new HomePageState();
    }
}

class HomePageState extends State<MapStudentList>{

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
Completer<GoogleMapController> _controller = Completer();
//var dialogTextMessageController = new TextEditingController();
Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
MarkerId selectedMarker;
MarkerId currentAppMarkerId = MarkerId("Current_App_id");
MarkerId trip_bus_markerId;
//bool isMyMarkerSet = false;
//  int _markerIdCounter = 1;

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

  BitmapDescriptor _markerIconStudnet;
  BitmapDescriptor _markerIconBus;
  BitmapDescriptor _markerIconSchool;
  BitmapDescriptor _markerIconStudentHome;
  BitmapDescriptor _markerIconCurrentAppPosition;

  //Stream<int> clickStream;
 // First method
  StreamSubscription<int> clickSubscription;

  var currentTrip, scheduleTripList, studentslist;
  String tripID;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  @override
  void initState(){
    super.initState();
    print("############# initState fetchTripData..");
    fetchTripData();
    _initPlatformState(); // get current GPS position.    
    //receivePosition();
    //_buildCurrentMarker();
    //geoLocation.LocationStream.streamBroadcastController.stream.listen((Position position) {
      //print("*********** position " + position.toString());
      //if(_controller.isCompleted) createCurrentMarker2(position);
    //});     
  }

  @override
  void dispose() {
    super.dispose();
    if(clickSubscription != null)
     clickSubscription.cancel();
  }

  double zoomVal = 3.0;
  @override
  Widget build(BuildContext context){
    _createStudentMarkerImageFromAsset(context);
    _createSchoolMarkerImageFromAsset(context);
    _createBusMarkerImageFromAsset(context);
    _createHomeMarkerImageFromAsset(context); 
    _createCurrentAppMarkerImageFromAsset(context);
  return Scaffold(
    key: _scaffoldKey,
   /* appBar: AppBar(
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.arrowLeft),
        onPressed: (){
        },
      ),
      title: Text("Khartoum City"),
      actions: <Widget>[
        IconButton(
          icon: Icon(FontAwesomeIcons.search),
          onPressed: (){
          },
        )
      ],
      ), // appBar */

    body: Stack(
        children: <Widget>[
          _googleMap(context),          
          //_zoomminufunction(),
          //_zoomplusfunction(),
          studentslist != null ?_buildContainer(): _buildNullContainer2(),
          _mapTypeCycler(),
        ],
    ),
  );
  }

Widget _googleMap(BuildContext context){
try
{
//if(studentslist != null){
      //markers.clear();      
      _initPlatformState();
      markers.addAll(_createMarkers());      
//}
} catch(e) {print("******** _googleMap err: " + e.toString());}

  //print("**************** _googleMap begin...");
  //print("**************** isSocketNullable: " + sockets.SocketIOClass.isSocketNullable().toString());
  //print("**************** currentTrip: " + currentTrip.toString());
  //print("**************** scheduleTripList: "+ scheduleTripList.toString());
  //print("**************** studentslist: "+ studentslist.toString());
  //print("**************** name: "+ name.toString());
  //print("**************** tripID: "+ tripID.toString());

  return Container(
    height: MediaQuery.of(context).size.height, // get inter screen size
    width: MediaQuery.of(context).size.height,
    child: GoogleMap(
      mapType: _mapType,      
      initialCameraPosition: _kInitialPosition,
      compassEnabled: _compassEnabled,
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,      
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      myLocationEnabled: _myLocationEnabled,
      onCameraMove: _updateCameraPosition,  
      onMapCreated: (GoogleMapController controller){
        _controller.complete(controller); 
        //mapCreated = true;        
        print("*********** onMapCreated..");
        _createListen();
      },
      markers:  Set<Marker>.of(markers.values),
    //markers: _buildCurrentMarker(),
  )
  );
}

void _createListen(){
   // stop 2019-08-23 try{
     //if(clickSubscription != null) return;
     // stop 2019-08-23 print("********* sockets.SocketIOClass.clickStream is null? : " + (sockets.SocketIOClass.clickStream == null).toString());
     // stop 2019-08-23 print("********* sockets.SocketIOClass.getclickStream() is null? : " + (sockets.SocketIOClass.getclickStream() == null).toString());
     //if(sockets.SocketIOClass.clickStream == null) return;
     // stop 2019-08-23 if(sockets.SocketIOClass.getclickStream() == null) return;
    //clickStream = sockets.SocketIOClass.trip_Rec_updateLocationStreamController.stream;
    // Subscribe to changes in the stream and update state when changes come through
    //clickSubscription = sockets.SocketIOClass.clickStream.listen((dynamic val) {
      // stop 2019-08-23 clickSubscription = sockets.SocketIOClass.getclickStream().listen((dynamic val) {
      // stop 2019-08-23 if(mounted) setState(() {
        // stop 2019-08-23 if((widget.role_ID_Level == 3 || widget.role_ID_Level == 4 ) && markers.containsKey(trip_bus_markerId)){
          // stop 2019-08-23 print("********* trip init updateLocation...: " + val);
                // stop 2019-08-23 _changePosition(trip_bus_markerId, val.latitude, val.longitude);
        // stop 2019-08-23 }
         // stop 2019-08-23 else{
           //TODO: //addTripBus(val.latitude, val.longitude);
           // stop 2019-08-23 addTripBus(tripID, val.latitude, val.longitude);
          //print("********* trip not init updateLocation...");
         // stop 2019-08-23 }
        
          // stop 2019-08-23 if(widget.role_ID_Level != 3 && widget.role_ID_Level != 4 && markers.containsKey(currentAppMarkerId)){
          // stop 2019-08-23 print("********* currentAppMarkerId updateLocation...: " + val);
                // stop 2019-08-23 _changePosition(currentAppMarkerId, val.latitude, val.longitude);
        // stop 2019-08-23 }

      // stop 2019-08-23 });
    // stop 2019-08-23 });
    // stop 2019-08-23 }catch(ex) { print("************ trip_Rec_updateLocationStreamController Err. :" + ex.toString());}
}

void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  void _remove(MarkerId markerId) {    
    setState(() {
      if (markers.containsKey(markerId)) {
        markers.remove(markerId);
      }
    });
  }

  void _changePosition(MarkerId markerId, double latitude, double longitude) {
    final Marker marker = markers[markerId];   
    if(mounted) {         
    /*setState(() {
      print("******** update Marker..");
      markers[markerId] = marker.copyWith(
        positionParam: LatLng(
          latitude,
          longitude,
        ),
      );
    });*/
    } else
    {
      print("******** not mounted Marker..");
      markers[markerId] = marker.copyWith(
        positionParam: LatLng(
          latitude,
          longitude,
        ),
      );
    }
  }

Map<MarkerId, Marker> _createMarkers()
{     
     if(studentslist != null)
     {
       
       //print("********** studentslist *************");
       //print("********* :: " + studentslist[0]["Student_ID"].toString());
       //print(studentslist.toString());
       //TODO: Add Student marker.
        for(int i=0;i<studentslist.length;i++)
        {
          try{
            String markerKey = 'student_id_${(widget.isParent == true) ? studentslist[i]["_id"] : studentslist[i]["Student_ID"]["_id"]}';
            if(markers.containsKey(markerKey)) continue;

            MarkerId markerId = MarkerId(markerKey);
            Marker student = Marker( // 'marker_id_$_markerIdCounter'
              markerId: markerId, // ID
              position: LatLng(double.parse((widget.isParent == true) ? studentslist[i]["Latitude"].toString(): studentslist[i]["Student_ID"]["Latitude"].toString()), 
                        double.parse((widget.isParent == true) ? studentslist[i]["Longitude"].toString() : studentslist[i]["Student_ID"]["Longitude"].toString())),
              infoWindow: InfoWindow(title: (widget.isParent == true) ? studentslist[i]["Student_Name_ar"] : studentslist[i]["Student_ID"]["Student_Name_ar"]),
              //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
              icon: _markerIconStudnet != null ? _markerIconStudnet : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
              onTap: () {
                _onMarkerTapped(markerId);
              },
              draggable: true,
              

            );
            //print("*********** markers student length1: " + markers.length.toString());
            markers[student.markerId] = student;
            //print("*********** markers student length: " + markers.length.toString());
            //print("***** Student : " + studentslist[i]["Student_ID"]["Latitude"].toString() + " , " + studentslist[i]["Student_ID"]["Longitude"].toString());
            } catch(e) {print("********** studentslist for err: " + e.toString());}
        }      

     }

     if(scheduleTripList != null && scheduleTripList["School_ID"] != null) {

try{
        //print("********** scheduleTripList *************");
       //print(scheduleTripList.toString());

    //TODO: Add School marker, School Branch marker.
    String markerKey = 'school_id_${scheduleTripList["School_ID"]["_id"]}';
    if(!markers.containsKey(markerKey)) {
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
            _onMarkerTapped(markerId);
          },
          draggable: true,
        );
        //print("scheduleTripList school:"+ school.position.toString());
        markers[school.markerId] = school;
        //print("scheduleTripList markers length:"+ markers.length.toString());
    }
} catch(e) {print("********** School_ID err: " + e.toString());}

try{
    if(scheduleTripList["School_Br_ID"] != null){
       String markerKey = 'school_Br_id_${scheduleTripList["School_Br_ID"]["_id"]}';
        if(!markers.containsKey(markerKey)) {
          MarkerId markerId = MarkerId(markerKey);
          Marker schoolBranch = Marker(
            markerId: markerId, // ID
            position: LatLng(double.parse(scheduleTripList["School_Br_ID"]["Latitude"]), double.parse(scheduleTripList["School_Br_ID"]["Longitude"])),
            infoWindow: InfoWindow(title: scheduleTripList["School_Br_ID"]["Br_Name"]),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
            //icon: BitmapDescriptor.fromAsset('lib/app/assets/Schedule/school_icon34x53.png'),
            icon: _markerIconSchool != null ? _markerIconSchool : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,) ,
            onTap: () {
              _onMarkerTapped(markerId);
            },
            draggable: true,
          );        
          markers[schoolBranch.markerId] = schoolBranch;
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
     return markers ;
}

void addTripBus(String tripID, double lat, double long)
{
    try{
    //TODO: Add Trip Bus Marker.
    
      String markerKey = 'Trip_ID_$tripID';
      if(!markers.containsKey(markerKey)) {
          trip_bus_markerId = MarkerId(markerKey);
          Marker trip_bus_marker = Marker(
            markerId: trip_bus_markerId, // ID
            position: LatLng(lat, long),
            infoWindow: InfoWindow(title: "School Bus"),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
            //icon: BitmapDescriptor.fromAsset('lib/app/assets/bus/school-bus-icon-9.png'),
            icon: _markerIconBus != null ? _markerIconBus : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
            onTap: () {
              _onMarkerTapped(trip_bus_markerId);
            },
            draggable: true,  
          );        
          markers[trip_bus_markerId] = trip_bus_marker;
      }
    
        } catch(e) {print("********** trip bus marker err: " + e.toString());}
}

// not used.
void addTripBus_old()
{
    try{
    //TODO: Add Trip Bus Marker.
    if(scheduleTripList["Trip_ID"] != null){
      String markerKey = 'Trip_ID_${scheduleTripList["Trip_ID"]["_id"]}';
      if(!markers.containsKey(markerKey)) {
          trip_bus_markerId = MarkerId(markerKey);
          Marker trip_bus_marker = Marker(
            markerId: trip_bus_markerId, // ID
            position: LatLng(double.parse(scheduleTripList["Trip_ID"]["Latitude"]), double.parse(scheduleTripList["Trip_ID"]["Longitude"])),
            infoWindow: InfoWindow(title: scheduleTripList["Bus_ID"]["Dr_Name_ar"]),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
            //icon: BitmapDescriptor.fromAsset('lib/app/assets/bus/school-bus-icon-9.png'),
            icon: _markerIconBus != null ? _markerIconBus : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
            onTap: () {
              _onMarkerTapped(trip_bus_markerId);
            },
            draggable: true,  
          );        
          markers[trip_bus_markerId] = trip_bus_marker;
      }
    }
        } catch(e) {print("********** trip bus marker err: " + e.toString());}
}

void createCurrentMarker(var position)
{

  try{
  // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      //print("*********** createCurrentMarker: not mounted");
      return;
    }

  //print("*********** createCurrentMarker begin set..");
  //  _changePosition
  //TODO: Add Current App Marker.
    
    if (!markers.containsKey(currentAppMarkerId)) {        
      //print("*********** createCurrentMarker not found" + position.latitude.toString());
              //Marker currentAppMarker = markers[currentAppMarkerId];
              Marker currentAppMarker = Marker(
              markerId: currentAppMarkerId, // ID
              position: LatLng(position.latitude, position.longitude),
              //infoWindow: InfoWindow(title: "it is me"), //TODO: change to current own app name.
              infoWindow: InfoWindow(title: widget.name), 
              //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed,),
              //icon: BitmapDescriptor.fromAsset('lib/app/assets/Map/pin_yellow.png'),
              icon: _markerIconCurrentAppPosition != null ? _markerIconCurrentAppPosition : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose,),
              onTap: () {
                _onMarkerTapped(currentAppMarkerId);
              },
              draggable: true,  
            );     
            //setState(() { 
              markers[currentAppMarkerId] = currentAppMarker; print("*********** markers length: "+ markers.length.toString());
              //});            
        }
        else
        {
          //print("*********** createCurrentMarker found");
          _changePosition(currentAppMarkerId, position.latitude, position.longitude);
        }  
        //for(int i=0;i< markers.length;i++)
        //{
          //print("******** Marker: " + markers[i].markerId.value);
        //}
  } catch(e) { print("************* createCurrentMarker begin err: " + e.toString());}

}

void createCurrentMarker2(Position position)
{
  // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      print("*********** createCurrentMarker: not mounted2");    
    }

  //print("*********** createCurrentMarker begin set2..");
  //  _changePosition
  //TODO: Add Current App Marker.
  //MarkerId markerid = new MarkerId(DateTime.now().toString());
  
    Marker currentAppMarker = markers[currentAppMarkerId];
    if (currentAppMarker == null) {        
              currentAppMarker = Marker(
              markerId: currentAppMarkerId, // ID
              position: LatLng(position.latitude, position.longitude),
              //infoWindow: InfoWindow(title: "it is me"), //TODO: change to current own app name.
              infoWindow: InfoWindow(title: widget.name), 
              //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,), 
              //BitmapDescriptor.defaultMarker,
              // or BitmapDescriptor.fromAsset('assets/asset_name.png')
              icon: _markerIconCurrentAppPosition != null ? _markerIconCurrentAppPosition : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet,),
              onTap: () {
                _onMarkerTapped(currentAppMarkerId);
              },
              draggable: true,  
            );     
            if (mounted) setState(() { markers[currentAppMarkerId] = currentAppMarker; print("******** new Marker..");});            
           
        }
        else
        {
          _changePosition(currentAppMarkerId, position.latitude, position.longitude);
        }  
        
}

Marker _nullMarker(){
    return new Marker(markerId: new MarkerId(DateTime.now().toString()), position: LatLng(15.36, 32.45));
  }

 void _buildCurrentMarker(){
   /*   //print("************** StreamBuilder begin..");
      StreamBuilder<Position>(
      stream: geoLocation.LocationStream.streamBroadcastController.stream,
      builder: (context, snapshot) {
        //print("************** StreamBuilder ");
        if(snapshot.hasData){
                print(snapshot.data.toString());                
         //return snapshot.hasData ? createCurrentMarker2(snapshot.data) : _nullMarker();                 
         //return new Widget(key: snapshot.data,);
        }
        //else
          //return _nullMarker(); 
      },
    );*/
}

 void _onMarkerTapped(MarkerId markerId) {
     final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

void _getMarker(MarkerId markerId) {
     final Marker marker = markers[markerId];
    if (marker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = marker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  Future<void> _createStudentMarkerImageFromAsset(BuildContext context) async {
    if (_markerIconStudnet == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'lib/app/assets/Student/students_male.png')
          .then(_updateStudentBitmap);
    }
  }

  void _updateStudentBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconStudnet = bitmap;
    });
  }

Future<void> _createBusMarkerImageFromAsset(BuildContext context) async {
    if (_markerIconBus == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'lib/app/assets/bus/school-bus-icon-9.png')
          .then(_updateBusBitmap);
    }
  }

  void _updateBusBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconBus = bitmap;
    });
  }

  Future<void> _createSchoolMarkerImageFromAsset(BuildContext context) async {
    if (_markerIconSchool == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'lib/app/assets/School/school_icon34x53_pink.png')
          .then(_updateSchoolBitmap);
    }
  }

  void _updateSchoolBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconSchool = bitmap;
    });
  }

  Future<void> _createHomeMarkerImageFromAsset(BuildContext context) async {
    if (_markerIconStudentHome == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'lib/app/assets/School/home_icon34x53 green.png')
          .then(_updateStudentHomeBitmap);
    }
  }

  void _updateStudentHomeBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconStudentHome = bitmap;
    });
  }

Future<void> _createCurrentAppMarkerImageFromAsset(BuildContext context) async {
    if (_markerIconCurrentAppPosition == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'lib/app/assets/Map/pin_yellow.png')
          .then(_updateCurrentAppBitmap);
    }
  }

  void _updateCurrentAppBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconCurrentAppPosition = bitmap;
    });
  }
  
void receivePosition()
{  
  try
  {
    /*
 // print("*********** receivePosition begin..");
      StreamBuilder<Position>(
      stream: geoLocation.LocationStream.streamBroadcastController.stream,
      builder: (context, snapshot) {
        print("************** StreamBuilder ");
        if(snapshot.hasData){
                print(snapshot.data.toString());
                //createCurrentMarker(snapshot.data);
        //return snapshot.hasData ? snapshot.data : Center(child: Text("No Data"));         
        //return null;
        }
      },
    );
    */
  }
  catch(e) { print("****** receivePosition Error: " + e.toString());}
}

// Create horizontal List of Contaner ( Students)
Widget _buildContainer(){
 return Align(
   alignment: Alignment.bottomLeft,
   child: Container(
     margin: EdgeInsets.symmetric(vertical: 20.0),
     height: 200.0,
     child: ListView.builder(
            itemCount: studentslist != null ? studentslist.length: 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, position) => new Column(       
                children: <Widget>[
                  SizedBox(width: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (widget.isParent == true) ? 
                      _boxes(
                      null, // current_Trip.studentslist[position].img // Image path
                      studentslist[position]["Latitude"], 
                      studentslist[position]["Longitude"], 
                      studentslist[position]["Student_Name_ar"],                      
                      studentslist[position]['Guardians_ID'][0]['_id'],
                      studentslist[position]["Grade_ID"]["Grade_Name_ar"],
                      studentslist[position]['Guardians_ID'][0]['Name'],
                      studentslist[position]['Guardians_ID'][0]['Phone']
                    )
                    :_boxes(
                      null, // current_Trip.studentslist[position].img // Image path
                      studentslist[position]["Student_ID"]["Latitude"], 
                      studentslist[position]["Student_ID"]["Longitude"], 
                      studentslist[position]["Student_ID"]["Student_Name_ar"],                      
                      studentslist[position]['Student_ID']['Guardians_ID'][0]['_id'],
                      studentslist[position]["Student_ID"]["Grade_ID"]["Grade_Name_ar"],
                      studentslist[position]['Student_ID']['Guardians_ID'][0]['Name'],
                      studentslist[position]['Student_ID']['Guardians_ID'][0]['Phone']
                    ),
                  ),          
                ],
              )
     )

   ),
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
             "",
             15.50, 32.30, "", TranslateStrings.no_Student_List(), "","",""
           ),
         ),
       ],
     )

   ),
   ); 
}

Widget _buildNullContainer2(){
  return Align(
   alignment: Alignment.topLeft,
   child: Container(
     margin: EdgeInsets.symmetric(vertical: 20.0),
     height: 200.0,
     child: Text("") // TranslateStrings.noData())
   ),
   ); 
}



Widget _boxes(String _image, var lat, var long, String studentNamear, String guardians_ID, String gradeNamear, String parentName, String parentPhone){
    return GestureDetector(
        onTap: () {
          _gotoLocation(lat,long);
        }, 
        child: new FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.none,
                      //image: NetworkImage(_image),
                      //image:  _image == null || _image =="" ? ExactAssetImage('lib/app/assets/Student/student_menu_icon96x96.png') : NetworkImage(_image),
                      image:  _image == null || _image =="" ? ExactAssetImage('lib/app/assets/Student/student128x128.png') : NetworkImage(_image), 
                    ),
                  ),             
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: myDetailsContainer(studentNamear,gradeNamear, guardians_ID, parentName, parentPhone),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
}

Widget map_StudentName_Null()
{
return new Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
                TranslateStrings.no_Notification_List(),
                style: new TextStyle(fontSize: 20.0, color: Theme.of(context).textTheme.display3.color),
          ),
          SizedBox(width: 10.0),
          new Icon(FontAwesomeIcons.sadTear, color: Theme.of(context).textTheme.display3.color ,
          size: Theme.of(context).textTheme.display3.fontSize)
        ],
      ),
    );  
}

Widget myDetailsContainer(String studentNamear, String gradeNamear, String guardians_ID, String parentName, String parentPhone) {
  return studentNamear == null || studentNamear == "" ? null: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Container(
              child: Text(studentNamear == null || studentNamear == "" ? TranslateStrings.map_StudentName_Null(): studentNamear,
              style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
              )),
        ),           
        Container(
          child: Text(
            gradeNamear == null || gradeNamear == "" ? TranslateStrings.map_Grade_Null(): gradeNamear,
            style: TextStyle(
              color: Colors.black54,
                fontSize: 18.0,
            )
          ),
        ),       
            
        Container(
          child: Text(
            parentName == null || parentName == "" ? TranslateStrings.map_Parent_Null(): parentName,
            style: TextStyle(
              color: Colors.black54,
                fontSize: 18.0,
            )
          ),
        ),       
       
        Container(
          child: new Row(children: <Widget>[
            IconButton(icon: new Icon(FontAwesomeIcons.comments,size: 18,), color: Colors.pink[300],
            onPressed: () {
              //TODO: Send Notification, 
              // TODO: dialog 
              //showParentNoteDialog(context, );
              print("**************** mapList: ");
              showParentNoteDialog(context, guardians_ID, parentMsgSendCallBack, "direct", TranslateStrings.send_Msg_To() + parentName == null || parentName == "" ? "Parent": parentName);               
              
            },),
           Text(
            parentPhone == null || parentPhone == "" ? TranslateStrings.map_Parent_Null(): parentPhone,
            style: TextStyle(
              color: Colors.black54,
                fontSize: 18.0,
            )
          ),
          IconButton(icon: new Icon(FontAwesomeIcons.phone,size: 18), 
          color: (parentPhone == null || parentPhone == "") ? Colors.grey: Colors.pink[300],
            onPressed: () {
              //TODO: Make a Call , [Done]
              if(parentPhone != null && parentPhone != "")
              {
                  phoneCall(parentPhone);
              } else
                NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.no_Contact_Number());
            },),
              IconButton(icon: new Icon(FontAwesomeIcons.sms,size: 18), 
              color: (parentPhone == null || parentPhone == "") ? Colors.grey: Colors.pink[300],
              onPressed: () {
              //TODO: Make a Call , [Done]
              if(parentPhone != null && parentPhone != "")
              {
                  sms(parentPhone);
              } else
                NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.no_Contact_Number());
            },),
          ]),
        ),       

    ],
    );
}

Future<void> _gotoLocation (double lat, double long) async{
    final GoogleMapController controller = await _controller.future;
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
    );
}

Widget _zoomminufunction(){
  return Align(
    alignment: Alignment.topLeft,
    child: IconButton(
      icon: new Icon(FontAwesomeIcons.searchMinus)
      //color: Color(0xff6200ee)
      ,
      onPressed: (){
        zoomVal--;
        _minus(zoomVal);
      },
    ),
  );
}

Future<void> _minus(double zoomVal) async{
  final GoogleMapController controller = await _controller.future;
    // Animate the camera position to that lat, long
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(15.45, 32.15), // change to dynamic values.
          zoom: zoomVal,        
        )
      )
    );
}

Widget _zoomplusfunction(){
  return Align(
    alignment: Alignment.topRight,
    child: IconButton(
      icon: Icon(FontAwesomeIcons.searchPlus,
      //Color(0xff6200ee)
      ),
      onPressed: (){
        zoomVal++;
        _plus(zoomVal);
      },
    ),
  );
}

Future<void> _plus(double zoomVal) async{
  final GoogleMapController controller = await _controller.future;
    // Animate the camera position to that lat, long
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(15.45, 32.15), // change to dynamic values.
          zoom: zoomVal,        
        )
      )
    );
}


  void parentMsgSendCallBack(String guardians_ID, String value, String msgRoute)
  {
    print(" ************************* mapList Dialog result: " + value);
    print(" ************************* mapList Dialog result: " + guardians_ID);
    //sockets.SocketIOClass.sendnotification(guardians_ID, value, msgRoute);
    NetworkUtils.sendNotification('direct', guardians_ID, value, msgRoute, '/Notification/Add');
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

//print("****************** _initPlatformState: " + position.toString());
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    //setState(() {
  //    print("****************** _initPlatformState: " + position.toString());
      //_position = position;
      createCurrentMarker(position);
    //});
  }

  ///////////////////////////////////////////////////////////////////
  ///
  ///
 
Widget _mapTypeCycler(){
    final MapType nextType =
        MapType.values[(_mapType.index + 1) % MapType.values.length];
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        //icon: Icon(FontAwesomeIcons.map,
        icon : Image.asset('lib/app/assets/Map/tip_tool_icon_map.png'), 
        //color: Colors.pink[300]
        //),
        onPressed: (){
          setState(() {
            _mapType = nextType;
          });
        },
      ),
    );
}

 fetchTripData() async{

    String _url = "";
    if(widget.role_ID_Level.toString() == "5")
        _url = "/Students/list";
      else
        _url = "/ScheduleTrip/TodayTrip";

        var responseJson = await NetworkUtils.fetchTrip(widget.user_id, widget.role_ID_Level.toString(), widget.schoolid, widget.schoolbid, widget.token ,"Guardians_ID", true ,_url);
      
          // get TRip from Trip schedule by _id, today, if there record then loadcurrentTrip, else loadCreateNewTrip

          //print("Login Page Line 70, responseJson: " + responseJson);

          print("######### mapList responseJson: " + responseJson.toString());
          
          print("new mapList");
          
          if(responseJson == "" || responseJson == null) {
            print("SnackBar3 fetchTripData mapList");
            NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
            setState(() {
                //_isThereTrip = false;        
            });
          } else if(responseJson == 'NetworkError') {
            print("SnackBar4 fetchTripData mapList");
            NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());
            setState(() {          
                //_isThereTrip = false;        
            });
          } //else if(responseJson['errors'] != null) {
            else if(responseJson['success'] == false) {
            print("SnackBar5 fetchTripData mapList");
            NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());
            setState(() {          
                //_isThereTrip = false;        
            });
          }  else if(responseJson['scheduleTrip'] != null) {
            print("SnackBar6 fetchTripData mapList");
            NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.today_Schedule_Trip());
            //TODO: save TripId, and add to SocketIO.
            tripID = responseJson['scheduleTrip'][0]["Trip_ID"]["_id"];            
            setState(() {
              currentTrip = responseJson;          
            
                print("SnackBar8 fetchTripData mapList");
                //print("currentTrip['scheduleTrip'] != null" );
              scheduleTripList = currentTrip['scheduleTrip'][0];
                studentslist = scheduleTripList['WaypointList'];
                //_isThereTrip = true;
                //_isLoading = true;
                print("new mapList4");
              });
              await saveTripId(tripID); // stop 10-05-2019
              }
              else if(currentTrip != null && currentTrip['scheduletrip'] != null)
              {  
                setState(() {
                //print("currentTrip['scheduletrip'] != null" );
                print("SnackBar9 fetchTripData mapList");
                scheduleTripList = currentTrip['scheduletrip'];  
                studentslist = scheduleTripList['WaypointList'];
                //_isThereTrip = true;
                //_isLoading = true;
                });
            
          }
          else if(responseJson['trip'] != null) {
            print("SnackBar7 fetchTripData mapList");
            NetworkUtils.showSnackBar(_scaffoldKey,TranslateStrings.there_is_no_Schedule_Trip_Today_Select_New_Trip() );
            //TODO: Clear TripId, SocketIO
            //await clearTripId();  // stop 10-05-2019
            setState(() {
              currentTrip = responseJson;          
                //_isThereTrip = false;        
            });        
          }
          else  if(responseJson['students'] != null) {
            setState(() {
              studentslist = responseJson['students'];
              });  
          } 
            else {
            
            //List list = List();
            //list = responseJson as List;
            print("SnackBar8 fetchTripData mapList");
            //print("responseJson:");
            //print(list[0].toString());
          
          setState(() {
                //print("responseJson: " + responseJson.toString());
              // currentTrip = responseJson;
              // _isThereTrip = true;
            });

          //_hideLoading();
          //  return responseJson;
          }

    }

    Future saveTripId(String tripId) async {
      /*
	    _sharedPreferences = await _prefs;		  
		  _sharedPreferences.setString(AuthUtils.tripIDKey, tripId);
      await sockets.SocketIOClass.setTripId(tripId);
      print("############# saveTripId: " + tripId);
      */
}

Future clearTripId() async {
  /*
	_sharedPreferences = await _prefs;		  
		  _sharedPreferences.setString(AuthUtils.tripIDKey, "");
      await sockets.SocketIOClass.clearTripId();
      */
}

}


