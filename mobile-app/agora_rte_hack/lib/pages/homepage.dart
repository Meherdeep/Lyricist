import 'package:agora_rte_hack/utils/helper.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isLiked = false;
  
  PageController _controller = PageController(
    initialPage: 0,
  );
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  List<String> bgLocation = ['assets/kodaline.jpg','assets/Bleached.jpg','assets/Interrupters.jpg','assets/linkin_park.jpg','assets/Lumineers.jpg','assets/Rob-Thomas.jpg'];
  
  List<String> artistName = ['Ralph','Connie','Niall','Troy','Herman','Douglas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ), 
          onPressed: null
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ), 
            onPressed: null
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,

      ),
      body: PageView.builder(
        controller: _controller,
        itemBuilder: (context, position){
          return Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(bgLocation[position]),
                    fit: BoxFit.fill  
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white70,
                      ), 
                      onPressed: null
                    ),
                    Text(
                      artistName[position], 
                      style: artistNameTextStyle
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isLiked? Color(0xFFCD2F51):Colors.white70,
                      ), 
                      onPressed: (){
                        setState(() {
                          isLiked = !isLiked;
                        });
                      }
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0, 0.42),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.height*0.2,
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                    style: artistBioTextStyle,
                    textAlign: TextAlign.center,
                  ),      
                ),
              ),
              Align(
                alignment: Alignment(0, 0.6),
                              child: Container(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: Divider(
                    color: Colors.white70,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: ListView.builder(
                    itemBuilder: (context,itemCount){
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFCD2F51),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ); 
                    },
                    itemCount: bgLocation.length,
                  ),
                )
              ),
            ],
          );
        },
        itemCount: bgLocation.length,
      )
    );
  }
}