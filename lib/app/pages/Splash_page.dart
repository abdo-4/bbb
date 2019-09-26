import 'dart:async';

import 'package:bus_tracker/app/pages/home_page.dart';
import 'package:bus_tracker/app/pages/login_page.dart';
import 'package:bus_tracker/app/utils/auth_utils.dart';
//import 'package:bus_tracker/app/pages/UserRegister_page.dart';
import 'package:bus_tracker/app/pages/UpdateVersion.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
//import 'package:bus_tracker/app/validators/email_validator.dart';
//import 'package:bus_tracker/app/components/error_box.dart';
//import 'package:bus_tracker/app/components/Logo_Box.dart';
//import 'package:bus_tracker/app/components/username_field.dart';
//import '../components/username_field.dart';
//import 'package:bus_tracker/app/components/password_field.dart';
//import 'package:bus_tracker/app/components/login_button.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import './UserRegister.dart';
//import 'package:bus_tracker/app/utils/TranslateStrings.dart';
//import '../Socketio/socketIoManager.dart' as sockets;
import 'package:bus_tracker/app/Socketio/socketIoManager.dart' as sockets;
//import '../utils/GlobalIDs.dart';
import 'package:bus_tracker/app/components/LoadScreenWidget.dart';

//import 'package:bus_tracker/app/Internationalization/I10n/messages_all.dart';
//import 'package:bus_tracker/app/Internationalization/scope_model_wrapper.dart';
//import 'package:bus_tracker/app/Internationalization/translation_strings.dart';
//import 'package:scoped_model/scoped_model.dart';

import 'package:bus_tracker/app/states/App_MapState.dart';
import 'package:provider/provider.dart';


class SplashPage extends StatefulWidget {
  static final String routeName = 'Splash';
  @override
  SplashPageState createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  //bool _isError = false;
  //bool _obscureText = true;
  //bool _isLoading = false;
  //TextEditingController _usernameController, _passwordController;
  //String _errorText, _usernameError, _passwordError;
  String appName= 'Saleem App', currentVersion = '3.0.0';

  @override
  void initState() {
    super.initState();    
    //_usernameController = new TextEditingController();
    ///_passwordController = new TextEditingController();
  }

