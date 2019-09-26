import 'package:flutter/material.dart';

ThemeData basicTheme() { 
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith( // base.copyWith() override supper object properties. 
        headline: base.headline.copyWith( // headline: it could by in my home, login and a profile page,
                                          // i want headline to be a perticular font family, font size and color.
          fontFamily: 'BigVesta-Arabic-Regular', //'Roboto', // for english only
          fontSize: 24.0,
          color: Colors.white, //Colors.pink[400]
        ),
        title: base.title.copyWith(
          fontFamily: 'BigVesta-Arabic-Regular', // for english only
          fontSize: 12.0,
          color: Colors.green
        ),
        display1: base.headline.copyWith(
          fontFamily: 'BigVesta-Arabic-Regular',
          fontSize: 18.0,
          color: Colors.black,
        ),
        display2: base.headline.copyWith(
          fontFamily: 'BigVesta-Arabic-Regular',
          fontSize: 16.0,
          color: Colors.pink[200],
        ),
        display3: base.headline.copyWith(
          fontFamily: 'BigVesta-Arabic-Regular',
          fontSize: 16.0,
          color: Colors.pink[300],
        ),
        display4: base.headline.copyWith(
          fontFamily: 'BigVesta-Arabic-Regular',
          fontSize: 12.0,
          color: Colors.pinkAccent,
          fontWeight: FontWeight.bold
        ),
        caption: base.caption.copyWith(
          color: Color(0xFFCCC5AF),
        ),
        body1: base.body1.copyWith(color: Color(0xFF807A6B)));
  }
  final ThemeData base = ThemeData.light(); // for define base theme, like dark light theme
  return base.copyWith(
      textTheme: _basicTextTheme(base.textTheme), // will apply _basicTextTheme that we created above. // this line is a basic template to create theme
      //textTheme: Typography().white,
      primaryColor: Color(0xffce107c),  // pink // this line is a basic template to create theme
      //primaryColor: Color(0xff4829b2), // blue
      //primaryColor: Color(0xffdd6b3d), // orange
      indicatorColor: Color(0xFF807A6B),
      scaffoldBackgroundColor: Color(0xFFF5F5F5),
      accentColor: Color(0xFFFFF8E1),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 20.0,
      ),
      buttonColor: Colors.white,      
      backgroundColor: Colors.white,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: Color(0xffce107c),        
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontFamily: 'BigVesta-Arabic-Regular',
          fontSize: 16.0,
          color: Colors.pinkAccent,
          fontWeight: FontWeight.bold),
        unselectedLabelStyle:  TextStyle(fontFamily: 'BigVesta-Arabic-Regular',
          fontSize: 12.0,
          color: Colors.grey,
          fontWeight: FontWeight.bold),
      ));
}

/*

//TODO: basic theme template:
ThemeData basicTheme2() { 

  //TODO:  first: define TextTheme (like _basicTextTheme)
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith( // base.copyWith() override supper object properties. 
        headline: base.headline.copyWith( // headline: it could by in my home, login and a profile page,
                                          // i want headline to be a perticular font family, font size and color.
          fontFamily: 'Roboto',
          fontSize: 22.0,
          color: Colors.black,
        )
    );
    }

//TODO:  second: define ThemeData (like base)
final ThemeData base = ThemeData.light(); 
    return base.copyWith(
      //TODO:  third: apply TextTheme (like _basicTextTheme)
      textTheme: _basicTextTheme(base.textTheme), // will apply _basicTextTheme that we created above. // this line is a basic template to create theme      
      primaryColor: Color(0xffce107c),  // this line is a basic template to create theme      
    );      

  }

*/