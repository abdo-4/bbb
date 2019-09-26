import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // abdo added

//import '../Socketio/socketIoManager.dart' as sockets;
import 'package:bus_tracker/app/utils/network_utils.dart';

import 'package:bus_tracker/app/Socketio/socketIoManager.dart';

class AuthUtils {

	static final String endPoint = '/Users/auth';
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

	// Keys to store and fetch data from SharedPreferences
	static final String authTokenKey = 'Auth_token';
	static final String userIdKey = 'User_id';
	static final String nameKey = 'User_Name';
  //static final String passwordKey = 'Password';
	static final String roleIDKey = 'Role_ID'; 
  static final String roleLevelKey = 'Role_ID_Level'; 
  static final String emailKey = 'Email';
  static final String schoolIDKey = 'School_ID';
  static final String schoolBrIDKey = 'School_Br_ID';
  static final String tripIDKey = 'Trip_ID';
  //static final String scManagerContact = 'Sc_Manager_Contact';
  SharedPreferences _sharedPreferences;

 Map userIDs = {
    //"authTokenKey" : 'Auth_token',
    //"userIdKey" : 'User_id',
    //"nameKey" : 'User_Name',
    //"roleKey" : 'Role_ID',
    //"emailKey" : 'Email',
    //"schoolIDKey" : 'School_ID',
    //"schoolBrIDKey" : 'School_Br_ID'
  };

AuthUtils()
{
  _fetchSessionAndNavigate();
}

	static String getToken(SharedPreferences prefs) {
		return prefs.getString(authTokenKey);
	}
  
  Map getIDs_old(SharedPreferences prefs)
  {
     try {
       print("getIDs userIDs");
    Map userIDs;
    userIDs['Auth_token'] = prefs.getString(AuthUtils.authTokenKey);
    userIDs['Role_ID'] = prefs.getString(AuthUtils.roleIDKey); 
    userIDs['Role_ID_Level'] = prefs.getInt(AuthUtils.roleLevelKey);
    userIDs['User_id'] = prefs.getString(AuthUtils.userIdKey);
    userIDs['User_Name'] = prefs.getString(AuthUtils.nameKey);
    //userIDs['Password'] = prefs.getString(AuthUtils.passwordKey);    
    userIDs['Email'] = prefs.getString(AuthUtils.emailKey);
    userIDs['School_ID'] = prefs.getString(AuthUtils.schoolIDKey);
    userIDs['School_Br_ID'] = prefs.getString(AuthUtils.schoolBrIDKey);    
    userIDs['Trip_ID'] = prefs.getString(AuthUtils.tripIDKey);  
    userIDs['SC_Name_ar'] = prefs.getString('sCNameAr'); 
    userIDs['Sc_Phone'] = prefs.getString('scPhone'); 
    userIDs['Sc_Img'] = prefs.getString('scImg'); 
    //userIDs['scCssImg'] = prefs.getString('scCssImg'); 
    userIDs['Sc_Content'] = prefs.getString('scContent');
    userIDs['SC_manager_Name'] = prefs.getString('sCmanagerName'); 
    userIDs['Sc_Manager_Contact'] = prefs.getString('scManagerContact');
    //userIDs['Sc_manager_Email'] = prefs.getString('Sc_manager_Email');
    //userIDs['Sc_Address_ar'] = prefs.getString('Sc_Address_ar');
    

    //sockets.SocketIOClass.initValues(userIDs['token'], userIDs['Role_ID'], userIDs['roleLevelKey'],userIDs['id'], userIDs['Name'], 
//userIDs['Email'], userIDs['School_ID'], userIDs['School_Br_ID'], userIDs['Trip_ID']);

print("@@@@@@ test1");
NetworkUtils.initValues(userIDs['token'], userIDs['Role_ID'], userIDs['roleLevelKey'],userIDs['id'], userIDs['Name'], 
userIDs['Email'], userIDs['School_ID'], userIDs['School_Br_ID'],
userIDs['SC_Name_ar'], userIDs['Sc_Phone'], userIDs['Sc_Img'], userIDs['Sc_Content'],
userIDs['SC_manager_Name'], userIDs['Sc_Manager_Contact']);

    //GlobalIDs.token = userIDs['Auth_token'];
    //GlobalIDs.roleIDstr = userIDs['Role_ID'];
    //GlobalIDs.roleLevel = userIDs['Role_ID_Level'];
    //GlobalIDs.userId = userIDs['User_id'];
    //GlobalIDs.username = userIDs['User_Name'];
    //GlobalIDs.password = userIDs['Password'];
    //GlobalIDs.email = userIDs['Email'];
    //GlobalIDs.schoolID = userIDs['School_ID'];
    //GlobalIDs.schoolBrID = userIDs['School_Br_ID'];
    ////GlobalIDs. = userIDs['Auth_token'];

    print("getIDs userIDs: " + userIDs['User_id'].toString());
     } catch (exception) {
        print("getIDs exception: " + exception);
     }

    return userIDs;
  }

