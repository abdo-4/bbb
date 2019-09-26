import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

//import '../pages/page.dart';
import '../pages/ChangePassword.dart';
import '../pages/StartTrip.dart';
import '../pages/whats/Emergency_screen.dart';
//import '../pages/Absent.dart';
//import '../pages/htmlView.dart';
//import '../../Map/GoogleMapsExample.dart';
//Flutter_Map (leaflet map)// stop 2019-03-22
//import '../../mainMap.dart';
//Flutter_Map (leaflet map)// stop 2019-03-22
//import '../../Map/pages/home.dart' as MapHomePage;
import '../pages/home_page.dart' as HomePage;
//import 'package:bus_tracker/app/utils/network_utils.dart';
//import '../g_m_f/mapListStudents.dart';
//import '../geolocator/main_geolocator.dart' as geo;
import '../utils/network_utils.dart';
//import '../pages/fonticons/fonticon.dart';
//import '../Connectivity/main_connectivity.dart' as Connectivity;
//import '../Collection/PullToRefresh.dart' as PullToRefresh;
//import '../Collection/android_alarm_manager_example_android.dart' as AlarmManager;

//import 'package:bus_tracker/app/Socketio/socketio_test.dart' as socketio_test;

import 'package:bus_tracker/app/Internationalization/scope_model_wrapper.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:bus_tracker/app/states/App_MapState.dart';
import 'package:provider/provider.dart';

class DrawerComponent extends StatelessWidget {

var username = "", school ="";
int role_ID_Level = 0;
DrawerComponent(this.username, this.school, this.role_ID_Level);

  //String currentProfilePic = "https://avatars3.githubusercontent.com/u/16825392?s=460&v=4";
  //String otherProfilePic = "https://yt3.ggpht.com/-2_2skU9e2Cw/AAAAAAAAAAI/AAAAAAAAAAA/6NpH9G8NWf4/s900-c-k-no-mo-rj-c0xffffff/photo.jpg";

