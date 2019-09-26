import 'dart:async';

import 'package:bus_tracker/app/pages/home_page.dart';
import 'package:bus_tracker/app/pages/login_page.dart';
import 'package:bus_tracker/app/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';
import 'package:bus_tracker/app/validators/field_validator.dart';
import 'package:bus_tracker/app/components/error_box.dart';
import 'package:bus_tracker/app/components/username_field.dart';
import 'package:bus_tracker/app/components/text_field.dart';
import 'package:bus_tracker/app/components/password_field.dart';
import 'package:bus_tracker/app/components/login_button.dart';
//import 'package:bus_tracker/app/utils/SystemIDs.dart';

class UserRegisterPage extends StatefulWidget {
static final String routeName = 'User Register';

	@override
	UserRegisterPageState createState() => new UserRegisterPageState();

}

class UserRegisterPageState extends State<UserRegisterPage> {
	final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
	SharedPreferences _sharedPreferences;
	//bool _isError = false;
	bool _obscureText = true;
	//bool _isLoading = false;
	TextEditingController  _usernameController, _newPasswordController, _confirmPasswordController, _fullNameController, _phoneController, _emailController, _studentIDController;  
	String _usernameError, _passwordError, _fullNameError, _phoneError, _emailError, _studentIDError;

  //var userIds = AuthUtils().getIDs();
  Map userIdsMap;

	@override
	void initState() {
		super.initState();
		_fetchSessionAndNavigate();
    _usernameController = new TextEditingController();
		_fullNameController = new TextEditingController();
    _phoneController = new TextEditingController();
    _emailController = new TextEditingController();
		_newPasswordController = new TextEditingController();
    _confirmPasswordController = new TextEditingController();   
    _studentIDController = new TextEditingController();   
	}
  