    _fetchSessionAndNavigate() async {
      
      	  try {
    _sharedPreferences = await _prefs;
    userIDs['Auth_token'] = AuthUtils.getToken(_sharedPreferences);
    userIDs['Role_ID'] = _sharedPreferences.getInt(AuthUtils.roleIDKey);
    userIDs['Role_ID_Level'] = _sharedPreferences.getString(AuthUtils.roleLevelKey);
    userIDs['User_id'] = _sharedPreferences.getString(AuthUtils.userIdKey);
    userIDs['User_Name'] = _sharedPreferences.getString(AuthUtils.nameKey);
    //userIDs['Password'] = _sharedPreferences.getString(AuthUtils.passwordKey);    
    userIDs['Email'] = _sharedPreferences.getString(AuthUtils.emailKey);
    userIDs['School_ID'] = _sharedPreferences.getString(AuthUtils.schoolIDKey);
    userIDs['School_Br_ID'] = _sharedPreferences.getString(AuthUtils.schoolBrIDKey);    
    userIDs['Trip_ID'] = _sharedPreferences.getString(AuthUtils.tripIDKey);  
    userIDs['SC_Name_ar'] = _sharedPreferences.getString('sCNameAr'); 
    userIDs['Sc_Phone'] = _sharedPreferences.getString('scPhone'); 
    userIDs['Sc_Img'] = _sharedPreferences.getString('scImg'); 
    //userIDs['scCssImg'] = _sharedPreferences.getString('scCssImg'); 
    userIDs['Sc_Content'] = _sharedPreferences.getString('scContent');
    userIDs['SC_manager_Name'] = _sharedPreferences.getString('sCmanagerName');
    userIDs['Sc_Manager_Contact'] = _sharedPreferences.getString('scManagerContact');

    //sockets.SocketIOClass.initValues(userIDs['token'], userIDs['Role_ID'], userIDs['roleLevelKey'],userIDs['id'], userIDs['Name'], 
//userIDs['Email'], userIDs['School_ID'], userIDs['School_Br_ID'], userIDs['Trip_ID']);

SocketIOClass().initValues(userIDs['token'], userIDs['Role_ID'], userIDs['roleLevelKey'],userIDs['id'], userIDs['Name'], 
userIDs['Email'], userIDs['School_ID'], userIDs['School_Br_ID'], userIDs['Trip_ID']);

print("@@@@@@ test2");
NetworkUtils.initValues(userIDs['token'], userIDs['Role_ID'], userIDs['roleLevelKey'],userIDs['id'], userIDs['Name'], 
userIDs['Email'], userIDs['School_ID'], userIDs['School_Br_ID'],
userIDs['SC_Name_ar'], userIDs['Sc_Phone'], userIDs['Sc_Img'], userIDs['Sc_Content'],
userIDs['SC_manager_Name'], userIDs['Sc_Manager_Contact']);

    //GlobalIDs.token = userIDs['Auth_token'];
    //GlobalIDs.roleIDstr = userIDs['Role_ID'];
    //GlobalIDs.roleLevel = userIDs['Role_ID_Level'];
    //GlobalIDs.userId = userIDs['User_id'];
    //GlobalIDs.username = userIDs['User_Name'];
    //GlobalIDs.password = userIDs['Password'];
    //GlobalIDs.email = userIDs['Email'];
    //GlobalIDs.schoolID = userIDs['School_ID'];
    //GlobalIDs.schoolBrID = userIDs['School_Br_ID'];
    ////GlobalIDs. = userIDs['Auth_token'];

    //print(" ************ userIDs: " + userIDs.toString());
     } catch (exception) {
        print("_fetchSessionAndNavigate exception: " + exception);
     }

    return userIDs;
  
    }

	
  insertDetails2(var response) {
    insertDetails(_sharedPreferences, response);
  }

