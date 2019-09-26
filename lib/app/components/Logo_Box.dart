import 'package:flutter/material.dart';

class LogoBox extends StatelessWidget {
	final String image;
	LogoBox({this.image});
	
  @override
  Widget build(BuildContext context) {	 
		  return new Center(
			  //child: new Image.asset('lib/app/assets/logo150x150.png')
        child: new Image.asset(image),
		  );
	  
  }
	
}