  void switchAccounts() {
    //String picBackup = currentProfilePic;
    //this.setState(() {
    //  currentProfilePic = otherProfilePic;
    //  otherProfilePic = picBackup;
    //});
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(

          children: <Widget>[           
            new UserAccountsDrawerHeader(              
              //accountEmail: new Text(school, style: TextStyle(color: Colors.pinkAccent, fontSize: 16.0),), // update from server 
              //accountName: new Text(username== "" || username == null? "": username, style: TextStyle(color: Colors.pinkAccent, fontSize: 18.0, fontWeight: FontWeight.bold),), // update from server
              accountName: new Text(username== "" || username == null? "": username, style: Theme.of(context).textTheme.display3), // update from server
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(                  
                  //backgroundImage: new NetworkImage("lib/app/assets/logo.png"),
                  child: new Image.asset('lib/app/assets/logo.png'),
                  radius: 60.0,
                  backgroundColor: Colors.yellowAccent,
                ),
                onTap: () => print("This is your current account."),
              ),
              otherAccountsPictures: <Widget>[
                new GestureDetector(
                  child: new CircleAvatar(
                    //backgroundImage: new NetworkImage(otherProfilePic),
                    child: new Image.asset('lib/app/assets/DARLogo.jpg',
                     height: 100,
                                    width: 100,), // dar logo
                  backgroundColor: Colors.orange[200]
                  ),
                  onTap: () => switchAccounts(),
                ),
              ],
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  //image: new NetworkImage("https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
                  image: new  ExactAssetImage('lib/app/assets/school-bus-transportation-powerpoint-backgrounds.jpg'),
                  fit: BoxFit.fill,
                )
              ),
            ),
            new Divider(),
            new ListTile(
              title: new Text(TranslateStrings.home(), style: Theme.of(context).textTheme.display4), //TextStyle(color: Colors.pinkAccent, fontSize: 16.0),),
              trailing: new Icon(Icons.home, color:  Theme.of(context).textTheme.display3.color),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new HomePage.HomePage()));
              }
            ),     
            new Divider(),     
            new ListTile(
              //title: new Text(TranslateStrings.start_Trip_running_trip(), style: (role_ID_Level == 3 )? Theme.of(context).textTheme.display4: Theme.of(context).textTheme.display4.copyWith(color: Colors.grey)), //Colors.pinkAccent: Colors.grey, fontSize: 16.0)),
              title: new Text(TranslateStrings.start_Trip_running_trip(), style: Theme.of(context).textTheme.display4), 
              trailing: new Icon(FontAwesomeIcons.bus, color: Theme.of(context).textTheme.display3.color),
              onTap: () {
                //if(role_ID_Level == 3 ){
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new StartTripPage()));
                //}
              })
            ,
            new Divider(),     
            new ListTile(
              title: new Text(TranslateStrings.emergency_Contacts(), style: Theme.of(context).textTheme.display4),
              trailing: new Icon(FontAwesomeIcons.phone, color: Theme.of(context).textTheme.display3.color),
              onTap: () {
                //print("Draw:"+ username + "," + school +"," + role_ID_Level.toString());
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new EmergencyScreen(username, school, role_ID_Level)));
              }
            ),
           /*  new Divider(),     
            new ListTile(
              title: new Text("socketio_test", style: TextStyle(color: Colors.pinkAccent, fontSize: 16.0)),
              trailing: new Icon(FontAwesomeIcons.phone, color: Theme.of(context).textTheme.display3.color),
              onTap: () {                
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new socketio_test.MyAppSocket()));
              }
            ), 
*/

            /*new Divider(),     
            new ListTile(
              title: new Text("Load HTML", style: TextStyle(color: Colors.pinkAccent, fontSize: 16.0)),
              trailing: new Icon(FontAwesomeIcons.phone, color: Theme.of(context).textTheme.display3.color),
              onTap: () {
                print("Draw:"+ username + "," + school +"," + role_ID_Level.toString());
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new WebViewTest()));
              }
            ), socketio_test

            new Divider(),     
            new ListTile(
              title: new Text("Load HTML", style: TextStyle(color: Colors.pinkAccent, fontSize: 16.0)),
              trailing: new Icon(FontAwesomeIcons.phone, color: Theme.of(context).textTheme.display3.color),
              onTap: () {
                print("Draw:"+ username + "," + school +"," + role_ID_Level.toString());
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new WebViewTest()));
              }
            ),*/

            /*new Divider(),     
            new ListTile(
              title: new Text("FontAwesomeIcons", style: TextStyle(color: Colors.pinkAccent, fontSize: 16.0)),
              trailing: new Icon(FontAwesomeIcons.phone, color: Theme.of(context).textTheme.display3.color),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new FontIconScreen()));
              }
            ),

            
            new Divider(),
              new ListTile(
              title: new Text("Student Absent not used"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new AbsentPage()));
              }
            ),        
            new Divider(height: 10.0,),    
              new ListTile(
              title: new Text("Buses Track not used"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new GoogleMapsExample("Google Maps Example")));
                //Flutter_Map (leaflet map)// stop 2019-03-22
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MainMapApp())); MapStudentList
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MapStudentList()));
              }
            ),      
            */   
            
            /*new Divider(height: 10.0,),   
              new ListTile(
              //title: new Text("OpenStreetMap not used"), GeolocatorExampleApp
              title: new Text("GeolocatorExampleApp"), 
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                //Flutter_Map (leaflet map)// stop 2019-03-22
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MapHomePage.HomePage()));
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new geo.GeolocatorExampleApp())); 
              }
            ),*/  
   /*         
             new Divider(height: 10.0,),   
              new ListTile(
              //title: new Text("OpenStreetMap not used"), GeolocatorExampleApp
              title: new Text("Internet Connectivity"), 
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();                
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Connectivity.HomeApp())); 
              }
            ), 
new Divider(height: 10.0,),   
              new ListTile(
              //title: new Text("OpenStreetMap not used"), GeolocatorExampleApp
              title: new Text("Pull To Refresh"), 
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();                
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new PullToRefresh.SwipeDeleteDemo())); 
              }
            ), 
new Divider(height: 10.0,),   
              new ListTile(
              //title: new Text("OpenStreetMap not used"), GeolocatorExampleApp
              title: new Text("Alarm"), 
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();                
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new AlarmManager.)); 
              }
            ),
*/
            new Divider(),
            new ListTile(
              title: new Text(TranslateStrings.change_Password(), style: Theme.of(context).textTheme.display4),
              trailing: new Icon(FontAwesomeIcons.userEdit, color: Theme.of(context).textTheme.display3.color),
              onTap: () {                
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ChangePasswordPage()));
              } 
            ),
             new Divider(),
            ScopedModelDescendant<AppModel>(        
               builder: (context, child, model) =>new ListTile(
              title: new Text(TranslateStrings.current_Local_Text(), style: Theme.of(context).textTheme.display4),
              trailing: new Icon(FontAwesomeIcons.language, size: 36, color: Theme.of(context).textTheme.display3.color),
              onTap: () {                                
                  TranslateStrings.toggle_Local(model.changeDirection());
                //Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new HomePage.HomePage()));                
              } 
            ),),            
            new Divider(),
                new Card(
              color: Colors.yellow[100],
              margin: EdgeInsets.all(12.0),
              child: new Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new ListTile(
                   leading:  new GestureDetector(
                  child: new CircleAvatar(
                    backgroundImage: new NetworkImage(NetworkUtils.scImg),
                    //child: new Image.asset('lib/app/assets/DARLogo.png'), // dar logo
                    radius: 35,
                  ),
                  onTap: () => switchAccounts(),
                ),

                /*    leading: new Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        color: Colors.yellow[100],
                        image: new DecorationImage(
                          image: ExactAssetImage(
                              'lib/app/assets/Student/student_menu_icon96x96.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(50.0)),
                        border: new Border.all(
                          color: Colors.red,
                          width: 4.0,
                        ),
                      ),
                    ),*/
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
                          //TranslateStrings.drawer_School() + ": ${NetworkUtils.sCNameAr}",
                           "${NetworkUtils.sCNameAr}",
                          style: Theme.of(context).textTheme.display4, //new TextStyle(fontWeight: FontWeight.bold),
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
                              TranslateStrings.drawer_School() + ": ${NetworkUtils.scPhone}",
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                            ),
                            new Text(
                              TranslateStrings.drawer_Phone() + ": ${NetworkUtils.sCmanagerName}",
                              style: new TextStyle(color: Colors.black, fontSize: 15.0),
                            ),
                           new Text(
                              TranslateStrings.drawer_ManagerContact() + ": ${NetworkUtils.scManagerContact}",
                              style: new TextStyle(color: Colors.black, fontSize: 15.0),
                            ),
                             new Text(
                              TranslateStrings.drawer_Description() + ": ${NetworkUtils.scContent}",
                              style: new TextStyle(color: Colors.black, fontSize: 15.0),
                            ),
                              new Center(
                                  child:  Provider.of<AppMapState>(context).isAdvertisement() == true ? Image.network(Provider.of<AppMapState>(context).getAdvertisementData(),
                                    height: 100,
                                    width: 300
                                  ):  Image.asset(
                                    'lib/app/assets/logo150x150.png',
                                    height: 100,
                                    width: 100,
                                  ),
                                  )
                          ]),
                    ),
                  ), 
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            new Divider(),
            new ListTile(
              title: new Text("Close", style: Theme.of(context).textTheme.display4),
              trailing: new Icon(FontAwesomeIcons.lock, color: Theme.of(context).textTheme.display3.color),
              //onTap: () => Navigator.pop(context),
              onTap: (){
                NetworkUtils.logoutUser2(context);
              },
            ),
            new Divider(),
            new ListTile(
              title: new Container(
                color: Colors.white,
                alignment: Alignment.center,
                //padding: const EdgeInsets.only(left: 32, right: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("\u00a9 2019 ", style: Theme.of(context).textTheme.display4),
                    new Image( image: ExactAssetImage(
                              'lib/app/assets/DARLogo.jpg', 
                              ),
                              height: 25,
                              width: 50,
                              ),
                    new Text(" DAR ", style: Theme.of(context).textTheme.display4),
                    new Text("v1.5", style: Theme.of(context).textTheme.display4),
                  ],
                ),              
              ),
              onTap: null              
            ),
          ],
        );
  }

}