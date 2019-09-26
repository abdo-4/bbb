import 'package:flutter/material.dart';

class TextField2 extends StatelessWidget {
	final TextEditingController textController;
	final String textError, labelText;
  TextField2({this.textController, this.textError, this.labelText});
  
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
			    controller: textController,
			    decoration: new InputDecoration(
						contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
				    errorText: textError,
				    labelText: labelText, //'User Name',
			    )
		    )
	    )
    );
  }
	
}