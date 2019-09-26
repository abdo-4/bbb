import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'dart:convert';

class DateRange extends StatelessWidget {  
 

 @override
  Widget build(BuildContext context) {
    return new Center( child: buildDateRanging(context));
  }

Widget buildDateRanging(BuildContext context)
{
  return new MaterialButton(
    color: Colors.deepOrangeAccent,
    height: 50.0,    
    onPressed: () async {
      final List<DateTime> picked = await DateRagePicker.showDatePicker(
          context: context,
          initialFirstDate: new DateTime.now(),
          initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
          firstDate: new DateTime(2019),
          lastDate: new DateTime(2050)
      );
      if (picked != null && picked.length == 2) {
          print(picked);
          print(picked[1].subtract(new Duration(days:picked[0].day)).day);
      }
    },
    child: new Text("Pick date range")
);
}

    Future getDate(BuildContext context) async
    {
      final List<DateTime> picked = await DateRagePicker.showDatePicker(
          context: context,
          initialFirstDate: new DateTime.now(),
          initialLastDate: (new DateTime.now()).add(new Duration(days: 2)),
          firstDate: new DateTime(2019),
          lastDate: new DateTime(2050)
      );
      if(picked != null && picked.length == 1) {
         print(picked);          
          return {"picked": picked, "day": 1};
      }
      else if (picked != null && picked.length == 2) {
          print(picked);
          print(picked[1].subtract(new Duration(days:picked[0].day)).day);
          return {"picked": picked, "day": picked[1].subtract(new Duration(days:picked[0].day)).day};
      }
      else return {};

    }


}
