import 'package:flutter/material.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';
import 'package:bus_tracker/app/components/Drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/components/PhoneCall.dart';

class EmergencyScreen extends StatefulWidget {  
  final String username, schoolID;
  final int role_ID_Level;
EmergencyScreen(this.username, this.schoolID, this.role_ID_Level) ;

static final String routeName = 'Emergency';
  @override
  EmergencyScreenState createState() {    
    return new EmergencyScreenState();
  }
}

class EmergencyScreenState extends State<EmergencyScreen> {
  //GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var list;
  var errorMassage = "", _checkConnection = "";

  @override
  void initState() {      
      super.initState();
      _loadEmergencyData();
    }

  void _loadEmergencyData() async{
    //TODO: Get data
    //print("*********************** responseJson: Get data ");
    		var responseJson = await NetworkUtils.fetchEmergencyData('/Emergency_Contact/List');
           // get TRip from Trip schedule by _id, today, if there record then loadcurrentTrip, else loadCreateNewTrip

			print("Login Page Line 70, responseJson: " + responseJson.toString());

      //print("*********************** responseJson: " + responseJson.toString());
      errorMassage = _checkConnection = "";

			if(responseJson == "") {
        print("SnackBar3 _loadEmergencyData");
				//NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
        setState(() {
          errorMassage = TranslateStrings.noData();
		        //_isThereTrip = false;        
		    });
			} else if(responseJson == 'NetworkError') {
        print("SnackBar4 _loadEmergencyData");
				//NetworkUtils.showSnackBar(_scaffoldKey, "Network Error...");
        setState(() {          
          errorMassage = responseJson.toString();
          _checkConnection = TranslateStrings.check_Connection();
		        //_isThereTrip = false;        
		    });
			} else if(responseJson == 'Unauthorized') {
        print("SnackBar5 _loadEmergencyData");
				//NetworkUtils.showSnackBar(_scaffoldKey, "Unauthorize User..");
        setState(() {          
          errorMassage = "Unauthorize User..";
		        //_isThereTrip = false;        
		    });
			}//else if(responseJson['errors'] != null) {
        else if(responseJson['success'] == false) {
        print("SnackBar6 _loadEmergencyData");
				//NetworkUtils.showSnackBar(_scaffoldKey, 'Server Invalid Data');
        setState(() {          
          errorMassage = 'Server Invalid Data';
		       // _isThereTrip = false;        
		    });
			}  else if(responseJson['success'] != null && responseJson['emergency_contact'] != null) {
        print("SnackBar7 _loadEmergencyData");				
        setState(() {
          list = responseJson['emergency_contact'];
          //NetworkUtils.showSnackBar(_scaffoldKey, 'Emergency Contact List done');
          //_isThereTrip = true;                    
		    });
      }

  }

	@override
	Widget build(BuildContext context) {
    //return nullWidget();
		return new Scaffold(
			//key: _scaffoldKey,      
      //drawer: new Drawer(child: new DrawerComponent(widget.username, widget.schoolID,  widget.role_ID_Level),),
			appBar: new AppBar(
				title: Center(child: new Text(TranslateStrings.emergency_Contacts())),
        actions: <Widget>[
            IconButton(
          icon: Icon(FontAwesomeIcons.syncAlt, color: Colors.pink[200],),
          onPressed: () {
              print("**********************  try reload data from server..");
              setState(() {
                   errorMassage = TranslateStrings.wait_msg();  
               });
              _loadEmergencyData();
          },
        )
        ],
			),
			body: list == null || list.length == 0 ? nullWidget(): emergencyWidget(),     
      
		);
	}

  Widget nullWidget(){
    return new Center(
      child: new Text(
            TranslateStrings.noData() ,//+ _checkConnection + errorMassage,
            style: new TextStyle(fontSize: 20.0, color: Colors.pink[300]),),
    );
  }

  Widget emergencyWidget(){
    return new Center(      
             child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, position) => new Column(
            children: <Widget>[        
                                  new Card(
                                    color: Colors.yellow[100],
                                    margin: EdgeInsets.all(12.0),                                    
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[                                  
                                    new ListTile(                                   
                                      title: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 10.0,),
                                          new Text(
                                            TranslateStrings.name() + ": ${list[position]['em_name']}",
                                            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
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
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                          new Text(
                                          TranslateStrings.contact() + ": ${list[position]['em_contact'] != null ? list[position]['em_contact']: ""}",
                                          style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                                          ),
                                          new Text(
                                            TranslateStrings.address() + ": ${list[position]['em_address'] != null? list[position]['em_address']: ""}",
                                            style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                                          ),
                                      
                                        ]
                                        ),
                                        ),
                                    ),
                                                                      
                                    //SizedBox(height: 10.0,),
                                    
                                     new Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                            //TODO: change icon FontAwesomeIcons.commentAlt to non Enable icon when phone is null.
                                              IconButton(icon: new Icon(FontAwesomeIcons.sms,size: 18,), 
                                              color:  list[position]['em_contact'] == null ? Colors.grey: Colors.pink[300],
                                              onPressed: () {
                                                //TODO: Send  
                                                if(list[position]['em_contact'] != null)
                                                    sms(list[position]['em_contact']);
                                                    else
                                                    //TODO: Error change to AlertDialog
                                                    //NetworkUtils.showSnackBar(_scaffoldKey, 'No Contact Number!');    
                                                     print("Phone:" + list[position]['em_contact']);
                                              },),
                                                new Padding(
                                                  padding: new EdgeInsets.all(8.0),
                                                ),
                                            //TODO: change icon FontAwesomeIcons.commentAlt to non Enable icon when phone is null.
                                              IconButton(icon: new Icon(FontAwesomeIcons.phone,size: 18), 
                                              color:  list[position]['em_contact'] == null ? Colors.grey: Colors.pink[300],
                                              onPressed: () {
                                                //TODO: Make a Call
                                                if(list[position]['em_contact'] != null)
                                                    phoneCall(list[position]['em_contact']);
                                                    //else
                                                    //TODO: Error change to AlertDialog
                                                    //NetworkUtils.showSnackBar(_scaffoldKey, 'No Contact Number!');
                                              },),
                                                new Padding(
                                                  padding: new EdgeInsets.all(8.0),
                                                ),
                                               ]
                                            ),
                                    ],
                                  ),
                                  )
            ]
              ),
        
		    ),
      );
  }


}
 
  
 