  _fetchSessionAndNavigate() async {
    try{
      print("Sppppppppppppp 2 ");
    _sharedPreferences = await _prefs;
    String authToken = await AuthUtils.getToken(_sharedPreferences);
    //GlobalIDs.token = authToken;
    //GlobalIDs.roleIDstr = _sharedPreferences.getString(AuthUtils.roleIDKey);
    //GlobalIDs.roleLevel = _sharedPreferences.getInt(AuthUtils.roleLevelKey);
    //GlobalIDs.userId = _sharedPreferences.getString(AuthUtils.userIdKey);
    //GlobalIDs.username = _sharedPreferences.getString(AuthUtils.nameKey);
    //GlobalIDs.password = _sharedPreferences.getString(AuthUtils.passwordKey);
    //GlobalIDs.email = _sharedPreferences.getString(AuthUtils.emailKey);
    //GlobalIDs.schoolID = _sharedPreferences.getString(AuthUtils.schoolIDKey);
    //GlobalIDs.schoolBrID = _sharedPreferences.getString(AuthUtils.schoolBrIDKey);

    //SocketIOClass.connectSocket01(authToken, _sharedPreferences.getString(AuthUtils.roleIDKey), _sharedPreferences.getInt(AuthUtils.roleLevelKey),
    //_sharedPreferences.getString(AuthUtils.userIdKey),  _sharedPreferences.getString(AuthUtils.nameKey),  _sharedPreferences.getString(AuthUtils.passwordKey),
    //_sharedPreferences.getString(AuthUtils.emailKey),  _sharedPreferences.getString(AuthUtils.schoolIDKey),  _sharedPreferences.getString(AuthUtils.schoolBrIDKey));
try{
print("Token:" + authToken.toString());
}catch(e) { print("Token err: " + e.toString());}
	//print("roleIDKey:" +  _sharedPreferences.getString(AuthUtils.roleIDKey).toString()); 
    //print("TroleLevelKeyoken:" +  _sharedPreferences.getInt(AuthUtils.roleLevelKey).toString());
    //print("userIdKey:" + _sharedPreferences.getString(AuthUtils.userIdKey));

    //print("Token:" + authToken);
      //print("Sppppppppppppp 3 ");
    if (authToken.toString() != "null") {
      print("********************  auto Splash ***************");
      //print("Sppppppppppppp 4 ");
      _handleConnection(authToken);

      var updateVersion = await NetworkUtils.fetchAppVersion(appName, currentVersion, '/AppManager/version');  

      if(updateVersion == false){
        //setState(() { goToPage = UpdateVersionPage.routeName;    });
        Navigator.of(_scaffoldKey.currentContext).pushReplacementNamed(UpdateVersionPage.routeName);
        print("Sppppppppppppp 9 goto Update Version Page");
      } else { // if(updateVersion == true) {
        //setState(() { goToPage = HomePage.routeName;     });
        Navigator.of(_scaffoldKey.currentContext).pushReplacementNamed(HomePage.routeName);
        print("Sppppppppppppp 8 goto Home Page");
      }
      
    }else{
      //print("Sppppppppppppp 5 ");
      //setState(() {    goToPage = LoginPage.routeName;     });
       Navigator.of(_scaffoldKey.currentContext).pushReplacementNamed(LoginPage.routeName);
       print("Sppppppppppppp 7 goto Login page");
    }
    }catch(e){print("Sppppppppppppp 1, " + e.toString());}
    print("Sppppppppppppp 6 ");
  }

String goToPage = "";

_handleConnection(String authToken){
  print("3333333333333333333333333333333333333333333333333333333333333333333 begin _handleConnection Splash_page.dart");
  try{
//sockets.SocketIOClass.connectSocket01(
        sockets.SocketIOClass().connectSocket01(
          authToken,
          _sharedPreferences.getString(AuthUtils.roleIDKey),
          _sharedPreferences.getInt(AuthUtils.roleLevelKey),
          _sharedPreferences.getString(AuthUtils.userIdKey),
          _sharedPreferences.getString(AuthUtils.nameKey),
          _sharedPreferences.getString(AuthUtils.emailKey),
          _sharedPreferences.getString(AuthUtils.schoolIDKey).toString(),
          _sharedPreferences.getString(AuthUtils.schoolBrIDKey).toString(),
          _sharedPreferences.getString(AuthUtils.tripIDKey).toString());
      print("@@@@@@ test4");
      NetworkUtils.initValues(
          authToken,
          _sharedPreferences.getString(AuthUtils.roleIDKey),
          _sharedPreferences.getInt(AuthUtils.roleLevelKey),
          _sharedPreferences.getString(AuthUtils.userIdKey),
          _sharedPreferences.getString(AuthUtils.nameKey),
          _sharedPreferences.getString(AuthUtils.emailKey),
          _sharedPreferences.getString(AuthUtils.schoolIDKey).toString(),
          _sharedPreferences.getString(AuthUtils.schoolBrIDKey).toString(),
          _sharedPreferences.getString('sCNameAr'),
          _sharedPreferences.getString('scPhone').toString(),
          _sharedPreferences.getString('scImg').toString(),
          _sharedPreferences.getString('scContent').toString(),
          _sharedPreferences.getString('sCmanagerName').toString(),
          _sharedPreferences.getString('scManagerContact').toString());
  }catch(e){ NetworkUtils.showSnackBar(_scaffoldKey, e.toString());}

  var appMapState = Provider.of<AppMapState>(context);
    print("AppMapState _handleConnection Splash_page.dart");
    appMapState.setInitValues(_sharedPreferences.getString(AuthUtils.nameKey), _sharedPreferences.getString(AuthUtils.userIdKey), 
    _sharedPreferences.getString(AuthUtils.schoolIDKey).toString(), _sharedPreferences.getString(AuthUtils.schoolBrIDKey).toString(),
    authToken, _sharedPreferences.getInt(AuthUtils.roleLevelKey) == 5 ? true: false, _sharedPreferences.getInt(AuthUtils.roleLevelKey));     
    print("3333333333333333333333333333333333333333333333333333333333333333333 End _handleConnection Splash_page.dart");

}

/*
  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }


  _loadingSplashScreenWidget(){
    loadingScreenWidget();
    _fetchSessionAndNavigate();
  }*/

/*
_homePageScreen(){
          /**
           * Removes stack and start with the new page.
           * In this case on press back on HomePage app will exit.
           * **/
          Navigator.of(_scaffoldKey.currentContext)
              .pushReplacementNamed(HomePage.routeName);
}*/

  @override
  Widget build(BuildContext context) {
    _fetchSessionAndNavigate();
    return new Scaffold(
        key: _scaffoldKey,
        //body: _isLoading ? _loadingSplashScreenWidget() : _homePageScreen());
        backgroundColor: Colors.pink[200],
        body: loadingScreenWidget(),
        /*body: goToPage == "" ? loadingScreenWidget(): 
        Navigator.of(_scaffoldKey.currentContext)
              .pushReplacementNamed(goToPage)*/
        );
  }
}
