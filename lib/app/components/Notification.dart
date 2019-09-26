  import 'package:flutter/material.dart';
  import 'package:bus_tracker/app/utils/TranslateStrings.dart';

  //showParentNoteDialog(BuildContext context, TextEditingController valueController) {
     showParentNoteDialog(BuildContext context, String guardians_ID, Function callBaclFun, String msgRoute, String msgTo){
      TextEditingController valueController = new TextEditingController();
      print("*********** showParentNoteDialog Call..");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(msgTo), //'Send Notice to Parent'), 
            content: new TextField(
					controller: valueController,					
					decoration: new InputDecoration(						
						contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
						labelText: "Type Message", // 'Password',
          )),					
            actions: <Widget>[
              FlatButton(
                child: Text(TranslateStrings.cancel()),//Text('DISCARD'),
                onPressed: () {
                  //callBaclFun(guardians_ID, "", msgRoute);
                  Navigator.pop(context); // remove current alert form
                  //return "";
                },
              ),
              FlatButton(
                child: Text(TranslateStrings.send()),//Text('SEND'),
                onPressed: () {
                  try
                  {               
                    if(valueController.text != null && valueController.text != "")
                    {
                      callBaclFun(guardians_ID, valueController.text, msgRoute);
                      Navigator.pop(context); // remove current alert form
                      //Navigator.pop(context, true); remove parent widget                  
                    }
                    else
                    {
                      // TODO: show Empty alert to user
                    }
                  }
                  catch(e) {print("*************** Error: " + e.toString());}
                },
              ),
            ],
          );
        });
  }

