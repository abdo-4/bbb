//import 'dart:async';
import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_tracker/app/components/Drawer.dart';

//import 'package:bus_tracker/app/pages/whats/call_screen.dart';
//import 'package:bus_tracker/app/pages/whats/camera_screen.dart';
//import 'package:bus_tracker/app/pages/whats/chat_screen.dart';
import 'package:bus_tracker/app/pages/whats/Students_screen.dart';
//import 'package:bus_tracker/app/pages/whats/status_screen.dart';
//import 'package:bus_tracker/app/pages/whats/Tracker_screen.dart';
import 'package:bus_tracker/app/pages/whats/Notification_screen.dart';
import 'package:bus_tracker/app/pages/whats/SchoolSchedule_Screen.dart';
import 'package:bus_tracker/app/pages/whats/Compliant_Screen.dart';
import 'package:bus_tracker/app/g_m_f/mapListStudents.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import '../Socketio/socketIoManager.dart' as sockets;
import 'package:bus_tracker/app/Socketio/socketIoManager.dart' as sockets;
//import '../geolocator/pages/location_stream_class.dart' as geoLocation;
import 'package:bus_tracker/app/components/LoadScreenWidget.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

import 'package:bus_tracker/app/Internationalization/scope_model_wrapper.dart';
//import 'package:bus_tracker/app/Internationalization/translation_strings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:bus_tracker/app/states/App_MapState.dart';
import 'package:provider/provider.dart';

enum TabItem { map, student, notification, compliant, schedule }

class HomePage extends StatefulWidget {
	static final String routeName = 'home';

	@override
	State<StatefulWidget> createState() {
		return new _HomePageState();
	}

}

class _HomePageState extends State<HomePage> 
 with SingleTickerProviderStateMixin // must add for: "vsync: this"
  {
	GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TabController _tabController;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  TabItem _currentItem = TabItem.map;

 Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 5));

    //network call and setState so that view will render the new values
    print("refresh");
    //Provider.of<AppMapState>(context).loadData(); 
  }

var idDic = {
"token" : "",
"user_id": "",
"name":"",
//"role_id": "",
"role_ID_Level" : "",
"schoolid": "",
"schoolbrid": ""
};

	SharedPreferences _sharedPreferences;
	//var _authToken, _id, _name, _homeResponse, _user_id, _role_ID, _schoolID, _schoolBrID;
  var currentTrip;
  var scheduleTripList;
  List studentslist;
  bool _isThereTrip = false;

	@override
	void initState() {
    print("88888888888888888888  HomePage initState()");
		super.initState();
    _showLoading();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 5);
    print("new home1");
		 _fetchSessionAndNavigate();
    // 
    print("new home5");

    // for init GPS location to start
    //if(!geoLocation.LocationStream.isListening()){       
    //    print("************ LocationStream.initL()..");
    //  geoLocation.LocationStream.initL();
   // }
      refreshList();
	}
  bool iDsLoad = false;
	_fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
    idDic['token'] = AuthUtils.getToken(_sharedPreferences);
		idDic['role_id'] = _sharedPreferences.getString(AuthUtils.roleIDKey).toString(); 
    idDic['role_ID_Level'] = _sharedPreferences.getInt(AuthUtils.roleLevelKey).toString();
    idDic['user_id'] = _sharedPreferences.getString(AuthUtils.userIdKey);
		idDic['name'] = _sharedPreferences.getString(AuthUtils.nameKey);
    idDic['schoolid'] = _sharedPreferences.getString(AuthUtils.schoolIDKey);
    idDic['schoolbid'] = _sharedPreferences.getString(AuthUtils.schoolBrIDKey);
    idDic['scManagerContact'] = _sharedPreferences.getString('scManagerContact');
    idDic['School_Name_Ar'] = _sharedPreferences.getString('sCNameAr');
    idDic['Trip_ID'] = _sharedPreferences.getString(AuthUtils.tripIDKey);


  

    /*
		String authToken = AuthUtils.getToken(_sharedPreferences);
		int role_ID = _sharedPreferences.getInt(AuthUtils.roleKey);
    var id = _sharedPreferences.getString(AuthUtils.userIdKey);
		var name = _sharedPreferences.getString(AuthUtils.nameKey);
    var schoolID = _sharedPreferences.getString(AuthUtils.schoolIDKey);
    var schoolBrID = _sharedPreferences.getString(AuthUtils.schoolBrIDKey);    
    */

		//print("authToken: " + authToken);

		_fetchHome(idDic['token']);

		setState((){
      /*
			_authToken = authToken;
			_id = id;
			_name = name;
      _user_id = id;
      _role_ID = role_ID;
      _schoolID = schoolID;
      _schoolBrID = schoolBrID;
      */
      if(idDic['token'] != null && idDic['user_id'] != null || idDic['token'] == ""|| idDic['user_id'] == "")
      {   print("new home2");
           fetchTripData();
          print("new home5");
      }
		});
   

		if(idDic['token'] == null|| idDic['user_id'] == null) {
      print("_Logout...");
			_logout();
		}else{
      setState(() {
          iDsLoad = true;
      });
    }
	}

	_fetchHome(String authToken) async {
    //print("************ idDic['user_id']:" + idDic['user_id']);
    //print("************ authToken:" + authToken);
		var responseJson = await NetworkUtils.fetch(idDic['user_id'], authToken, '/Users/Get');

    //print("*********************** _fetchHome: " + responseJson.toString());
		if(responseJson == null) {
      print("SnackBar1");
			NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());

		}else if(responseJson == "") {
      print("SnackBar3");
			NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.empty());

		} 
    else if(responseJson == 'NetworkError') {
      print("SnackBar2");
			NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());

		} else if(responseJson['success'] == false) {

			_logout();

		}

