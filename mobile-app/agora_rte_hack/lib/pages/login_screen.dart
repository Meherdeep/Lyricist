import 'dart:ui';

import 'package:agora_rte_hack/pages/homepage.dart';
import 'package:agora_rte_hack/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Image.asset('assets/notes.gif'),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.1,
                  ),
                  Text(
                    'Login', 
                    style: headingStyle
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email ID',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(color: Colors.white60,)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          )
                        ),
                        prefixIcon: Icon(
                          Icons.alternate_email,
                          color: Colors.white, 
                        )
                      ),
                    )
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.05,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(color: Colors.white60) 
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(color: Colors.white60,)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          )
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white, 
                        )
                      ),
                    )
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.05,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFDCD33),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    width: MediaQuery.of(context).size.width*0.35,
                    child: MaterialButton(
                      onPressed:(){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context)=>MyHomePage())
                        );
                      },
                      child: Text('Login'), 
                    )
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Don\'t have an account?', style: TextStyle(color: Colors.white60), ),
                        FlatButton(
                          onPressed: null, 
                          child: Text('Sign Up', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),)
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.2,
                        child: Divider(
                          color: Colors.white60,
                        )
                      ),
                      Text(
                        '  or login with  ', 
                        style: TextStyle(color: Colors.white60),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.2,
                        child: Divider(
                          color: Colors.white60,
                        )
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircleAvatar(
                          child: SvgPicture.asset('assets/facebook.svg'),
                        ),
                        CircleAvatar(
                          backgroundImage: ExactAssetImage('assets/google.png'),
                          child: FlatButton(onPressed: _handleGoogleSignIn, child: null),
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),
          )
        ],
      ),
      
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

}