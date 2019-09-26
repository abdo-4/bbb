import 'package:intl/intl.dart';

/*
void convertDateFromString(String strDate){
   DateTime todayDate = DateTime.parse(strDate);
   print(todayDate.toString());
   print(formatDate(todayDate, [yyyy, '/', mm, '/', dd, ' ', hh, ':', nn, ':', ss, ' ', am]));
 }
  */

  String parsingDateTime(String strDate) {
    //DateTime now = DateTime.now();
    DateTime now = DateTime.parse(strDate);
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);
    return formattedDate;
  }