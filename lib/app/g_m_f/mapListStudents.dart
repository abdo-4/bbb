import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/components/PhoneCall.dart';
//import '../socketio/socketIoManager.dart' as sockets; 
//import 'package:bus_tracker/app/states/App_SocketState.dart' as sockets;
import 'package:bus_tracker/app/components/Notification.dart';
//import 'package:geolocator/geolocator.dart';
//import '../geolocator/pages/location_stream_class.dart' as geoLocation;

import 'package:bus_tracker/app/utils/network_utils.dart';
//import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

import 'package:bus_tracker/app/states/App_MapState.dart';
import 'package:provider/provider.dart';


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

  BitmapDescriptor _markerIconStudnet;
  BitmapDescriptor _markerIconBus;
  BitmapDescriptor _markerIconSchool;
  BitmapDescriptor _markerIconStudentHome;
  BitmapDescriptor _markerIconCurrentAppPosition;
  var appMapState;

  @override
  void initState(){
    super.initState();   

     
        
  }

  @override
  void dispose() {
    super.dispose();   
  }

Future<Null> refreshList() async {    
    await Future.delayed(Duration(seconds: 1));

    //network call and setState so that view will render the new values
    print("refresh");
     //if(Provider.of<AppMapState>(context).user_id == null){
        print("refreshList setInitValues mapListStudents.dart");
        Provider.of<AppMapState>(context).setInitValues(widget.name, widget.user_id, widget.schoolid, widget.schoolbid, widget.token, widget.isParent, widget.role_ID_Level);        
        Provider.of<AppMapState>(context).loadData();
     //}
  }

  double zoomVal = 3.0;
  @override
  Widget build(BuildContext context){
    if(appMapState == null){
       print("AppMapState build mapListStudents.dart");
      appMapState = Provider.of<AppMapState>(context);

      refreshList();
      //appMapState.setInitValues(widget.name, widget.user_id, widget.schoolid, widget.schoolbid, widget.token, widget.isParent, widget.role_ID_Level);        
      //appMapState.set_scaffoldKey(_scaffoldKey);
    }
        

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
         appMapState.studentslist != null ?_buildContainer(): _buildNullContainer3(),
          _mapTypeCycler(),     
          if(appMapState.myLocationButtonEnabled) _savePickupChangePosition(),
        ],
    ),
  );
  }


Widget _googleMap(BuildContext context){

//print("appMapState.. : " + appMapState.mapType.toString());
/*
 return Container(
    height: MediaQuery.of(context).size.height, // get inter screen size
    width: MediaQuery.of(context).size.height,
    child: Center(
      child: Text("fffffffffffffffffff"),
    ));
*/

print("AppMapState _googleMap mapListStudents.dart");

  return Container(
    height: MediaQuery.of(context).size.height, // get inter screen size
    width: MediaQuery.of(context).size.height,
    child: GoogleMap(
      mapType: appMapState.mapType,      
      initialCameraPosition: appMapState.initposition,
      compassEnabled: appMapState.compassEnabled,
      cameraTargetBounds: appMapState.cameraTargetBounds,
      minMaxZoomPreference: appMapState.minMaxZoomPreference,      
      rotateGesturesEnabled: appMapState.rotateGesturesEnabled,
      scrollGesturesEnabled: appMapState.scrollGesturesEnabled,
      tiltGesturesEnabled: appMapState.tiltGesturesEnabled,
      zoomGesturesEnabled: appMapState.zoomGesturesEnabled,
      myLocationEnabled: appMapState.myLocationEnabled,
      myLocationButtonEnabled: appMapState.myLocationButtonEnabled,
      onCameraMove: appMapState.updateCameraPosition,  
      onMapCreated: appMapState.onCreated,
      markers:appMapState.markers , //  Set<Marker>.of(appMapState.markers.values),
      polylines: appMapState.polyLines,
    //markers: _buildCurrentMarker(),
  )
  );
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
      print("AppMapState _updateStudentBitmap mapListStudents.dart");
      appMapState.set_markerIconStudnet(_markerIconStudnet);
    });
  }

Future<void> _createBusMarkerImageFromAsset(BuildContext context) async {
    if (_markerIconBus == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'lib/app/assets/bus/school-bus-icon-9_36x36.png')
          .then(_updateBusBitmap);
    }
  }

  void _updateBusBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconBus = bitmap;
      print("AppMapState _updateBusBitmap mapListStudents.dart");
      appMapState.set_markerIconBus(_markerIconBus);
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
      print("AppMapState _updateSchoolBitmap mapListStudents.dart");
      appMapState.set_markerIconSchool(_markerIconSchool);
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
      print("AppMapState _updateStudentHomeBitmap mapListStudents.dart");
      appMapState.set_markerIconStudentHome(_markerIconStudentHome);
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
      print("AppMapState _updateCurrentAppBitmap mapListStudents.dart");
      appMapState.set_markerIconCurrentAppPosition(_markerIconCurrentAppPosition);
    });
  }


