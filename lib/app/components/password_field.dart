import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final bool obscureText;
  final String passwordError;
  final VoidCallback togglePassword;
  final String labelText;
  PasswordField({
	  this.passwordController,
	  this.obscureText,
	  this.passwordError,
	  this.togglePassword,
    this.labelText
  });
  
	@override
  Widget build(BuildContext context) {
		return new Container(
			margin: const EdgeInsets.only(bottom: 16.0),
			child: new Theme(
				data: new ThemeData(
					primaryColor:  Colors.pink[200], //Theme.of(context).primaryColor,
					textSelectionColor:  Colors.pink[200], //Theme.of(context).primaryColor
				),
				child: new TextField(
					controller: passwordController,
					obscureText: obscureText,
          textDirection: TranslateStrings.getTextDirection(),
					decoration: new InputDecoration(
            alignLabelWithHint: true,            
						errorText: passwordError,            
						contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
						labelText: labelText, // 'Password',                                    
						suffixIcon: new GestureDetector(
							onTap: togglePassword,
							child: obscureText == true ? new Icon(FontAwesomeIcons.eyeSlash): new Icon(FontAwesomeIcons.eye, color: Colors.pink[300],),
						)
					)
				)
			)
		);
  }
	
}