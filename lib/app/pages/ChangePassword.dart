import 'dart:async';

import 'package:bus_tracker/app/pages/home_page.dart';
import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
import 'package:bus_tracker/app/validators/field_validator.dart';
import 'package:bus_tracker/app/components/error_box.dart';
import 'package:bus_tracker/app/components/username_field.dart';
import 'package:bus_tracker/app/components/password_field.dart';
import 'package:bus_tracker/app/components/login_button.dart';
//import 'package:bus_tracker/app/utils/SystemIDs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/components/Drawer.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

class ChangePasswordPage extends StatefulWidget {

	@override
	ChangePasswordPageState createState() => new ChangePasswordPageState();

}

class ChangePasswordPageState extends State<ChangePasswordPage> {
	final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
	SharedPreferences _sharedPreferences;
	bool _isError = false;
	bool _obscureText = true;
	bool _isLoading = false;
	TextEditingController _oldPasswordController, _newPasswordController, _confirmPasswordController;
	String _errorText, _usernameError, _passwordError;
  String errorMassage;

  //var userIds = AuthUtils().getIDs();
  Map userIdsMap;

	@override
	void initState() {
		super.initState();
		_fetchSessionAndNavigate();
		_oldPasswordController = new TextEditingController();
		_newPasswordController = new TextEditingController();
    _confirmPasswordController = new TextEditingController();


    

	}
  
	_fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		String authToken = AuthUtils.getToken(_sharedPreferences);    
    print(" ************************ Token:" + authToken);

  
      if(authToken == null) {
			  Navigator.of(_scaffoldKey.currentContext)
				  .pushReplacementNamed(HomePage.routeName);
		  }
		
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
		_showLoading();
		if(_valid()) {
			var responseJson = await NetworkUtils.changePassword(_sharedPreferences.getString(AuthUtils.userIdKey),
				_oldPasswordController.text, _newPasswordController.text, _sharedPreferences.getString(AuthUtils.authTokenKey)
			);

			//print("Login Page Line 70, responseJson: " + responseJson);

			if(responseJson == null) {
        print("SnackBar3");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong());

			} else if(responseJson == 'NetworkError') {
        print("SnackBar4");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.networkError());

			} //else if(responseJson['errors'] != null) {
        else if(responseJson['success'] == false) {
        print("SnackBar5");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.invalid_username_Password());

			} else if(responseJson['success'] == true) {



				AuthUtils.insertDetails(_sharedPreferences, responseJson);

        print(" ************************ Route: Home Page " + HomePage.routeName);
        /**
				 * Removes stack and start with the new page.
				 * In this case on press back on HomePage app will exit.
				 * **/
				//Navigator.of(_scaffoldKey.currentContext)
				//	.pushReplacementNamed(HomePage.routeName);
        
        Navigator.of(_scaffoldKey.currentContext)
					.pushReplacementNamed("/");

			}
      else
      {
        print("SnackBar6");
				NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.invalid_username_Password());
      }

			_hideLoading();
		} else {
			setState(() {
				_isLoading = false;
				_usernameError;
				_passwordError;
			});
		}
	}

	_valid() {
		bool valid = true;

		if(_oldPasswordController.text.isEmpty) {
			valid = false;
			_usernameError = TranslateStrings.username_cant_be_blank();
		} 
    //else if(!_oldPasswordController.text.contains(UserNameValidator.regex)) {
		//	valid = false;
		//	_usernameError = "Enter valid username!";
		//}

		if(_newPasswordController.text.isEmpty) {
			valid = false;
			_passwordError = TranslateStrings.password_cant_be_blank();
		} else if(_newPasswordController.text.length <= 2) {
			valid = false;
			_passwordError = TranslateStrings.password_Length_is_invalid();
		}

  if(_confirmPasswordController.text.isEmpty) {
			valid = false;
			_passwordError = TranslateStrings.password_cant_be_blank();
		} else if(_confirmPasswordController.text.length < 2) {
			valid = false;
			_passwordError = TranslateStrings.password_Length_is_invalid();
		}

  if(_newPasswordController.text != _confirmPasswordController.text)
  {
  	  valid = false;
    	_passwordError = TranslateStrings.new_Password_Not_Match();
  }

		return valid;
	}

	Widget _loginScreen() {
		return new Container(
			child: new ListView(
				padding: const EdgeInsets.only(
					top: 100.0,
					left: 16.0,
					right: 16.0
				),
				children: <Widget>[
					//new ErrorBox(
					//	isError: _isError,
					//	errorText: _errorText
					//),
          new Image.asset('lib/app/assets/logo150x150.png',height: 100 ),
          SizedBox(height: 50.0,),
					new PasswordField(
            passwordController: _oldPasswordController,
						obscureText: _obscureText,
						passwordError: _passwordError,
            togglePassword: _togglePassword,
            labelText: TranslateStrings.current_Password()
					),
					new PasswordField(
						passwordController: _newPasswordController,
						obscureText: _obscureText,
						passwordError: _passwordError,
						togglePassword: _togglePassword,
            labelText: TranslateStrings.new_Password()
					),
          	new PasswordField(
						passwordController: _confirmPasswordController,
						obscureText: _obscureText,
						passwordError: _passwordError,
						togglePassword: _togglePassword,
            labelText: TranslateStrings.confirm_Password()
					),
					new LoginButton(onPressed: _authenticateUser, labelText: TranslateStrings.login(),),
          new RaisedButton(
            child: Text(TranslateStrings.logOut()),
            onPressed: (){
              NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
            },)
				],
			),
		);
	}

	_togglePassword() {
		setState(() {
			_obscureText = !_obscureText;
		});
	}
	
	@override
	Widget build(BuildContext context) {
	return new Scaffold(
			key: _scaffoldKey,      
      //drawer: new Drawer(child: new DrawerComponent(widget.username, widget.schoolID,  widget.role_ID_Level),),
			appBar: new AppBar(
				title: Center(child: new Text(TranslateStrings.change_Password(), style: new TextStyle(fontSize: 20.0, color: Colors.pink[300]),)),
        /*actions: <Widget>[
            IconButton(
          icon: Icon(FontAwesomeIcons.syncAlt, color: Colors.pink[200],),
          onPressed: () {
              print("**********************  try reload data from server..");
              setState(() {
                   errorMassage = "Wait...";  
               });
              _fetchSessionAndNavigate();
          },
        )
        ],*/
			),
			body: _loginScreen(),      
		);
	}

}