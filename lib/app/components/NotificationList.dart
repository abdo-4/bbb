import 'package:flutter/material.dart';
import 'package:bus_tracker/app/components/DateRange.dart' as DateRagePicker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationListField extends StatelessWidget {
	//final TextEditingController usernameController;
	//final String usernameError;
  //StudentListField({this.usernameController, this.usernameError});
  final List list;
  NotificationListField(this.list);

	@override
  Widget build(BuildContext context) {
    print("list Notification: "+ (list == null? "Null" : "Not Null"));
    //return list == null ? nullNotifications(): _buildNotificationsContainer();
    //return  nullNotifications();
  }
	
  Widget nullNotifications(){
    return new Center(
      child: new Text(
            "No Notifications List...",
            style: new TextStyle(fontSize: 20.0, color: Colors.pink[200]),),
    );
  }
  


}