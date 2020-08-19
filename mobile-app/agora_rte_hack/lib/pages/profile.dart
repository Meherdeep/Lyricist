import 'package:agora_rte_hack/pages/broacaster.dart';
import 'package:flutter/material.dart';

class ArtistProfile extends StatefulWidget {
  @override
  _ArtistProfileState createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B1B1B),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ), 
          onPressed: (){
            Navigator.pop(context);
          }
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80), 
                bottomRight: Radius.circular(80), 
              ),
              image: DecorationImage(
                image: ExactAssetImage('assets/profile.jpg'),
                fit: BoxFit.fill
              )
            ),
            height: MediaQuery.of(context).size.height*0.5,
            width: MediaQuery.of(context).size.width,
          ),
          Align(
            alignment: Alignment.center,
              child: Container(
              width: MediaQuery.of(context).size.height*0.38,
              height: MediaQuery.of(context).size.height*0.28,
              decoration: BoxDecoration(
                color: Color(0xFF2C2C2C),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Luke Graham ', style: TextStyle(fontSize: 20),),
                      Icon(Icons.check_circle, color: Colors.green, size: 15,)
                    ],
                  ),
                  Text('Not a singer', style: TextStyle(color: Colors.white60, fontSize: 12),),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.height*0.33,
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(0,0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.2,
                  child: Divider(
                    color: Colors.white70
                  ),
                ),
                Text('Interests', style: TextStyle(color: Colors.white70, fontSize: 20),),
                Container(
                  width: MediaQuery.of(context).size.width*0.2,
                  child: Divider(
                    color: Colors.white70
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0, 0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.music_note, size: 15,),
                Text('Keyboard', style: TextStyle(fontSize: 15),),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0, 0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.music_note, size: 15,),
                Text('Drums', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0,0.9),
            child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFDCD33),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    width: MediaQuery.of(context).size.width*0.35,
                    child: MaterialButton(
                      onPressed:(){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context)=>BroadcasterWindow('artist', 'Luke Graham'))
                        );
                      },
                      child: Text('Go Live!'), 
                    )
                  ),
          )
        ],
      ),
    );
  }
}