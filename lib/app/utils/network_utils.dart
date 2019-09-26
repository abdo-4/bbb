import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth_utils.dart';

class NetworkUtils {
	static final String host = productionHost;
	static final String productionHost = 'https://www.SchoolBusTrack.com';
	//static final String developmentHost = 'http://10.0.2.2:3000'; // to run localy
  static final String developmentHost = 'http://localhost:3000'; // to run in device
  static final String changePasswordendPoint = "/Users/ChangePass";

static String token = "";
	static String userId = "";
	static String username = "";
  //static String password = "";
	//static int roleID = 0; 
  static String roleIDstr = "Role_ID"; 
  static int roleLevel = 0; 
  static String email = "";
  static String schoolID = "";
  static String sCNameAr = "";
  static String scPhone = "";
  static String scImg = "";
  static String scCssImg = "";
  static String scContent = "";
  static String sCmanagerName = "";
  static String scManagerContact = "";
  static String schoolBrID = "";
  static String tripID = "";
  static String companyName = "sidco";
  static String socketId = "";  

   static String getiDs ()
  {
    String jsonData =
          '{"token": "$token","User_ID": "$userId", "username": "$username", "roleID_str": "$roleIDstr", "roleLevel": "$roleLevel", "email": "$email", "schoolID": "$schoolID", "schoolBrID": "$schoolBrID", "tripID": "$tripID"}'; 
          return jsonData;
  }

  static String schoolIDs ()
  {
    return schoolID != null ? schoolID : "" + schoolBrID != null ? schoolBrID : "";
  }



static bool isSet = false;
 static void initValues(String _token, String _roleIDstr, int _roleLevel,
      String _userId, String _username, 
      String _email, String _schoolID, String _schoolBrID, 
      String _sCNameAr, String _scPhone, String _scImg, String _scContent,
      String _sCmanagerName, String _scManagerContact) {

  //if(!isSet) return;
  //isSet = true;

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
  //tripID = _tripID;
  //companyName = "sidco";
  //socketId = "";
  sCNameAr =_sCNameAr;
  scPhone = _scPhone;
  scImg = _scImg;
  //scCssImg = _scCssImg;
  scContent = _scContent;
  sCmanagerName = _sCmanagerName;
  scManagerContact = _scManagerContact;
  //print("NNNNNNNNNNN schoolBrID: " + schoolBrID);

  

      }


	//static dynamic authenticateUser(String email, String password) async {
    static dynamic authenticateUser(String username, String password, String endPoint) async {
		//var url = host + AuthUtils.endPoint;
    //var url = developmentHost + AuthUtils.endPoint;
    var url = developmentHost + endPoint;
    //var url = productionHost + AuthUtils.endPoint;
    
    print("authenticateUser url: " +  url);

    var jsonMap = {
      "username": username.trim(), //"sedco",
		  "password": password.trim() //"sedco"
    };
    
    String jsonStr = jsonEncode(jsonMap);
    print("jsonStr: " + jsonStr);

		  try {
			  http.Response response = await http.post(
			  Uri.encodeFull(url),
        body: jsonStr , 
        headers: { 'Accept': 'application/json', "Content-Type" : "application/json"}
			  );

        //print("response1");
        //print(response.body);
        //print("response json");
        //print(json.decode(response.body));

			  final responseJson = json.decode(response.body);
			  return responseJson;

		  } catch (exception) {
			  print("authenticateUser exception:" + exception.toString());
			  if(exception.toString().contains('SocketException')) {
				  return 'NetworkError';
			  } else {
				  return null;
			  }
		  }
	}

