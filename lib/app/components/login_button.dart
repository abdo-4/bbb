import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String labelText;
  LoginButton({this.onPressed, this.labelText});
  
	@override
  Widget build(BuildContext context) {
		return new Container(
			margin: const EdgeInsets.symmetric(vertical: 12.0),
			child: new Material(
				elevation: 5.0,
				child: new MaterialButton(
					color: Theme.of(context).primaryColor,
					height: 42.0,
					child: new Text(
						labelText,
						style: new TextStyle(
							color: Theme.of(context).textTheme.headline.color, // white color
              fontSize: 18
						)
					),
					onPressed: onPressed
				)
			)
		);
  }
	
}