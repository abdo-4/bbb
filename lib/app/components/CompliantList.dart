import 'package:flutter/material.dart';
import 'package:bus_tracker/app/components/DateRange.dart' as DateRagePicker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompliantListField extends StatelessWidget {
	//final TextEditingController usernameController;
	//final String usernameError;
  //StudentListField({this.usernameController, this.usernameError});
  final List list;
  CompliantListField(this.list);

	@override
  Widget build(BuildContext context) {
    print("list Compliant: "+ (list == null? "Null" : "Not Null"));
    //return list == null ? nullCompliants(): Compliants();
    //return  nullCompliants();
  }
	
  Widget nullCompliants(){
    return new Center(
      child: new Text(
            "No Compliants List...",
            style: new TextStyle(fontSize: 20.0, color: Colors.pink[200]),),
    );
  }
  


}