	static logoutUser(BuildContext context, SharedPreferences prefs) {
		prefs.setString(AuthUtils.authTokenKey, null);
		prefs.setString(AuthUtils.roleIDKey, null);
    prefs.setInt(AuthUtils.roleLevelKey, null);
		prefs.setString(AuthUtils.nameKey, null);
    prefs.setString(AuthUtils.emailKey, null);
    prefs.setString(AuthUtils.userIdKey, null);
    prefs.setString(AuthUtils.schoolIDKey, null);
    prefs.setString(AuthUtils.schoolBrIDKey, null);
    //prefs.setString(AuthUtils.tripIDKey, null);
    prefs.setString('sCNameAr', null);
    prefs.setString('scPhone', null);
    prefs.setString('scImg', null);
    //prefs.setString('scCssImg', null);
    prefs.setString('scContent', null);
    prefs.setString('sCmanagerName', null);
    prefs.setString('scManagerContact', null);
		Navigator.of(context).pushReplacementNamed('/');
	} 

  static logoutUser2(BuildContext context) async{
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences = await prefs;
		_sharedPreferences.setString(AuthUtils.authTokenKey, null);
		_sharedPreferences.setString(AuthUtils.roleIDKey, null);
    _sharedPreferences.setInt(AuthUtils.roleLevelKey, null);
		_sharedPreferences.setString(AuthUtils.nameKey, null);
    _sharedPreferences.setString(AuthUtils.emailKey, null);
    _sharedPreferences.setString(AuthUtils.userIdKey, null);
    _sharedPreferences.setString(AuthUtils.schoolIDKey, null);
    _sharedPreferences.setString(AuthUtils.schoolBrIDKey, null);
    //_sharedPreferences.setString(AuthUtils.tripIDKey, null);
    _sharedPreferences.setString('sCNameAr', null);
    _sharedPreferences.setString('scPhone', null);
    _sharedPreferences.setString('scImg', null);
    //_sharedPreferences.setString('scCssImg', null);
    _sharedPreferences.setString('scContent', null);
    _sharedPreferences.setString('sCmanagerName', null);
    _sharedPreferences.setString('scManagerContact', null);
		Navigator.of(context).pushReplacementNamed('/');
	}

	static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    try{
		scaffoldKey.currentState.showSnackBar(
			new SnackBar(
				content: new Text(message ?? 'You are offline'),
			)
		);
    }catch(e){ print("showSnackBar Err:"+ e.toString());}
	}

	static fetch(String _id, var authToken, var endPoint) async {
				//var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint;
    //var url = productionHost + AuthUtils.endPoint;
//print("fetch: " + url);

var jsonMap = {
      "_id": 		_id  
    };
    String jsonStr = jsonEncode(jsonMap);

		try {
			final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + authToken,
          'Content-Type': 'application/json'
				},
			);

			final responseJson = json.decode(response.body);
			return responseJson;

		} catch (exception) {
			print(exception);
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

 static userRegister(String _fullName, String _username, String _password, String _phone, 
    String _email, String endPoint) async {
		//var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint;
    //var url = productionHost + AuthUtils.endPoint;
    print("userRegister: " + url);
    //print("authToken: " + authToken);

    var jsonMap = {      
      "Name": 		_fullName  ,
      "username": _username,
      "password": _password,
      "Phone": _phone,
      "Email": _email     
    };
    String jsonStr = jsonEncode(jsonMap);

		try {
			final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			);

      print(response.body);
			final responseJson = json.decode(response.body);
      print("###### userRegister responseJson: "+ response.body);
			return responseJson;

		} catch (exception) {
			print("########## userRegister exception:" + exception.toString());
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return 'Error Valid Data';
			}
		}
	}

  static changePassword(String _id, String oldPassword, String newPassword, var authToken) async {
				//var url = host + AuthUtils.endPoint;
    var url = developmentHost + changePasswordendPoint;
    //var url = productionHost + AuthUtils.endPoint;
    print("changePassword: " + url);
    print("authToken: " + authToken);

    var jsonMap = {
      "_id": 		_id  ,
      "oldPassword": oldPassword,
      "newPassword": newPassword
    };
    String jsonStr = jsonEncode(jsonMap);

		try {
			final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + authToken,
          'Content-Type': 'application/json'
				},
			);