/*
		setState(() {
		  _homeResponse = responseJson.toString();
		});
    */
	}


 fetchTripData() async{

String _url = "";
if(idDic['role_ID_Level'].toString() == "5")
    _url = "/Students/list";
  else
    _url = "/ScheduleTrip/TodayTrip";

		var responseJson = await NetworkUtils.fetchTrip(idDic['user_id'], idDic['role_ID_Level'], idDic['schoolid'], idDic['schoolbid'], idDic['token'],"Guardians_ID", true ,_url);
	
      // get TRip from Trip schedule by _id, today, if there record then loadcurrentTrip, else loadCreateNewTrip

			//print("Login Page Line 70, responseJson: " + responseJson);

      print(" " + responseJson.toString());
      
      print("new home3");
			
      if(responseJson == "" || responseJson == null) {
        print("SnackBar3 fetchTripData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
        setState(() {
		        _isThereTrip = false;        
		    });
			} else if(responseJson == 'NetworkError') {
        print("SnackBar4 fetchTripData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());
        setState(() {          
		        _isThereTrip = false;        
		    });
			} //else if(responseJson['errors'] != null) {
        else if(responseJson['success'] == false) {
        print("SnackBar5 fetchTripData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data());
        setState(() {          
		        _isThereTrip = false;        
		    });
			}  else if(responseJson['scheduleTrip'] != null) {
        print("SnackBar6 fetchTripData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.today_Schedule_Trip());
        //TODO: save TripId, and add to SocketIO.
        idDic['Trip_ID'] = responseJson['scheduleTrip'][0]["Trip_ID"]["_id"];
        await saveTripId(responseJson['scheduleTrip'][0]["Trip_ID"]["_id"]); // stop 10-05-2019
        setState(() {
          currentTrip = responseJson;          
         
            print("SnackBar8 fetchTripData home");
            //print("currentTrip['scheduleTrip'] != null" );
          scheduleTripList = currentTrip['scheduleTrip'][0];
            studentslist = scheduleTripList['WaypointList'];
		        _isThereTrip = true;
            _isLoading = true;
            print("new home4");
          });
          //TODO: Get Trip Route, and send to server, server send it to relative.
          print("AppMapState fetchTripData home_page.dart");
          Provider.of<AppMapState>(context).getTripRoute(scheduleTripList['_id'],studentslist);
          }
          else if(currentTrip != null && currentTrip['scheduletrip'] != null)
          {  
            setState(() {
            //print("currentTrip['scheduletrip'] != null" );
            print("SnackBar9 fetchTripData home");
            scheduleTripList = currentTrip['scheduletrip'];  
            studentslist = scheduleTripList['WaypointList'];
		        //_isThereTrip = true;
            //_isLoading = true;
            });
        
      }
      else if(responseJson['trip'] != null) {
        print("## SnackBar7 fetchTripData home");
				NetworkUtils.showSnackBar(_scaffoldKey,TranslateStrings.there_is_no_Schedule_Trip_Today_Select_New_Trip() );
        //TODO: Clear TripId, SocketIO
        //await clearTripId();  // stop 10-05-2019
        setState(() {
          currentTrip = responseJson;          
		        _isThereTrip = false;        
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
        print("SnackBar8 fetchTripData home");
        //print("responseJson:");
        //print(list[0].toString());
       
       setState(() {
		        //print("responseJson: " + responseJson.toString());
           // currentTrip = responseJson;
           // _isThereTrip = true;
		    });

      _hideLoading();
        return responseJson;
			}

    }
    


	_logout() {
		NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
	}
bool _isLoading = false;

	@override
	Widget build(BuildContext context) {
    //print("ffff");
    print("########## Homepage AppMapState token " + Provider.of<AppMapState>(context).token);
		return _isLoading && iDsLoad?  _homeScreen(): loadingScreenWidget();
	}

	Widget _homeScreen() {
     
     
   print("########## Homepage idDic['name'] " + idDic['name']);
   print("########## Homepage idDic['schoolid'] " + idDic['schoolid']);
   print("########## Homepage idDic['role_ID_Level'] " + idDic['role_ID_Level']);
   
    
		return new Scaffold(
			key: _scaffoldKey,      
      drawer: new Drawer(child: new DrawerComponent(idDic['name'], idDic['schoolid'], int.parse(idDic['role_ID_Level'] ?? 0)),),
			appBar: new AppBar(
				title: Center(child: new Text(TranslateStrings.school_Bus(), style: Theme.of(context).textTheme.headline)), //style: TextStyle(color: Colors.pink[400], fontSize: 24.0))),        
           elevation: 0.7,
        actions: <Widget>[          
          //new Icon(Icons.search),
          new Padding(padding: const EdgeInsets.symmetric(horizontal: 5.0),),
          //new Icon(Icons.more_vert),
          //TODO: handle sockets.SocketIOClass 
           new IconButton( icon: new Icon(FontAwesomeIcons.sync, color: Theme.of(context).textTheme.headline.color), //color: Colors.pink[200]),
              onPressed:()=> _refresh()),
          //new Icon(Icons.search),
          new Padding(padding: const EdgeInsets.symmetric(horizontal: 5.0),),          
          //new IconButton( icon: new Icon(FontAwesomeIcons.powerOff, color: Theme.of(context).textTheme.display2.color), //color: Colors.pink[200]),
          //    onPressed:()=> _logout(),),
          ScopedModelDescendant<AppModel>(        
               builder: (context, child, model) => IconButton(
                icon: new Icon(FontAwesomeIcons.language, size: 35),
                color: Theme.of(context).textTheme.headline.color,
                onPressed: () {
                  //TODO: Make a Call
                    //NetworkUtils.showSnackBar( _scaffoldKey, 'Forget Password!');
                    setState(() {
                      TranslateStrings.toggle_Local(model.changeDirection());               
                      });
                },
              ), ),      
          new SizedBox(width: 10.0),
        ],
      
			),
			body: _buildBody(),     
      /*
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: new Icon(
          Icons.message,
          color: Colors.white,
        ),
        onPressed: () => print("open chats"),
      ),
*/
 bottomNavigationBar: _buildBottomNavigationBar(),
		);
	}


_refresh(){
  //sockets.SocketIOClass().reconnectSocket();
 switch (_currentItem) {
      case TabItem.map: {    
        print("_refresh");
      Provider.of<AppMapState>(context).loadData(); break;
      }
      case TabItem.student:
      break;
      case TabItem.notification:
        break;
      case TabItem.compliant:
      break;
      case TabItem.schedule:
      break;
    }
  
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
   
  
  Widget _buildBody() { 
    print(" _buildBody home_page.dart" + Provider.of<AppMapState>(context).user_id.toString());
    switch (_currentItem) {
      case TabItem.map: {       // widget.user_id, widget.role_ID_Level.toString(), widget.schoolid, widget.schoolbid, widget.token      
         return new MapStudentList(idDic['name'], int.parse(idDic['role_ID_Level'].toString()) == 5 ? true: false, idDic['user_id'], int.parse(idDic['role_ID_Level'].toString()), idDic['schoolid'] , idDic['schoolbid'] , idDic['token'] );
        //Provider.of<AppMapState>(context)
        //return new Students_Screen(idDic['user_id'].toString(), int.parse(idDic['role_ID_Level'].toString()), idDic['schoolid'].toString(),idDic['schoolbid'].toString(),idDic['token'].toString());        
          
      }
      case TabItem.student:
      return new Students_Screen(idDic['user_id'].toString(), int.parse(idDic['role_ID_Level'].toString()), idDic['schoolid'].toString(),idDic['schoolbid'].toString(),idDic['token'].toString());
        //return (_isThereTrip && studentslist != null)? new Students_Screen(idDic['user_id'].toString(), idDic['role_ID_Level'].toString(),idDic['schoolid'].toString(),idDic['schoolbid'].toString(),idDic['token'].toString())
        //: new Students_Screen(null, idDic['user_id'].toString());
      case TabItem.notification:
        return new NotificationScreen(idDic['user_id'], idDic['name'], int.parse(idDic['role_ID_Level'].toString()), idDic['schoolid'] ,idDic['schoolbid'], idDic['token'].toString());
      case TabItem.compliant:
      //TODO: fill supervisorID after trip start
        return new CompliantScreen(schoolID: idDic['schoolid'] , schoolBrID: idDic['schoolbid'], scManagerContact: idDic['scManagerContact'], roleIDLevel:  int.parse(idDic['role_ID_Level'].toString()));
      case TabItem.schedule:
        return new SchoolSchedulePage(school_Name:idDic['School_Name_Ar'] ,);
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.black,      
      items: <BottomNavigationBarItem>[
        _buildBottomNavigationBarItem(FontAwesomeIcons.mapMarkedAlt, TabItem.map),
        _buildBottomNavigationBarItem(FontAwesomeIcons.userCircle, TabItem.student),
        _buildBottomNavigationBarItem(FontAwesomeIcons.comments, TabItem.notification),
        _buildBottomNavigationBarItem(FontAwesomeIcons.clipboardList, TabItem.compliant),
        _buildBottomNavigationBarItem(FontAwesomeIcons.calendarAlt, TabItem.schedule),
      ],
      onTap: _onSelectTab,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, TabItem tabItem) {
    final String text = TranslateStrings.local == 'en' ? tabItem.toString().split('.').last: TranslateStrings.getHomeTabItem(tabItem.toString().split('.').last);
    final Color color =
        //_currentItem == tabItem ? Theme.of(context).primaryColor : Colors.grey;
       // _currentItem == tabItem ? Colors.pink[300]: Colors.grey;
        _currentItem == tabItem ? Theme.of(context).textTheme.display3.color: Colors.grey;

    return BottomNavigationBarItem(
      icon: Icon(icon ,color: color,),
      title: Column(
        children: <Widget>[
          SizedBox(height: 10.0,),
          Text(
            text,
            style: _currentItem == tabItem ? Theme.of(context).tabBarTheme.labelStyle: Theme.of(context).tabBarTheme.unselectedLabelStyle,
            //style: TextStyle(
              //color: color,
            //),        
          ),
        ],
      ),
    );
  }

  void _onSelectTab(int index) {
    TabItem selectedTabItem;

    switch (index) {
      case 1:
        selectedTabItem = TabItem.student;
        break;
      case 2:
        selectedTabItem = TabItem.notification;
        break;
        case 3:
        selectedTabItem = TabItem.compliant;
        break;
        case 4:
        selectedTabItem = TabItem.schedule;
        break;
      default:
        selectedTabItem = TabItem.map;
    }

    setState(() {
      _currentItem = selectedTabItem;
    });
  }

Future saveTripId(String tripId) async {
	    _sharedPreferences = await _prefs;		  
		  _sharedPreferences.setString(AuthUtils.tripIDKey, tripId);
      //await sockets.SocketIOClass.setTripId(tripId);
      await sockets.SocketIOClass().setTripId(tripId);
      print("############# saveTripId: " + tripId);
}

Future clearTripId() async {
	_sharedPreferences = await _prefs;		  
		  _sharedPreferences.setString(AuthUtils.tripIDKey, "");
      //await sockets.SocketIOClass.clearTripId(); 
      await sockets.SocketIOClass().clearTripId();
}

}