// Create horizontal List of Contaner ( Students)
Widget _buildContainer(){
  print("AppMapState _buildContainer mapListStudents.dart");
  print("############# AppMapState: " + appMapState.studentslist.toString());
 return Align(
   alignment: Alignment.bottomLeft,
   child: Container(
     margin: EdgeInsets.symmetric(vertical: 20.0),
     height: 200.0,
     child: ListView.builder(
            itemCount: appMapState.studentslist != null ? appMapState.studentslist.length: 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, position) => new Column(       
                children: <Widget>[
                  SizedBox(width: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (widget.isParent == true) ? 
                      _boxes(
                      null, // current_Trip.studentslist[position].img // Image path
                      appMapState.studentslist[position]["_id"],
                      appMapState.studentslist[position]["Latitude"].toDouble(), 
                      appMapState.studentslist[position]["Longitude"].toDouble(), 
                      appMapState.studentslist[position]["Student_Name_ar"],                      
                      appMapState.studentslist[position]['Guardians_ID'][0]['_id'],
                      appMapState.studentslist[position]["Grade_ID"]["Grade_Name_ar"],
                      appMapState.studentslist[position]['Guardians_ID'][0]['Name'],
                      appMapState.studentslist[position]['Guardians_ID'][0]['Phone']
                    )
                    :_boxes(
                      null, // current_Trip.studentslist[position].img // Image path
                      appMapState.studentslist[position]["Student_ID"]["_id"],
                      appMapState.studentslist[position]["Student_ID"]["Latitude"].toDouble(), 
                      appMapState.studentslist[position]["Student_ID"]["Longitude"].toDouble(), 
                      appMapState.studentslist[position]["Student_ID"]["Student_Name_ar"],                      
                      appMapState.studentslist[position]['Student_ID']['Guardians_ID'][0]['_id'],
                      appMapState.studentslist[position]["Student_ID"]["Grade_ID"]["Grade_Name_ar"],
                      appMapState.studentslist[position]['Student_ID']['Guardians_ID'][0]['Name'],
                      appMapState.studentslist[position]['Student_ID']['Guardians_ID'][0]['Phone']
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
             "", "",
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

Widget _buildNullContainer3(){
  return Align(
   alignment: Alignment.topLeft,
   child: Text("")
   ); 
}


Widget _boxes(String _image, String student_ID, double lat, double long, String studentNamear, String guardians_ID, String gradeNamear, String parentName, String parentPhone){
    return GestureDetector(
        onTap: () {
          print("_boxes onTap press.");
          _gotoLocation(lat, long);
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
                    child: myDetailsContainer(student_ID, lat,  long, studentNamear,gradeNamear, guardians_ID, parentName, parentPhone),
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

Widget myDetailsContainer(String student_ID, double lat, double long, String studentNamear, String gradeNamear, String guardians_ID, String parentName, String parentPhone) {
  print("AppMapState myDetailsContainer mapListStudents.dart");
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
            //TODO: Add Students Pickup Change.
            IconButton(icon: new Icon(FontAwesomeIcons.mapPin,size: 18), 
              color: (parentPhone == null || parentPhone == "") ? Colors.grey: Colors.pink[300],
              onPressed: () async {
               final result = await confirmDialog(context, TranslateStrings.confirm_Dialog(),TranslateStrings.confirm_Dialog_StudentPickupChange());                                        
                    print("result: " + result.toString());
                                if(result == "Yes"){                             
                                  appMapState.select_StudentMarker(student_ID);
                                  //TODO: correct err:
                                  //_gotoLocation(lat, long);
                                }                                
            },),
                       
          ]),
        ),       

    ],
    );
}

Future<void> _gotoLocation (double lat, double long) async{
    //final GoogleMapController controller = await appMapState._controller.future;
    print("AppMapState _gotoLocation mapListStudents.dart");
    final GoogleMapController controller = await appMapState.mapController.future;
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
  //final GoogleMapController controller = await appMapState._controller.future;
  print("AppMapState _minus mapListStudents.dart");
  final GoogleMapController controller = await appMapState.mapController.future;
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
  //final GoogleMapController controller = await appMapState._controller.future;
  print("AppMapState _plus mapListStudents.dart");
  final GoogleMapController controller = await appMapState.mapController.future;
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

Widget _mapTypeCycler(){
  print("AppMapState _mapTypeCycler mapListStudents.dart");
    final MapType nextType =
        MapType.values[(appMapState.mapType.index + 1) % MapType.values.length];
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        //icon: Icon(FontAwesomeIcons.map,
        icon : Image.asset('lib/app/assets/Map/tip_tool_icon_map.png'), 
        //color: Colors.pink[300]
        //),
        onPressed: (){
          setState(() {
            appMapState.mapType = nextType;
          });
        },
      ),
    );
} 

Widget _savePickupChangePosition(){    
  print("AppMapState _savePickupChangePosition mapListStudents.dart");
    return Align(
      alignment: Alignment.topCenter,
      child: IconButton(icon: new Icon(FontAwesomeIcons.save,size: 18), 
          color: Colors.pink[300],
            onPressed: () {
              //TODO: Make a Call , [Done]
                appMapState.save_StudentMarker();
            }),
    );
} 


}


