import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:bus_tracker/app/socketio/socket_io_manager.dart';
//import 'package:bus_tracker/app/components/notification.dart';

class MapStudentListSheet00 extends StatefulWidget{
    @override 
    HomePageState createState() => HomePageState();
}

class HomePageState extends State<MapStudentListSheet00>{
Completer<GoogleMapController> _controller = Completer();

  @override
  void initState(){
    super.initState();
  }

  double zoomVal = 5.0;
  @override
  Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
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
      ),
    body: Stack(
        children: <Widget>[
          _googleMap(context),
          _zoomminufunction(),
          _zoomplusfunction(),
          _buildContainer(),
        ],
    ),
  );
  }

Widget _googleMap(BuildContext context){
  return Container(
    height: MediaQuery.of(context).size.height, // get inter screen size
    width: MediaQuery.of(context).size.height,
    child: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(target: LatLng(15.45, 32.15), zoom: 12),
      onMapCreated: (GoogleMapController controller){
        _controller.complete(controller);
      },
      markers: _createMarkers(context).toSet(),
    ),
  );
}


List<Marker> _createMarkers(BuildContext context)
{

Marker newyork1 = Marker(
  markerId: MarkerId("_id1"), // ID
  position: LatLng(15.45, 32.15),
  infoWindow: InfoWindow(title: "info 1"),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
  onTap: (){
    showModalBottomSheet(
      context: context,
      builder: (builder){
        return Container(
          color: Colors.white,
          child: new Center(child: new Text("Bottom Sheet"),),
        );
      }      
      );
  }
);

Marker newyork2 = Marker(
  markerId: MarkerId("_id2"), // ID
  position: LatLng(15.50, 32.30),
  infoWindow: InfoWindow(title: "info 2"),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
  onTap: (){
    showModalBottomSheet(
      context: context,
      builder: (builder){
        return Container(
          color: Colors.white,
          child: new Center(child: new Text("Bottom Sheet"),),
        );
      }      
      );
  }
);

List<Marker> markers = new List<Marker>();
markers.addAll({newyork1, newyork2});
 return markers ;
}



// Create horizontal List of Contaner ( Students)
Widget _buildContainer(){
 return Align(
   alignment: Alignment.bottomLeft,
   child: Container(
     margin: EdgeInsets.symmetric(vertical: 20.0),
     height: 150.0,
     child: ListView(
       scrollDirection: Axis.horizontal,
       children: <Widget>[
         SizedBox(width: 10.0,),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: _boxes(
             "image path",
             15.45, 32.15, "info 1.."
           ),
         ),
          SizedBox(width: 10.0,),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: _boxes(
             "image path",
             15.50, 32.30, "info 2.."
           ),
         ),
       ],
     )

   ),
   ); 
}


Widget _boxes(String _image, double lat, double long, String restaurantName){
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
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(_image),
                    ),
                  ),             
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: myDetailsContainer(restaurantName),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
}

Widget myDetailsContainer(String restaurantName) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Container(
              child: Text(restaurantName,
              style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
              )),
        ),
        SizedBox(height: 5.0,),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Text("4.1",
                style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,),
              )),
               Container(
                child: Icon(
                  FontAwesomeIcons.solidStar,                  
                  color: Colors.amber,
                  size: 15.0
              )),
               Container(
                child: Icon(
                  FontAwesomeIcons.solidStar,                  
                  color: Colors.amber,
                  size: 15.0
              )),
               Container(
                child: Icon(
                  FontAwesomeIcons.solidStar,                  
                  color: Colors.amber,
                  size: 15.0
              )),
               Container(
                child: Icon(
                  FontAwesomeIcons.solidStar,                  
                  color: Colors.amber,
                  size: 15.0
              )),
               Container(
                child: Icon(
                  FontAwesomeIcons.solidStarHalf,                  
                  color: Colors.amber,
                  size: 15.0
              )),
              Container(
                child: Text("(946)",
                style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,),
              )),
            ],
          ),
        ),
        SizedBox(height: 5.0,),
        Container(
          child: Text(
            "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
            style: TextStyle(
              color: Colors.black54,
                fontSize: 18.0,
            )
          ),
        ),
        SizedBox(height: 5.0,),
        Container(
          child: Text(
            "Closed \u00B7  17:00 Thu",
            style: TextStyle(
              color: Colors.black54,
                fontSize: 18.0,
                fontWeight: FontWeight.bold
            )
          ),
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

}


