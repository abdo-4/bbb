import 'package:flutter/material.dart';
//import 'package:scoped_example/my_app.dart';
import 'package:bus_tracker/app/AppHome.dart';
import 'package:scoped_model/scoped_model.dart';

class ScopeModelWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return ScopedModel<AppModel>(model: AppModel(), child: MyApp());
    return ScopedModel<AppModel>(model: AppModel(), child: AppHome());
  }
}

class AppModel extends Model {
  Locale _appLocale = Locale('ar');
  Locale get appLocal => _appLocale ?? Locale("ar");

  String changeDirection() {
    String locale;
    if (_appLocale == Locale("ar")) {
      _appLocale = Locale("en");
      locale = "en";
    } else {
      _appLocale = Locale("ar");
      locale = "ar";
    }
    notifyListeners();
    return locale;
  }
}