	static insertDetails(SharedPreferences prefs, var response) {
    print("auth_utils line 24 reponse:" + json.encode(response));
    if(response['success'] == true)
    {
		  prefs.setString(authTokenKey, response['token']);
		  var user = response['user'];
		  prefs.setString(roleIDKey, user['Role_ID']['_id']);
      prefs.setInt(roleLevelKey, user['Role_ID']['Role_ID']);
		  prefs.setString(userIdKey, user['id']);
      prefs.setString(nameKey, user['Name']);
      //prefs.setString(passwordKey, user['Password']);
      prefs.setString(emailKey, user['Email']);
      prefs.setString(schoolIDKey, user['School_ID']['_id']);
      prefs.setString(schoolBrIDKey, user['School_Br_ID'] != null ? user['School_Br_ID']['_id'] : null);
      //prefs.setString(tripIDKey, user['Trip_ID']);
      prefs.setString('sCNameAr', user['School_ID']['SC_Name_ar']);
      prefs.setString('scPhone', user['School_ID']['Sc_Phone']);
      prefs.setString('scImg', user['School_ID']['Sc_Img']);
      //prefs.setString('scCssImg', user['School_ID']['Sc_CssImg']);
      prefs.setString('scContent', user['School_ID']['Sc_Content']);
      prefs.setString('sCmanagerName', user['School_ID']['SC_manager_Name']);
      prefs.setString('scManagerContact', user['School_ID']['Sc_Manager_Contact']);

//sockets.SocketIOClass.connectSocket01(response['token'], user['Role_ID']['_id'], user['Role_ID']['Role_ID'],user['id'], user['Name'], 
//user['Email'], user['School_ID']['_id'], user['School_Br_ID'] != null ? user['School_Br_ID']['_id'] : null, "");

SocketIOClass().connectSocket01(response['token'], user['Role_ID']['_id'], user['Role_ID']['Role_ID'],user['id'], user['Name'], 
user['Email'], user['School_ID']['_id'], user['School_Br_ID'] != null ? user['School_Br_ID']['_id'] : null, "");

print("@@@@@@ test3");
//TODO: Testing
NetworkUtils.initValues(response['token'], user['Role_ID']['_id'], user['Role_ID']['Role_ID'],user['id'], user['Name'], 
user['Email'], user['School_ID']['_id'], user['School_Br_ID'] != null ? user['School_Br_ID']['_id'] : null,
user['School_ID']['SC_Name_ar'], user['School_ID']['Sc_Phone'], user['School_ID']['Sc_Img'], user['School_ID']['Sc_Content'],
user['School_ID']['SC_manager_Name'], user['School_ID']['Sc_Manager_Contact']);

    //GlobalIDs.token = response['token'];
    //GlobalIDs.roleIDstr = user['Role_ID'];
    //GlobalIDs.roleLevel = user[roleLevelKey];
    //GlobalIDs.userId = user['id'];
    //GlobalIDs.username = user['Name'];
    //GlobalIDs.password = user['Password'];
    //GlobalIDs.email = user['Email'];
    //GlobalIDs.schoolID = user['School_ID'];
    //GlobalIDs.schoolBrID = user['School_Br_ID'];
    
    //GlobalIDs. = userIDs['Auth_token'];

      //if(user[roleLevelKey] != 0)
      //{
      //  if(user['School_ID'] != null)
      //          {prefs.setString(schoolIDKey, user['School_ID']);
     //           GlobalIDs.schoolID = user['School_ID'];}
      //  if(user['School_Br_ID'] != null)
      //          {prefs.setString(schoolBrIDKey, user['School_Br_ID']);
      //          GlobalIDs.schoolBrID = user['School_Br_ID'];}
      //}
      //print(" role_id: " + user[roleKey]);
      print(" _id " + user['id']);
     
      print(" Name " +user['Name']);
      
      print("insertDetails auth_utils reponse: Seccus");
      //print("GlobalIDs: " + GlobalIDs.iDs());

      //SocketIOClass.connectSocket02();
    }
	}

/*
response json:

{success: true, 
message: You can login now, 
user: {Name: sedco, Email: sedco&sedco.com, Role_ID: 0, School_ID: 5c65be89b16a061a601a2428, id: 5c66febe2e326a2ec42c2eb1}, 
token:
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjVjNjZmZWJlMmUzMjZhMmVjNDJjMmViMSIsIk5hbWUiOiJzZWRjbyIsInVzZXJuYW1lIjoic2VkY28iLCJwYXNzd29yZCI6IiQyYSQxMCRXUDdHaUhaWXZvQ01Dcy85dlh5MVZ1UjlkQ2hvUm
JaaWs1RGlvazlWT0RrVkxVV0tJLmpmQyIsIkVtYWlsIjoic2VkY28mc2VkY28uY29tIiwiUm9sZV9JRCI6MCwiUmVnX0lEIjoiMCIsIlN0YXR1cyI6dHJ1ZSwiU2Nob29sX0lEIjoiNWM2NWJlODliMTZhMDYxYTYwMWEyNDI4IiwiQ3JlYXRlZF9ieSI6IlN5c3RlbSIsI
l9fdiI6MH0sImlhdCI6MTU1MTA2NDE5OSwiZXhwIjoxNTUxNjY4OTk5fQ.c87YTYPupPcEeat5zl0TgI3Mpl0JVnkdlbaSFhu05-c}
*/


}