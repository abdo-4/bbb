import 'package:flutter/material.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

class UserNameField extends StatelessWidget {
	final TextEditingController usernameController;
	final String usernameError, labelText;  
  UserNameField({this.usernameController, this.usernameError, this.labelText});
  
	@override
  Widget build(BuildContext context) {
    return new Container(
	    margin: const EdgeInsets.only(bottom: 16.0),
	    child: new Theme(
		    data: new ThemeData(
			    primaryColor: Colors.pink[200], // Theme.of(context).primaryColor,
			    textSelectionColor:  Colors.pink[200], //Theme.of(context).primaryColor
		    ),
		    child: new TextField(
			    keyboardType: TextInputType.text,
			    controller: usernameController,
          textDirection: TranslateStrings.getTextDirection(),
			    decoration: new InputDecoration(
						contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
				    errorText: usernameError,
				    labelText: labelText,// 'User Name',
			    )
		    )
	    )
    );
  }
	
}