import 'dart:async';

import 'package:bus_tracker/app/pages/home_page.dart';
import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:bus_tracker/app/pages/UserRegister_page.dart';
import 'package:bus_tracker/app/pages/UpdateVersion.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
//import 'package:bus_tracker/app/validators/email_validator.dart';
//import 'package:bus_tracker/app/components/error_box.dart';
import 'package:bus_tracker/app/components/Logo_Box.dart';
//import 'package:bus_tracker/app/components/username_field.dart';
import '../components/username_field.dart';
import 'package:bus_tracker/app/components/password_field.dart';
import 'package:bus_tracker/app/components/login_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import './UserRegister.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';
//import '../Socketio/socketIoManager.dart' as sockets;
import 'package:bus_tracker/app/Socketio/socketIoManager.dart' as sockets;
//import '../utils/GlobalIDs.dart';
import 'package:bus_tracker/app/components/LoadScreenWidget.dart';

//import 'package:bus_tracker/app/Internationalization/I10n/messages_all.dart';
import 'package:bus_tracker/app/Internationalization/scope_model_wrapper.dart';
//import 'package:bus_tracker/app/Internationalization/translation_strings.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:bus_tracker/app/states/App_MapState.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  static final String routeName = 'Login';
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  bool _isError = false;
  bool _obscureText = true;
  bool _isLoading = false;
  TextEditingController _usernameController, _passwordController;
  String _errorText, _usernameError, _passwordError;
  String appName= 'Saleem App', currentVersion = '3.0.0';

  @override
  void initState() {
    super.initState();    
    _fetchSessionAndNavigate();
    _usernameController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
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

    //print("Token:" + authToken);

    if (authToken != null) {
      print("********************  auto Login ***************");
      
      _handleConnection(authToken);

      var updateVersion = await NetworkUtils.fetchAppVersion(appName, currentVersion, '/AppManager/version');  

      if(updateVersion == false){
        Navigator.of(_scaffoldKey.currentContext)
            .pushReplacementNamed(UpdateVersionPage.routeName);
      } else { // if(updateVersion == true) {
        Navigator.of(_scaffoldKey.currentContext)
            .pushReplacementNamed(HomePage.routeName);
      }
      
    }
  }

_handleConnection(String authToken){
  print("3333333333333333333333333333333333333333333333333333333333333333333 begin _handleConnection login_page.dart");
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
    print("AppMapState _handleConnection login_page.dart");
    appMapState.setInitValues(_sharedPreferences.getString(AuthUtils.nameKey), _sharedPreferences.getString(AuthUtils.userIdKey), 
    _sharedPreferences.getString(AuthUtils.schoolIDKey).toString(), _sharedPreferences.getString(AuthUtils.schoolBrIDKey).toString(),
    authToken, _sharedPreferences.getInt(AuthUtils.roleLevelKey) == 5 ? true: false, _sharedPreferences.getInt(AuthUtils.roleLevelKey));     
    print("3333333333333333333333333333333333333333333333333333333333333333333 End _handleConnection login_page.dart");

}

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

  _authenticateUser() async {    
    if (_valid()) {
      _showLoading();
      var responseJson = await NetworkUtils.authenticateUser(
          _usernameController.text, _passwordController.text,
          //(_userLoginValue == 1 && _parentRegister == true) ? '/Users/parentAuth':'/Users/auth');
          (_parentRegister == true) ? '/Users/parentAuth':'/Users/auth');
      _hideLoading() ;

      print("Login Page Line 137, responseJson: " + responseJson.toString());

      if (responseJson == null) {
        print("SnackBar3");
        NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());
      } else if (responseJson == 'NetworkError') {
        print("SnackBar4");
        NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());
      } //else if(responseJson['errors'] != null) {
      else if (responseJson['success'] == false) {
        print("SnackBar5");
        NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.invalid_username_Password());
        print(responseJson['message']);
      } else if (responseJson['success'] == true && responseJson['message'] == 'New Parent Login' ) {
      // TODO: load Parent Register Screen
        //print(responseJson['Student']);
        Navigator.of(_scaffoldKey.currentContext)
            .pushReplacementNamed(UserRegisterPage.routeName);
      } else if (responseJson['success'] == true) {
         AuthUtils.insertDetails(_sharedPreferences, responseJson);
  /*print("999999999999999999999 call fetchTripData: " + responseJson['user'].toString() );
    print("999999999999999999999 call fetchTripData User_ID : " + responseJson['user']['id'].toString() );
  print("999999999999999999999 call fetchTripData Name: " + responseJson['user']['Name'].toString() );
  print("999999999999999999999 call fetchTripData role_ID_Level.toString(): " + responseJson['user']['Role_ID']['Role_ID'].toString() );
  print("999999999999999999999 call fetchTripData schoolid: " +  responseJson['user']['School_ID']['_id'].toString() );
  print("999999999999999999999 call fetchTripData schoolbid: " + (responseJson['user'].containsKey('School_Br_ID') == true ? responseJson['user']['School_Br_ID'].toString(): "null" ));
  print("999999999999999999999 call fetchTripData token: " + responseJson['token'].toString() );
*/

        var appMapState = Provider.of<AppMapState>(context);
        print("AppMapState _authenticateUser login_page.dart");
        appMapState.setInitValues(responseJson['user']['Name'],  responseJson['user']['id'], 
        responseJson['user']['School_ID']['_id'], (responseJson['user'].containsKey('School_Br_ID') == true && responseJson['user']['School_Br_ID'] != null ? responseJson['user']['School_Br_ID']['_id'].toString(): "" ),
        responseJson['token'], responseJson['user']['Role_ID']['Role_ID'] == 5 ? true: false, responseJson['user']['Role_ID']['Role_ID']);  
	
        //print("###############  App/version...");
        var updateVersion = await NetworkUtils.fetchAppVersion(appName, currentVersion, '/AppManager/version');
        //print("###############  App/version Result: " + updateVersion.toString());      
        if(updateVersion == false){          
          Navigator.of(_scaffoldKey.currentContext)
              .pushReplacementNamed(UpdateVersionPage.routeName);
        }
        else { // if(updateVersion == true){         
          /**
           * Removes stack and start with the new page.
           * In this case on press back on HomePage app will exit.
           * **/
          Navigator.of(_scaffoldKey.currentContext)
              .pushReplacementNamed(HomePage.routeName);
        }
      }
     
    } else {
      setState(() {
        _isLoading = false;
        //_usernameError;
        //_passwordError;
      });
    }
  }

  _valid() {
    bool valid = true;

    if (_usernameController.text.isEmpty) {
      valid = false;
      _usernameError = TranslateStrings.username_cant_be_blank();
    }
    //else if(!_usernameController.text.contains(UserNameValidator.regex)) {
    //	valid = false;
    //	_usernameError = "Enter valid username!";
    //}

    if (_passwordController.text.isEmpty) {
      valid = false;
      _passwordError = TranslateStrings.password_cant_be_blank();
    } else if (_passwordController.text.length <= 2) {
      valid = false;
      _passwordError = TranslateStrings.password_Length_is_invalid();
    }

    return valid;
  }

