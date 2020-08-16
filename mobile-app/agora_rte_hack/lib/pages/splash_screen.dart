import 'package:agora_rte_hack/pages/homepage.dart';
import 'package:agora_rte_hack/pages/login_screen.dart';
import 'package:agora_rte_hack/utils/helper.dart';
import 'package:agora_rte_hack/utils/login_val.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkRoute();
    super.initState();
  }

  checkRoute() async {
    if (isLoggedIn == false || isLoggedIn == null) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));       
      });
    } else {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: Image.asset(
              'assets/bg.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Text('Compose.ly', style: bigBoldTextStyle,) 
          ),
        ],
      ),
      
    );
  }
}