print(response.body);
			final responseJson = json.decode(response.body);
      print("responseJson: "+ response.body);
			return responseJson;

		} catch (exception) {
			print("changePassword exception:" + exception.toString());
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return 'Error Valid Data';
			}
		}
	}

static fetchAppVersion(String appName, String currentVersion, var endPoint) async {
				//var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint;
    //var url = productionHost + AuthUtils.endPoint;   
    bool result = true;

    var jsonMap = {
      "User_ID": userId,
      "Role_ID": roleIDstr,
      "Role_ID_Level": roleLevel,
      "School_ID": schoolID,
      "School_Br_ID" : schoolBrID ,
      "AppName" : appName      
    };
    String jsonStr = jsonEncode(jsonMap);
    //print("jsonStr: " + jsonStr); 

		try {
			  final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			);
      if(response.body == 'Unauthorized'){
      print("********* responseJson: " + response.body);
      //return response.body;
      result = true; //response.body;
      }
      final responseJson = json.decode(response.body);
			if(responseJson['success'] == true && responseJson['Version'] == currentVersion){
        result = true;
      }
      else
      {
        result = false;
      }

		} catch (exception) {
			print("exception: " + exception.toString());
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
        //result = 'NetworkError';
			} else {
				return null;
        //result = null;
			}
		}
    return result;
	}

	static fetchTrip(String _id, String role_ID_level, String school_ID, String school_Br_ID, var authToken, var studentsPath, var isDirectionFromHomeToSchool, var endPoint) async {
				//var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint;
    //var url = productionHost + AuthUtils.endPoint; 

    var jsonMap = {
      "User_ID": 		_id ,
      "Role_ID": role_ID_level,
      "Role_ID_Level": role_ID_level,
      "School_ID": school_ID,
      "School_Br_ID" : school_Br_ID,
      "StudentsPath" : studentsPath,
      "isDirectionFromHomeToSchool": isDirectionFromHomeToSchool
    };
    String jsonStr = jsonEncode(jsonMap);
    //print("jsonStr: " + jsonStr);
    //print("token: " + token);
    //var result;

		try {
			  final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			);
      if(response.body == 'Unauthorized'){
      print("********* responseJson: " + response.body);
      return response.body;
      //result = response.body;
      }
			//Future<List> responseJson = json.decode(response.body);
      //print("@@@@@@@@@ responseJson: " + response.body);
      //result = response.body;
			return json.decode(response.body);
      //return response.body;

		} catch (exception) {
			print("exception: " + exception.toString());
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
        //result = 'NetworkError';
			} else {
				return null;
        //result = null;
			}
		}
    //return result;
	}

	static fetchStudentTodayTrip(String _id, String role_ID_level, String school_ID, String school_Br_ID, var authToken, var studentsPath, var isDirectionFromHomeToSchool, var endPoint) async {
				//var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint;
    //var url = productionHost + AuthUtils.endPoint;

    var jsonMap = {
      "User_ID": 		_id ,
      "Role_ID": role_ID_level,
      "Role_ID_Level": role_ID_level,
      "School_ID": school_ID,
      "School_Br_ID" : school_Br_ID,
      "StudentsPath" : studentsPath,
      "isDirectionFromHomeToSchool": isDirectionFromHomeToSchool
    };
    String jsonStr = jsonEncode(jsonMap);
    //print("jsonStr: " + jsonStr);
    //print("token: " + token);
    //var result;

		try {
			  final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			);
      if(response.body == 'Unauthorized'){
      print("********* responseJson: " + response.body);
      return response.body;
      //result = response.body;
      }
			//Future<List> responseJson = json.decode(response.body);
      //print("@@@@@@@@@ responseJson: " + response.body);
      //result = response.body;
			return json.decode(response.body);
      //return response.body;

		} catch (exception) {
			print("exception: " + exception.toString());
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
        //result = 'NetworkError';
			} else {
				return null;
        //result = null;
			}
		}
    //return result;
	}

	static fetchData(var endPoint) async {
				//var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint;
    //var url = productionHost + AuthUtils.endPoint;

    var jsonMap = {
      "User_ID": 		userId ,
      "Role_ID": roleIDstr,
      "Role_ID_Level": roleLevel,
      "School_ID": schoolID,
      "School_Br_ID" : schoolBrID
    };
    String jsonStr = jsonEncode(jsonMap);
    //print("jsonStr: " + jsonStr);
    //print("token: " + token);
    //var result;

		try {
			  final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			);
      if(response.body == 'Unauthorized'){
      print("********* responseJson: " + response.body);
      return response.body;
      //result = response.body;
      }
			//Future<List> responseJson = json.decode(response.body);
      print("@@@@@@@@@ responseJson: " + response.body);
      //result = response.body;
			return json.decode(response.body);
      //return response.body;

		} catch (exception) {
			print("exception: " + exception.toString());
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
        //result = 'NetworkError';
			} else {
				return null;
        //result = null;
			}
		}
    //return result;
	}

  static startTrip(String _id, String role_ID_level, String school_ID, String school_Br_ID, String trip_ID, String schedule_id, bool isDirectionFromHomeToSchool, var endPoint, var authToken) async {
				//var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint ;
    //var url = productionHost + AuthUtils.endPoint;
    print("startTrip: " + url);

    var jsonMap = {
      "User_ID": 		_id ,
      "Role_ID": role_ID_level,
      "School_ID": school_ID,
      "School_Br_ID" : school_Br_ID,
      "Trip_ID" : trip_ID, //"5c88868b1a72511ff82f9d5c",
      "_id" : schedule_id,
			"isDirectionFromHomeToSchool": isDirectionFromHomeToSchool
    };
    String jsonStr = jsonEncode(jsonMap);

		try {
			final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + authToken,
          'Content-Type': 'application/json'
				},
			);

			final responseJson = json.decode(response.body);
      print("responseJson: "+ response.body);
			return responseJson;

		} catch (exception) {
			print("changePassword exception:" + exception);
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

  //static studentsAbsent(String _id, String role_ID_level, String school_ID, String school_Br_ID, String student_ID, DateTime fromDate, DateTime toDate, var endPoint, var authToken) async {				
    static studentsAbsent(String student_ID, DateTime fromDate, DateTime toDate, var dayCount, var endPoint) async {				
        //var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint ;
    //var url = productionHost + AuthUtils.endPoint;
    print("studentsAbsent: " + url);

    var jsonMap = {
      "Created_by": 		userId, 
      //"Role_ID": roleIDstr,
      //"Role_ID_Level": roleLevel,
      "School_ID": schoolID,
      "School_Br_ID" : schoolBrID == null || schoolBrID == "" ? null: schoolBrID,
      "From_Date" : fromDate.toString(), 
      "To_Date" : toDate.toString(),
      "Day_Count" : dayCount,
      "Student_ID" : student_ID	
    };
    String jsonStr = jsonEncode(jsonMap);

    	var responseJson;
      //TODO: Testing
			//final response = await http.post(
        await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			).then((http.Response response) { 
          //print("********* responseJson222: "+ response.body);
        	responseJson = json.decode(response.body);    
          //responseJson = response.body;      
      }).catchError((onError){
          print("NetworkError: "+ onError.toString());
          responseJson = onError;
      });
      return responseJson;
	}

 static studentsClearAbsent(String student_ID, var absent_ID, var endPoint) async {				
        //var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint ;
    //var url = productionHost + AuthUtils.endPoint;
    print("studentsClearAbsent: " + url);
    print("absent_ID: " + absent_ID);

    var jsonMap = {
      "Created_by": 		userId, 
      //"Role_ID": roleIDstr,
      //"Role_ID_Level": roleLevel,
      //"School_ID": schoolID,
      //"School_Br_ID" : schoolBrID,      
      "Student_ID" : student_ID,
      "Absent_ID" : absent_ID
    };
    String jsonStr = jsonEncode(jsonMap);

    	var responseJson;
      //TODO: Testing
			//final response = await http.post(
        await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			).then((http.Response response) { 
          //print("********* responseJson333: "+ response.body);
        	responseJson = json.decode(response.body);    
          //responseJson = response.body;      
      }).catchError((onError){
          print("NetworkError: "+ onError.toString());
          responseJson = onError;
      });
      return responseJson;
	}


    static sendNotification(String type, String guardians_orTrip_ID, String value, String msgRoute, var endPoint) async {				
        //var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint ;
    //var url = productionHost + AuthUtils.endPoint;
    print("Send Notification: " + url);
    var msgtype = "";
    if(type == 'direct') msgtype = "Receiver"  ;
     else if(type == 'trip') msgtype = "tripID"; 
     else if(type == 'school') msgtype = "To_School_ID";
     else if(type == 'schoolBr') msgtype = "To_School_Br_ID";
    var jsonMap = {
      "User_ID" : userId,
      "Type" : type,
      "Role_ID": roleIDstr,
      "Role_ID_Level": roleLevel,
      "School_ID": schoolID,
      "School_Br_ID" : schoolBrID,
      //"To_School_ID": toSchoolID,
      //"To_School_Br_ID" : toSchoolBrID,
      msgtype : guardians_orTrip_ID,
      "Content" : value,
      "Created_by": userId, 
    };
    String jsonStr = jsonEncode(jsonMap);
    print("jsonStr: "+ jsonStr);

		try {
      //TODO: Testing
			//final response = await http.post(
        await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			).then((http.Response response) { 
        	var responseJson = json.decode(response.body);
          print("responseJson: "+ response.body);
			    return responseJson;
      }).catchError((onError){
          print("NetworkError: "+ onError.toString());
          return 'NetworkError';
      });
		
      return 'NetworkError';
		} catch (exception) {
			print("changePassword exception:" + exception);
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

    static sendComplaint(String subject, String body, String toUserID, String replyforID, int statusMarker, var endPoint) async {				
          //var url = host + AuthUtils.endPoint;
      var url = developmentHost + endPoint ;
      //var url = productionHost + AuthUtils.endPoint;
      print("Send Complaint: " + url);      
      var jsonMap = {
        "Subject" : subject,
        "Body" : body,
        "User_ID" : userId,
        "to_User_ID" : toUserID,
        //"Reply_for_ID" : replyforID ==null || replyforID == "" ? null: replyforID,         
        "School_ID": schoolID,
        "School_Br_ID" : schoolBrID ==null || schoolBrID =="null" || schoolBrID == "" ? null: schoolBrID,
        "IMEI" : null,
        "Status_Marker" : statusMarker        
      };
      String jsonStr = jsonEncode(jsonMap);
      //print("NNNNNNNN schoolBrID: "+ jsonStr);

      try {
        //TODO: Testing
        //final response = await http.post(
          await http.post(
          Uri.encodeFull(url),
          body: jsonStr , 
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          },
        ).then((http.Response response) { 
            var responseJson = json.decode(response.body);
            print("NNNNNNNN responseJson: "+ response.body);
            return responseJson;
        }).catchError((onError){
            print("NNNNNNNN NetworkError: "+ onError.toString());
            return 'NetworkError';
        });
      
        return 'NetworkError';
      } catch (exception) {
        print("NNNNNNNN Complaint exception:" + exception);
        if(exception.toString().contains('SocketException')) {
          return 'NetworkError';
        } else {
          return null;
        }
      }
	}


	static fetchNotificationData(var endPoint) async {
				//var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint;
    //var url = productionHost + AuthUtils.endPoint;    
    //TODO: Supervisor search in Trip.supervisor.

    var jsonMap = {
      "User_ID": 		userId,
      "Role_ID": roleIDstr,
      "Role_ID_Level" : roleLevel,
      "School_ID": schoolID,
      "School_Br_ID" : schoolBrID,
      "Trip_ID" : tripID,
      "Guardians_ID" : userId      
    };
    String jsonStr = jsonEncode(jsonMap);
    //print("jsonStr: " + jsonStr);

		try {
			final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			);
      //print("######### fetchNotificationData responseJson: " + response.body);

			//Future<List> responseJson = json.decode(response.body);
      //print("responseJson: " + response.body);
			return json.decode(response.body);
      //return response.body;

		} catch (exception) {
			print("exception: " + exception.toString());
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

  static fetchComplaintData(var endPoint) async {
            //var url = host + AuthUtils.endPoint;
        var url = developmentHost + endPoint;
        //var url = productionHost + AuthUtils.endPoint;          

        var jsonMap = {
          "User_ID": 		userId,
          "Role_ID": roleIDstr,
          "Role_ID_Level" : roleLevel,
          "School_ID": schoolID,
          "School_Br_ID" : schoolBrID          
        };
        String jsonStr = jsonEncode(jsonMap);
        //print("jsonStr: " + jsonStr);

        try {
          final response = await http.post(
            Uri.encodeFull(url),
            body: jsonStr , 
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json'
            },
          );
          //print("######### fetchComplaintData responseJson: " + response.body);

          //Future<List> responseJson = json.decode(response.body);
          //print("responseJson: " + response.body);
          return json.decode(response.body);
          //return response.body;

        } catch (exception) {
          print("exception: " + exception.toString());
          if(exception.toString().contains('SocketException')) {
            return 'NetworkError';
          } else {
            return null;
          }
        }
	}

  static fetchEmergencyData(var endPoint) async {
            //var url = host + AuthUtils.endPoint;
        var url = developmentHost + endPoint;
        //var url = productionHost + AuthUtils.endPoint;          

        var jsonMap = {
          "User_ID": 		userId,
          "Role_ID": roleIDstr,
          "Role_ID_Level" : roleLevel,
          "School_ID": schoolID,
          "School_Br_ID" : schoolBrID          
        };
        String jsonStr = jsonEncode(jsonMap);
        print("jsonStr: " + jsonStr);

        try {
          final response = await http.post(
            Uri.encodeFull(url),
            body: jsonStr , 
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json'
            },
          );
          //print("######### fetchComplaintData responseJson: " + response.body);

          //Future<List> responseJson = json.decode(response.body);
          //print("responseJson: " + response.body);
          return json.decode(response.body);
          //return response.body;

        } catch (exception) {
          print("exception: " + exception.toString());
          if(exception.toString().contains('SocketException')) {
            return 'NetworkError';
          } else {
            return null;
          }
        }
	}