	_fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		//String authToken = AuthUtils.getToken(_sharedPreferences);    
    //print(" ************************ Token:" + authToken);

  
      /*if(authToken == null) {
			  Navigator.of(_scaffoldKey.currentContext)
				  .pushReplacementNamed(HomePage.routeName);
		  }
		*/
	}



	_showLoading() {
		setState(() {
		  //_isLoading = true;
		});
	}

	_hideLoading() {
		setState(() {
		  //_isLoading = false;
		});
	}

	_authenticateUser() async {
		_showLoading();
		if(_valid()) {
			var responseJson = await NetworkUtils.userRegister(_fullNameController.text,
				_usernameController.text, _newPasswordController.text, 
        _phoneController.text , _emailController.text, '/Users/parentRegister');
	
			//print("Login Page Line 70, responseJson: " + responseJson);

			if(responseJson == null) {
        print("SnackBar3");
				NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

			} else if(responseJson == 'NetworkError') {
        print("SnackBar4");
				NetworkUtils.showSnackBar(_scaffoldKey, "Network Error...");

			} //else if(responseJson['errors'] != null) {
        else if(responseJson['success'] == false) {
        print("SnackBar5");
				NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid username/Password');

			} else if(responseJson['success'] == true) {

				//AuthUtils.insertDetails(_sharedPreferences, responseJson);

        print(" ************************ Route: Home Page " + HomePage.routeName);
        /**
				 * Removes stack and start with the new page.
				 * In this case on press back on HomePage app will exit.
				 * **/
				//Navigator.of(_scaffoldKey.currentContext)
				//	.pushReplacementNamed(HomePage.routeName);
        
        Navigator.of(_scaffoldKey.currentContext)
					.pushReplacementNamed(LoginPage.routeName);

			}
      else
      {
        print("SnackBar6");
				NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid username/Password');
      }

			_hideLoading();
		} else {
			setState(() {
				//_isLoading = false;
				_usernameError;
				_passwordError;
			});
		}
	}

	_valid() {
		bool valid = true;

		if(_fullNameController.text.isEmpty) {
			valid = false;
			_fullNameError = "Name can't be blank!";
		} else if(_fullNameController.text.length < 2) {
			valid = false;
			_fullNameError = "Name Length is invalid! must be greater than 2 char!";
    } 

    if(_studentIDController.text.isEmpty) {
			valid = false;
			_studentIDError = "Student ID can't be blank!";
		}

    if(_usernameController.text.isEmpty) {
			valid = false;
			_usernameError = "User Name can't be blank!";
		} else if(_usernameController.text.length < 2) {
			valid = false;
			_usernameError = "User Name Length is invalid! must be greater than 2 char!";
    } else if(!_usernameController.text.contains(UserNameValidator.regex)) {
			valid = false;
			_usernameError = "Enter valid User Name!";
		}

    if(_phoneController.text.isEmpty) {
			valid = false;
			_phoneError = "Phone can't be blank!";
		} else if(_phoneController.text.length < 9) {
			valid = false;
			_phoneError = "Phone Length is invalid!";
    } // TODO: correct phone number Validator
     /*else if(!_phoneController.text.contains(PhoneValidator.regex)) {
			valid = false;
			_usernameError = "Enter valid User Name!";
		}*/

		if(_newPasswordController.text.isEmpty) {
			valid = false;
			_passwordError = "Password can't be blank!";
		} else if(_newPasswordController.text.length < 2) {
			valid = false;
			_passwordError = "Password Length is invalid! must be greater than 2 char!";
		} 

    if(_confirmPasswordController.text.isEmpty) {
			valid = false;
			_passwordError = "Password can't be blank!";
		} else if(_confirmPasswordController.text.length < 2) {
			valid = false;
			_passwordError = "Password Length is invalid!";
		}

  if(_newPasswordController.text != _confirmPasswordController.text)
  {
  	  valid = false;
    	_passwordError = "New Password Not Match!";
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
          //new Image.asset('lib/app/assets/logo150x150.png',height: 100 ),
         // SizedBox(height: 50.0,),
     /*     Name : req.body.Name,
     username : req.body.username,
     password : req.bod y.password,
     Email : req.body.Email,
     Phone : req.body.Phone,
     Role_ID : req.body.Role_ID,
     IMEI : req.body.IMEI,
     Reg_ID : req.body.Reg_ID,
     User_Type : req.body.User_Type,
     Latitude : req.body.Latitude,
     Last_Active : req.body.Last_Active,
     Longitude : req.body.Longitude,
     Status : req.body.Status,
     School_ID : req.body.School_ID,
     School_Br_ID : req.body.School_Br_ID,
     Created_by : req.body.Created_by,
     Created_at : new Date(),
     //Updated_by : req.body.Updated_by,
     //Updated_at : req.body.Updated_at,
     Status : req.body.Status});
     */
    	    new TextField2(
            labelText: 'Full Name',
            textController: _fullNameController,					
						textError: _fullNameError,            		
					),
           new TextField2(
            labelText: 'Student ID',
            textController: _studentIDController,					
						textError: _studentIDError,            		
					),
					new UserNameField(
            labelText: 'User Name',
            usernameController: _usernameController,					
						usernameError: _usernameError,            		
					),
					new PasswordField(
						passwordController: _newPasswordController,
						obscureText: _obscureText,
						passwordError: _passwordError,
						togglePassword: _togglePassword,
            labelText: 'New Password'
					),
          	new PasswordField(
						passwordController: _confirmPasswordController,
						obscureText: _obscureText,
						passwordError: _passwordError,
						togglePassword: _togglePassword,
            labelText: 'Confirm Password'
					),
          new TextField2(
            labelText: 'Phone',
            textController: _phoneController,					
						textError: _phoneError,            		
					),
          new TextField2(
            labelText: 'Email',
            textController: _emailController,					
						textError: _emailError,            		
					),
        
					new LoginButton(onPressed: _authenticateUser,labelText: 'Register' ),
          /*new RaisedButton(
            child: Text("Log out"),
            onPressed: (){
              NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
            },)*/
            new LoginButton(onPressed: _logOut,labelText: 'Log out' ),
				],
			),
		);
	}

_logOut(){
  NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
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
			body: _loginScreen()
		);
	}

}