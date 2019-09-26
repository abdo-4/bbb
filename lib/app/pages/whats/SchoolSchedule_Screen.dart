import 'package:flutter/material.dart';
import 'package:bus_tracker/app/components/Drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bus_tracker/app/utils/network_utils.dart';

import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bus_tracker/app/utils/TranslateStrings.dart';

class SchoolSchedulePage extends StatefulWidget {
	static final String routeName = 'SchoolSchedule';
  final String school_Name;
  SchoolSchedulePage({this.school_Name});
  
	@override
	State<StatefulWidget> createState() {
		return new _SchoolScheduleState();
	}

}

class _SchoolScheduleState extends State<SchoolSchedulePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  WebViewController _webViewController;
  String filePath = 'lib/app/assets/files/test.html';
  var schoolScheduleList;
  String content= "";
  bool iswebViewControllerInit = false;

@override
void initState() {
		super.initState();
    _showLoading();    
    //print("new note1");
		 //_fetchSchoolScheduleData();    
    //print("new note5");
	}

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			key: _scaffoldKey,      
      //drawer: new Drawer(child: new DrawerComponent(_username, _schoolID, _role_ID_Level),),
			appBar: new AppBar(
				title: Center(child: new Text(widget.school_Name)),
        actions: <Widget>[
            IconButton(
          icon: Icon(FontAwesomeIcons.syncAlt, color: Colors.pink[200],),
          onPressed: () {
             _fetchSchoolScheduleData(); 
          },
        )
        ],
			),
			body: _loadInitWebPage() ,
		);
	}

Widget _loadInitWebPage() {
  //return new Center();
return WebView(
        initialUrl: '',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          _fetchSchoolScheduleData() ;
          //_loadHtmlFromAssets();
          if(content != ""){
            print("@@@@@@@@@@@@@@@@@@ 1");
          _webViewController.loadUrl(Uri.dataFromString(content,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());}
        else
        nullschoolSchedule();
        },
      );
}

void _loadWebPage(){
     _webViewController.loadUrl(Uri.dataFromString(content,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  _loadHtmlFromAssets() async {
   /* String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());*/
  }

_fetchSchoolScheduleData() async{
    //NetworkUtils.showSnackBar(_scaffoldKey, 'Access Server!'); 
		var responseJson = await NetworkUtils.fetchSchoolScheduleData("/SchoolSchedule/list");			
      //NetworkUtils.showSnackBar(_scaffoldKey, 'Server data lenght=' + responseJson.toString().length.toString()); 
      //print("@@@@@@@@@ _fetchSchoolScheduleData: " + responseJson.toString());
			
      if(responseJson == "School Schedule null") {
        NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.school_Schedule_Null()); 
        _hideLoading();
        nullschoolSchedule();
        return responseJson;
      } else if(responseJson != "" && responseJson != null) {        
         setState(() {
            content = responseJson;   
            _loadWebPage();         
            //print("SnackBar8 _fetchSchoolScheduleData home"); 
            //print(content);
            //isDataLoaded = true;
          });				
			}  else {
        NetworkUtils.showSnackBar(_scaffoldKey, TranslateStrings.something_went_wrong()); 
        _hideLoading();
        nullschoolSchedule();
        return "" ; //responseJson;
			}

    }

  void nullschoolSchedule(){
     _webViewController.loadUrl(Uri.dataFromString("<Center><p><h1></br></br>" + TranslateStrings.school_Schedule_Null() +"</h1></p></Center>" + content,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  _showLoading() {
		setState(() {
      print("_showLoading");
		  //_isLoading = true;
		});
	}

	_hideLoading() {
		setState(() {
      print("_hideLoading");
		  //_isLoading = false;
		});
  }



}