static fetchAdvertisementData(var endPoint) async {
            //var url = host + AuthUtils.endPoint;
        var url = developmentHost + endPoint;
        //var url = developmentHost + '/Advertisements/upload';
        //var url = productionHost + AuthUtils.endPoint;          

        var jsonMap = {
          "User_ID": 		userId,
          "Role_ID": roleIDstr,
          "Role_ID_Level" : roleLevel,
          "School_ID": schoolID,
          "School_Br_ID" : schoolBrID,
          "request": "fetchp"
        };
        String jsonStr = jsonEncode(jsonMap);
        print("jsonStr: " + jsonStr);

        try {
          final response = await http.post(
            Uri.encodeFull(url),
            body: jsonStr , 
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json'
            },
          );
          //print("######### fetchComplaintData responseJson: " + response.body);

          //Future<List> responseJson = json.decode(response.body);
          //print("responseJson: files: " + response.body);
          var res = json.decode(response.body);
          //print("res: " + res.toString());
          //if(res['success'] == true){
            //res['filenames'].forEach((element) => _advertisementList.add( developmentHost +  '/uploads/' + element));          
            //_advertisementList.forEach((f) => print(f));
          //}
          return res;
          //return response.body;

        } catch (exception) {
          print("exception: " + exception.toString());
          if(exception.toString().contains('SocketException')) {
            return 'NetworkError';
          } else {
            return null;
          }
        }
	}

	static fetchStudentsWithAbsent(var endPoint) async {
				//var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint;
    //var url = productionHost + AuthUtils.endPoint;

    var jsonMap = {
      "User_ID": 		userId ,
      "Role_ID": roleLevel,
      "School_ID": schoolID,
      "School_Br_ID" : schoolBrID,
      "StudentsPath" : "Guardians_ID",
      "isDirectionFromHomeToSchool": true
    };
    String jsonStr = jsonEncode(jsonMap);
    //print("jsonStr: " + jsonStr);
    //print("authToken: " + authToken);

		try {
			final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			);
      if(response.body == 'Unauthorized'){
      print("*************** responseJson: " + response.body);
      return response.body;
      }
			//Future<List> responseJson = json.decode(response.body);
      //print("responseJson: " + response.body);
			return json.decode(response.body);
      //return response.body;

		} catch (exception) {
			print("exception: " + exception.toString());
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

static fetchSchoolScheduleData(var endPoint) async {
				//var url = host + AuthUtils.endPoint;
    var url = developmentHost + endPoint;
    //var url = productionHost + AuthUtils.endPoint;    
    //TODO: Supervisor search in Trip.supervisor.

    var jsonMap = {
      "User_ID": 		userId,
      "Role_ID": roleIDstr,
      "Role_ID_Level" : roleLevel,
      "School_ID": schoolID,
      "School_Br_ID" : schoolBrID      
    };
    String jsonStr = jsonEncode(jsonMap);
    //print("jsonStr: " + jsonStr);

		try {
			final response = await http.post(
				 Uri.encodeFull(url),
        body: jsonStr , 
				headers: {
					'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
				},
			);
      //print("######### fetchNotificationData responseJson: " + response.body);

			//Future<List> responseJson = json.decode(response.body);
      //print("responseJson: " + response.body);
			//return json.decode(response.body);
      return response.body;

		} catch (exception) {
			print("exception: " + exception.toString());
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}


    static sendParentAddStudent(String guardiansID, String studentID, String birthDate, var endPoint) async {				
          //var url = host + AuthUtils.endPoint;
      var url = developmentHost + endPoint ;
      //var url = productionHost + AuthUtils.endPoint;
      print("Send sendParentAddStudent: " + url);      
      var jsonMap = {
        "Guardians_ID" : guardiansID,
        "Student_ID" : studentID,
        "User_ID" : userId,
        "birthDate" : birthDate,           
        "School_ID": schoolID,
        "School_Br_ID" : schoolBrID ==null || schoolBrID =="null" || schoolBrID == "" ? null: schoolBrID,          
      };
      String jsonStr = jsonEncode(jsonMap);
      //print("NNNNNNNN schoolBrID: "+ jsonStr);

      try {
        //TODO: Testing
        //final response = await http.post(
         await http.post(
          Uri.encodeFull(url),
          body: jsonStr , 
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          },
        ).then((http.Response response) { 
            var responseJson = json.decode(response.body);
            print("NNNNNNNN responseJson: "+ response.body);
            return responseJson;
        }).catchError((onError){
            print("NNNNNNNN NetworkError: "+ onError.toString());
            return 'NetworkError';
        });
      
        return 'NetworkError';
      } catch (exception) {
        print("NNNNNNNN Complaint exception:" + exception);
        if(exception.toString().contains('SocketException')) {
          return 'NetworkError';
        } else {
          return null;
        }
      }
	}


    static tripRating(String tripID, double rating, var endPoint) async {				
          //var url = host + AuthUtils.endPoint;
      var url = developmentHost + endPoint ;
      //var url = productionHost + AuthUtils.endPoint;
      //print("Send tripRating: " + url); 
      var result;     
      var jsonMap = {        
        "User_ID" : userId,        
        "School_ID": schoolID,
        "School_Br_ID" : schoolBrID ==null || schoolBrID =="null" || schoolBrID == "" ? null: schoolBrID,          
        "ScheduleTrip_ID" : tripID,
        "Rating" : rating
      };
      String jsonStr = jsonEncode(jsonMap);
      //print("NNNNNNNN schoolBrID: "+ jsonStr);

      try {
        //TODO: Testing
        //final response = await http.post(
         await http.post(
          Uri.encodeFull(url),
          body: jsonStr , 
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          },
        ).then((http.Response response) { 
            var responseJson = json.decode(response.body);
            //print("NNNNNNNN responseJson: "+ response.body);
            result = responseJson;
        }).catchError((onError){
            print("NNNNNNNN NetworkError: "+ onError.toString());
            result = 'NetworkError';
        });
      
        //return 'NetworkError';
      } catch (exception) {
        print("NNNNNNNN tripDriverRating exception:" + exception);
        if(exception.toString().contains('SocketException')) {
          result = 'NetworkError';
        } else {
          result = null;
        }
      }
      return result;
	} 

  static tripSupervisorRating(String tripID, String supervisorID, double rating, var endPoint) async {				
          //var url = host + AuthUtils.endPoint;
      var url = developmentHost + endPoint ;
      //var url = productionHost + AuthUtils.endPoint;
      //print("Send tripRating: " + url); 
      var result;     
      var jsonMap = {        
        "User_ID" : userId,        
        "School_ID": schoolID,
        "School_Br_ID" : schoolBrID ==null || schoolBrID =="null" || schoolBrID == "" ? null: schoolBrID,          
        "ScheduleTrip_ID" : tripID,
        "Rating" : rating
      };
      String jsonStr = jsonEncode(jsonMap);
      //print("NNNNNNNN schoolBrID: "+ jsonStr);

      try {
        //TODO: Testing
        //final response = await http.post(
         await http.post(
          Uri.encodeFull(url),
          body: jsonStr , 
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          },
        ).then((http.Response response) { 
            var responseJson = json.decode(response.body);
            //print("NNNNNNNN responseJson: "+ response.body);
            result = responseJson;
        }).catchError((onError){
            print("NNNNNNNN NetworkError: "+ onError.toString());
            result = 'NetworkError';
        });
      
        //return 'NetworkError';
      } catch (exception) {
        print("NNNNNNNN tripDriverRating exception:" + exception);
        if(exception.toString().contains('SocketException')) {
          result = 'NetworkError';
        } else {
          result = null;
        }
      }
      return result;
	} 

 static saveAttendance(String tripID, String waypointListID, String param, String paramValue, var endPoint) async {				
          //var url = host + AuthUtils.endPoint;
      var url = developmentHost + endPoint ;
      //var url = productionHost + AuthUtils.endPoint;
      //print("Send tripRating: " + url); 
      var result;     
      var jsonMap = {        
        "User_ID" : userId,        
        "School_ID": schoolID,
        "School_Br_ID" : schoolBrID ==null || schoolBrID =="null" || schoolBrID == "" ? null: schoolBrID,          
        "ScheduleTrip_ID" : tripID,
        "WaypointList_ID" : waypointListID,
        "param": param,
        "paramValue": paramValue
      };
      String jsonStr = jsonEncode(jsonMap);
      print("NNNNNNNN jsonStr: "+ jsonStr);

      try {
        //TODO: Testing
        //final response = await http.post(
         await http.post(
          Uri.encodeFull(url),
          body: jsonStr , 
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          },
        ).then((http.Response response) { 
            var responseJson = json.decode(response.body);
            //print("NNNNNNNN responseJson: "+ response.body);
            result = responseJson;
        }).catchError((onError){
            print("NNNNNNNN NetworkError: "+ onError.toString());
            result = 'NetworkError';
        });
      
        //return 'NetworkError';
      } catch (exception) {
        print("NNNNNNNN tripDriverRating exception:" + exception);
        if(exception.toString().contains('SocketException')) {
          result = 'NetworkError';
        } else {
          result = null;
        }
      }
      return result;
	}


}