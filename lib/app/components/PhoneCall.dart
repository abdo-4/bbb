import 'package:url_launcher/url_launcher.dart';


void phoneCall(var number) async
{
  var uri = "tel://" + number;
  if (await canLaunch(uri))
  {
      await launch(uri);
  } else {
        throw 'Could not launch $uri';
      }

}

 void sms(number) async {
      var uri = 'sms:' + number;
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
  }


/*
 void _textMe() async {
    // Android
    const uri = 'sms:+39 348 060 888?body=hello%20there';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms:0039-222-060-888';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
  */