//int _userLoginValue =0;

  Widget _loginScreen() {
    return new Container(
      child: new ListView(
        padding: const EdgeInsets.only(top: 75.0, left: 16.0, right: 16.0),
        children: <Widget>[
          //new ErrorBox(isError: _isError, errorText: _errorText),
          new LogoBox( image: 'lib/app/assets/logo150x150.png',), //TODO: change path to come from server.
          new SizedBox(height: 50,),
          new UserNameField(
              usernameController: _usernameController,
              usernameError: _usernameError,
              //labelText: (_userLoginValue == 1 && _parentRegister == true) ? 'Student ID':'User Name',), 
              labelText: (_parentRegister == true) ? TranslateStrings.student_ID():TranslateStrings.user_Name(),), 
          new PasswordField(
            passwordController: _passwordController,
            obscureText: _obscureText,
            passwordError: _passwordError,
            togglePassword: _togglePassword,
            //labelText: (_userLoginValue == 1 && _parentRegister == true) ? 'Birth Date':'Password',
            labelText: (_parentRegister == true) ? TranslateStrings.birth_Date():TranslateStrings.password(),
          ),
         /* new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Radio(
                            value: 0,
                            groupValue: _userLoginValue,
                            onChanged: _userLoginradioChanged,
                            activeColor: Colors.red,
                          ),
                          new Text(
                            'Supervisor',
                            style: new TextStyle(fontSize: 16.0),
                          ),
                          new Radio(
                            value: 1,
                            groupValue: _userLoginValue,
                            onChanged: _userLoginradioChanged,
                            activeColor: Colors.red,
                          ),
                          new Text(
                            'Parent',
                            style: new TextStyle(
                              fontSize: 16.0,
                            ),
                          ), 
                          new Radio(
                            value: 2,
                            groupValue: _userLoginValue,
                            onChanged: _userLoginradioChanged,
                            activeColor: Colors.red,
                          ),
                          new Text(
                            'Driver',
                            style: new TextStyle(
                              fontSize: 16.0,
                            ),
                          ),                        
                        ],
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
           */       
          //new LoginButton(onPressed: _authenticateUser, labelText: _parentRegister == true ? 'Parent Register':'Log In',),Translate
          new LoginButton(onPressed: _authenticateUser, labelText: _parentRegister == true ? TranslateStrings.parentRegisterStudent():TranslateStrings.login(),),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[              
              IconButton(
                icon: new Icon(
                  //FontAwesomeIcons.solidUser,
                  FontAwesomeIcons.solidAddressCard,
                  size: 36,
                ),
                color: _parentRegister == true ? Theme.of(context).textTheme.display3.color : Colors.grey,
                onPressed: () {
                  //TODO: Send registeration info, for parent only, supervisor and driver must register by School Admin only.
                  //Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new UserRegisterPage()));
                    _toggleParentRegister();
                    //NetworkUtils.showSnackBar( _scaffoldKey, 'Register!');
                },
              ),
              new Padding(
                padding: new EdgeInsets.all(8.0),
              ),      
               ScopedModelDescendant<AppModel>(        
               builder: (context, child, model) => IconButton(
                icon: new Icon(FontAwesomeIcons.language, size: 35),
                color: Theme.of(context).textTheme.display3.color,
                onPressed: () {
                  //TODO: Make a Call
                    //NetworkUtils.showSnackBar( _scaffoldKey, 'Forget Password!');
                    setState(() {
                      TranslateStrings.toggle_Local(model.changeDirection());                                          
                      });
                },
              ), ),      
            ],
          ),

            

        ],
      ),
    );
  }

  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

 bool _parentRegister = false;
 _toggleParentRegister() {
    setState(() {
      //if(_userLoginValue == 1){
        _parentRegister = !_parentRegister;
        //if(_parentRegister == true) NetworkUtils.showSnackBar( _scaffoldKey, 'New Parent Register!');
      //  }
    });
  }

  _userLoginradioChanged(int value){
    setState(() {
        //       _userLoginValue = value;      
               if(value != 1){
                 _parentRegister =false;
               }
            });  
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: _isLoading ? loadingScreenWidget() : _loginScreen());
  }
}
