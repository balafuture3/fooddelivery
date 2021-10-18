import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/pages/introduction_screen.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/app_config.dart' as config;
import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController _con;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    _con.progress.addListener(() async {
      double progress = 0;
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;
      });
      if (progress == 100) {
       try {
           SharedPreferences prefs = await SharedPreferences.getInstance();
           bool onBoardValue = prefs.getBool('onBoardValue');
           print("onBoardValue ::: $onBoardValue");
         if(onBoardValue==null)
         {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => OnBoardingPage()),
             );
           }
         else
           {
             Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
           }
        } catch (e) {}
      }
    });
  }
/*  getOnBoardValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool onBoardValue = prefs.getBool('onBoardValue');
    return onBoardValue;
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 174, 239),/*Color.fromARGB(255, 61, 64, 91),*/
      key: _con.scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          //color: Theme.of(context).scaffoldBackgroundColor,
           //color: Color.fromARGB(255, 61, 64, 91),
           color: Color.fromARGB(0, 174, 239, 239),

        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img/humicon.png',
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