showNoteDialog(BuildContext context, String recieverID, String msgTo, String msgRoute, Function callBaclFun){
      TextEditingController valueController = new TextEditingController();
      print("*********** showNoteDialog Call..");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Send Notice to: " + msgTo), //'Send Notice to Parent'), 
            content: new TextField(
					controller: valueController,					
					decoration: new InputDecoration(						
						contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
						labelText: "Type Message", // 'Password',
          )),					
            actions: <Widget>[
              FlatButton(
                child: Text(TranslateStrings.cancel()),//Text('DISCARD'),
                onPressed: () {
                  //callBaclFun(guardians_ID, "", msgRoute);
                  Navigator.pop(context); // remove current alert form
                  //return "";
                },
              ),
              FlatButton(
                child: Text(TranslateStrings.send()),//Text('SEND'),
                onPressed: () {
                  try
                  {               
                    if(valueController.text != null && valueController.text != "")
                    {
                      callBaclFun(recieverID, valueController.text, msgRoute);
                      Navigator.pop(context); // remove current alert form
                      //Navigator.pop(context, true); remove parent widget                  
                    }
                    else
                    {
                      // TODO: show Empty alert to user
                    }
                  }
                  catch(e) {print("*************** Error: " + e.toString());}
                },
              ),
            ],
          );
        });
  }

  showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text(TranslateStrings.cancel()),//Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(TranslateStrings.continue_()),//Text('CONTINUE'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              ),
            ], 
          );
        });
  }

  showComplaintDialog(BuildContext context, String toUserID, String replyforID, int statusMarker, String msgTo, Function callBaclFun){
      TextEditingController subjectValueController = new TextEditingController();
      TextEditingController bodyValueController = new TextEditingController();
      print("*********** showComplaintDialog Call..");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10.0,
            title: Text(msgTo), //'Send Complaint to Parent'), 
            content:  Container(
              height: 100.0,
              child: Column(
                children: <Widget>[
                  new TextField(
                      controller: subjectValueController,					
                      decoration: new InputDecoration(						
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      labelText: TranslateStrings.subject(),// "Subject", 
                    )),
                     new TextField(
                      controller: bodyValueController,					
                      decoration: new InputDecoration(						
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      labelText: TranslateStrings.type_Message(),// "Type Message", 
                    )),
                ],
              ),
            ),					
            actions: <Widget>[
              FlatButton(
                child: Text(TranslateStrings.cancel()),//Text('DISCARD'),
                onPressed: () {
                  //callBaclFun(guardians_ID, "", msgRoute);
                  Navigator.pop(context); // remove current alert form
                  //return "";
                },
              ),
              FlatButton(
                child: Text(TranslateStrings.send()),//Text('SEND'),
                onPressed: () {
                  try
                  {               
                    if(subjectValueController.text != null && subjectValueController.text != "" &&
                    bodyValueController.text != null && bodyValueController.text != ""
                    )
                    {
                      callBaclFun(subjectValueController.text, bodyValueController.text, toUserID, replyforID, statusMarker);
                      Navigator.pop(context); // remove current alert form
                      //Navigator.pop(context, true); remove parent widget                  
                    }
                    else
                    {
                      // TODO: show Empty alert to user
                    }
                  }
                  catch(e) {print("*************** Error: " + e.toString());}
                },
              ),
            ],
          );
        });
  }
    
      showParentAddStudentDialog(BuildContext context, String msgTo, Function callBaclFun){
      TextEditingController studentIDValueController = new TextEditingController();
      TextEditingController birthDateValueController = new TextEditingController();
      print("*********** showParentAddStudentDialog Call..");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10.0,
            title: Text(msgTo), //'Send Complaint to Parent'), 
            content:  Container(
              height: 100.0,
              child: Column(
                children: <Widget>[
                  new TextField(
                      controller: studentIDValueController,					
                      decoration: new InputDecoration(						
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      labelText: TranslateStrings.student_ID(),// "Student ID", 
                    )),
                     new TextField(
                      controller: birthDateValueController,					
                      decoration: new InputDecoration(						
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      labelText: TranslateStrings.birth_Date(),//"Birth Date", 
                    )),
                ],
              ),
            ),					
            actions: <Widget>[
              FlatButton(
                child: Text(TranslateStrings.cancel()),//Text('DISCARD'),
                onPressed: () {
                  //callBaclFun(guardians_ID, "", msgRoute);
                  Navigator.pop(context); // remove current alert form
                  //return "";
                },
              ),
              FlatButton(
                child: Text(TranslateStrings.send()),//Text('SEND'),
                onPressed: () {
                  try
                  {               
                    if(studentIDValueController.text != null && studentIDValueController.text != "" &&
                    birthDateValueController.text != null && birthDateValueController.text != ""
                    )
                    {
                      callBaclFun(studentIDValueController.text, birthDateValueController.text);
                      Navigator.pop(context); // remove current alert form
                      //Navigator.pop(context, true); remove parent widget                  
                    }
                    else
                    {
                      // TODO: show Empty alert to user
                    }
                  }
                  catch(e) {print("*************** Error: " + e.toString());}
                },
              ),
            ],
          );
        });
  }

     showConfirmDialog(BuildContext context, String _title){     
      print("*********** showConfirmDialog Call..");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(_title),           				
            actions: <Widget>[
              FlatButton(
                child: Text(TranslateStrings.cancel()),//Text('DISCARD'),
                onPressed: () {
                  //callBaclFun(guardians_ID, "", msgRoute);
                  Navigator.pop(context, "No"); // remove current alert form
                  //return "";
                },
              ),
              FlatButton(
                child: Text(TranslateStrings.confirm_Dialog()),//Text('CONFIRM'),
                onPressed: () {
                  try
                  {                    
                      Navigator.pop(context, "Yes"); // remove current alert form
                      //Navigator.pop(context, true); remove parent widget                
                  
                  }
                  catch(e) {print("*************** Error: " + e.toString());}
                },
              ),
            ],
          );
        });
  }

  confirmDialog(BuildContext context, String title, String description) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(description)],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context, 'No'),
              child: Text(TranslateStrings.cancel()),//Text('Cancel'),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context, 'Yes'),
              child: Text(TranslateStrings.yes()),//Text('Yes'),
            ),
          ],
        );
      });
}

    
