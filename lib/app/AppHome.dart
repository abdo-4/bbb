import 'package:bus_tracker/app/pages/home_page.dart';
import 'package:bus_tracker/app/pages/UserRegister_page.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracker/app/pages/login_page.dart';
import 'package:bus_tracker/app/pages/Splash_page.dart';
import 'package:bus_tracker/app/pages/UpdateVersion.dart';
//import './Socketio/socketIoManager.dart' as sockets;
import 'package:bus_tracker/app/utils/theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:scoped_example/login.dart';
import 'package:bus_tracker/app/Internationalization/scope_model_wrapper.dart';
//import 'package:bus_tracker/app/Internationalization/style.dart';
import 'package:bus_tracker/app/Internationalization/translation.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:provider/provider.dart';
//import 'package:bus_tracker/app/ProxyProvider/Provider_Setup.dart';
import 'package:bus_tracker/app/states/App_MapState.dart';
//import 'package:bus_tracker/app/states/App_SocketState.dart';
//import 'package:bus_tracker/app/states/App_NotificationState.dart';

class AppHome extends  StatelessWidget {
  @override
  Widget build(BuildContext context) {

     return MultiProvider( // Proxyprovider ^3.0.0 
      providers:  [   // [] Proxyprovider ^3.0.0
        
        ChangeNotifierProvider.value(value: AppMapState(),),
        //ChangeNotifierProvider.value(value: SocketIOClass(),),
        //ChangeNotifierProvider.value(value: AppNotificationState(),),
      ],
            child: ScopedModelDescendant<AppModel>(
          builder: (context, child, model) => MaterialApp(
                title: 'School Bus Tracker',
                debugShowCheckedModeBanner: false,
                // for language support
                locale: model.appLocal,
                localizationsDelegates: [
                  const TranslationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('ar', ''), // Arabic
                  const Locale('en', ''), // English
                ],              
                // for language support
                //theme: hrTheme,
                theme: basicTheme(),
                //home: new LoginPage(),
                home: new SplashPage(),
                routes: {
        	        HomePage.routeName: (BuildContext context) => new HomePage(),
                  UserRegisterPage.routeName: (BuildContext context) => new UserRegisterPage(),
                  UpdateVersionPage.routeName: (BuildContext context) => new UpdateVersionPage(),
                  LoginPage.routeName:  (BuildContext context) => new LoginPage(),
	            },
              )),
     );
  }

  @override
  void dispose() {
    //super.dispose();    
    //SocketIOClass.disconnectSocket();
    //SocketIOClass.destroySocket();
  }

}