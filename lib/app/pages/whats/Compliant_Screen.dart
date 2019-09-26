import 'package:flutter/material.dart';
//import 'package:bus_tracker/app/components/CompliantList.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
import 'package:bus_tracker/app/utils/GeneralFunction.dart';
//import 'package:bus_tracker/app/components/DateRange.dart' as DateRagePicker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/components/PhoneCall.dart';
import 'package:bus_tracker/app/components/Notification.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

class CompliantScreen extends StatefulWidget {  
final String schoolID, schoolBrID, scManagerContact;
final int roleIDLevel;
CompliantScreen({this.schoolID, this.schoolBrID, this.scManagerContact, this.roleIDLevel});

  @override
  CompliantScreenState createState() {    
    return new CompliantScreenState();
  }
}

class CompliantScreenState extends State<CompliantScreen> { 
  
  
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isThereNotes = false;
  List list;
  var supervisorID, driverID, tripID;

  @override
  void initState() {   
    super.initState();
    _showLoading();  
    _fetchTripIDs();
    _fetchComplaintData();
  }

  _fetchComplaintData() async{

		var responseJson = await NetworkUtils.fetchComplaintData("/Complaint/listByDate");			

      print("@@@@@@@@@ _fetchComplaintData: " + responseJson.toString());
      
      print("new note3");
			
      if(responseJson == "" || responseJson == null) {
        print("SnackBar3 _fetchNotificationData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
        setState(() {
		        _isThereNotes = false;        
		    });
			} else if(responseJson == 'NetworkError') {
        print("SnackBar4 _fetchComplaintData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError()); 
        setState(() {          
		        _isThereNotes = false;        
		    });
			} 
        else if(responseJson['success'] == false) {
        print("SnackBar5 _fetchComplaintData home");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.server_Invalid_Data()); 
        setState(() {          
		        _isThereNotes = false;        
		    });
			}  else if(responseJson['complaint'] != null) {
        print("SnackBar6 _fetchComplaintData home");
				//NetworkUtils.showSnackBar(_scaffoldKey, 'Complaint'); // TODO: Err: Unhandled Exception: NoSuchMethodError: The method 'showSnackBar' was called on null.
        setState(() {
            list = responseJson['complaint'];                   
            print("SnackBar8 _fetchComplaintData home");            
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
    String urL = widget.roleIDLevel == 5 ? "/ScheduleTrip/StudentTodayTrip" : "/ScheduleTrip/TodayTrip";
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
          if(widget.roleIDLevel == 5) {
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

     @override
  Widget build(BuildContext context) {    
    //return _isLoading ? new CompliantListField(compliantList) : nullCompliant();
    //return list == null || list.length == 0 ? nullCompliant(): compliantsWidget();
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
      body: list == null || list.length == 0 ? nullCompliant(): compliantsWidget(),
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
              //print("*********** widget.schoolID: " + widget.schoolID.toString());
               //TODO: Send Complaint to School.               
               showComplaintDialog(context, widget.schoolBrID != null ? widget.schoolBrID: widget.schoolID, '', 1, widget.schoolBrID != null ? TranslateStrings.to_School_Branch(): TranslateStrings.to_School(), complaintMsgSendCallBack);
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
                //showNoteDialog(context, supervisorID, TranslateStrings.to_Supervisor(),  'direct', msgSendCallBack);
                showComplaintDialog(context, supervisorID, '', 1, TranslateStrings.to_Supervisor(), complaintMsgSendCallBack); 
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
                showComplaintDialog(context, supervisorID, '', 1, TranslateStrings.to_Driver(), complaintMsgSendCallBack);             
            },
          );   

          widgets.add(schoolAction);

          if(widget.roleIDLevel == 5){
            widgets.add(SizedBox(height: 10,));
            widgets.add(supervisorAction);
            widgets.add(SizedBox(height: 10,));
            widgets.add(driverAction);
          } else if(widget.roleIDLevel == 3){           
            widgets.add(SizedBox(height: 10,));
            widgets.add(driverAction);
          } else if(widget.roleIDLevel == 4){           
            widgets.add(SizedBox(height: 10,));
            widgets.add(supervisorAction);
          }
  return widgets;
}

 Widget nullCompliant(){
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
      ),
    );
  }

 Widget compliantsWidget(){
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
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          SizedBox(height: 10.0,),
                                          new Text(
                                            TranslateStrings.subject() + ": ${list[position]['Subject'] != null ? list[position]['Subject']: ""}",
                                            style: new TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          //new Text(
                                          //  "Pickup location: ${list[position]['Student_ID']['Pickup_location'] != null ? list[position]['Student_ID']['Pickup_location']: ""}",
                                          //  style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                                          //),
                                        ],
                                      ),
                                      subtitle: new Container(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: new Column(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                          new Text(
                                          TranslateStrings.msg() + ": ${list[position]['Body'] != null ? list[position]['Body']: ""}",
                                          style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                                          ),
                                          //new Text(
                                          //  "Phone: ${list[position]['Student_ID']['Guardians_ID'] != null? list[position]['Student_ID']['Guardians_ID'][0]['Phone']: ""}",
                                          //  style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                                          //),
                                         //  Container(
                                          //  child: new Row(children: <Widget>[                                            
                                            Text(TranslateStrings.sender() + ": ${list[position]['User_ID'] != null ? (list[position]['User_ID']['Name'] != null ? list[position]['User_ID']['Name'] : "") : ""}",                                              
                                              style: TextStyle(
                                                color: Colors.black54,
                                                  fontSize: 18.0,
                                              )
                                            ),
                                            //TODO: format Date and Time, 2019-05-25T11:50:52.211Z
                                             Text( TranslateStrings.date() + ": ${parsingDateTime(list[position]['Created_at'].toString())}",                                              
                                              style: TextStyle(
                                                color: Colors.black54,
                                                  fontSize: 18.0,
                                              )
                                            ),  
                                           // ]),
                                          //),  
                                             new Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                            //TODO: change icon FontAwesomeIcons.commentAlt to non Enable icon when phone is null.
                                              IconButton(icon: new Icon(FontAwesomeIcons.sms,size: 18,), 
                                              color:  ((list[position]['User_ID'] != null && (list[position]['User_ID']['Phone'] != null && list[position]['User_ID']['Phone'] != "")) ? Theme.of(context).textTheme.display3.color: Colors.grey),                                  
                                              onPressed: () {
                                                //TODO: Send Compliant scManagerContact
                                                if(list[position]['User_ID'] != null)
                                                if(list[position]['User_ID']['Phone'] != null
                                                && list[position]['User_ID']['Phone'] != "")
                                                    sms(list[position]['User_ID']['Phone']);
                                                    else
                                                    //TODO: Error change to AlertDialog
                                                    NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.no_Contact_Number());                                                         
                                              },),
                                                new Padding(
                                                  padding: new EdgeInsets.all(8.0),
                                                ),
                                            //TODO: change icon FontAwesomeIcons.commentAlt to non Enable icon when phone is null.
                                              IconButton(icon: new Icon(FontAwesomeIcons.phone,size: 18), 
                                              color:  ((list[position]['User_ID'] != null && (list[position]['User_ID']['Phone'] != null && list[position]['User_ID']['Phone'] != "")) ? Theme.of(context).textTheme.display3.color: Colors.grey),                                  
                                              onPressed: () {
                                                //TODO: Make a Call
                                                if(list[position]['User_ID'] != null && list[position]['User_ID']['Phone'] != null
                                                && list[position]['User_ID']['Phone'] != "")
                                                    phoneCall(list[position]['User_ID']['Phone']);
                                                    else
                                                    //TODO: Error change to AlertDialog
                                                    NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.no_Contact_Number());
                                              },),
                                                new Padding(
                                                  padding: new EdgeInsets.all(8.0),
                                                ),
                                              //TODO: change icon FontAwesomeIcons.commentAlt to non Enable icon when phone is null.
                                              IconButton(icon: new Icon(FontAwesomeIcons.solidComments,size: 18), 
                                              color: Theme.of(context).textTheme.display3.color,
                                              onPressed: () {
                                                //TODO: Replay Complaint
                                                if(list[position]['User_ID'] != null && list[position]['User_ID']['_id'] != null)  { 
                                                    print("%%%%%%%%%% User_ID: ");
                                                    showComplaintDialog(context, list[position]['User_ID']['_id'], '', 1, TranslateStrings.replay_To() + ": ${list[position]['User_ID'] != null ? (list[position]['User_ID']['Name'] != null ? list[position]['User_ID']['Name'] : "") : ""}", complaintMsgSendCallBack); 
                                                    //showWarningDialog(context);
                                                }
                                                    else
                                                    //TODO: Error change to AlertDialog FontAwesomeIcons
                                                    NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.no_Contact_Number());
                                              },), 
                                               ]
                                            ),
                                        

                                        ]
                                        ),
                                        ),
                                    ),                                    
                                   
                                    //SizedBox(height: 10.0,),
                                    
                                    ],
                                  ),
                                  )
            ]
              ),
        
		    ),
      );
 }

void complaintMsgSendCallBack(String subjectValue, String bodyValue, String toUserID, String replyforID, int statusMarker) {
  print(" *********** complaintMsgSendCallBack Dialog toUserID value: " + toUserID);  
  print(" *********** complaintMsgSendCallBack Dialog value: " + bodyValue);  
  //SocketIOClass.sendnotification(guardians_ID, "msg", msgRoute);
  NetworkUtils.sendComplaint(
      subjectValue, bodyValue, toUserID, replyforID, statusMarker, '/Complaint/Add');
  _fetchComplaintData();
}

}

 
