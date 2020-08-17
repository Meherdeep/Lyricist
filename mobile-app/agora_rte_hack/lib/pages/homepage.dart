import 'package:agora_rte_hack/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isLiked = false;

  bool isPaused = false;
  

  AudioPlayer audioPlayer;

  PageController _controller = PageController(
    initialPage: 0,
  );
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    audioPlayer = null;
  }
  
  List<String> bgLocation = ['assets/kodaline.jpg','assets/Bleached.jpg','assets/Interrupters.jpg','assets/linkin_park.jpg','assets/Lumineers.jpg','assets/Rob-Thomas.jpg'];
  
  List<String> artistName = ['Ralph','Connie','Niall','Troy','Herman','Douglas'];

  List<String> albumCovers = ['assets/1.png','assets/2.png','assets/3.png'];

  List<String> songName = ['BOP','Panini','Heavenly'];

  playAudioFromLocalStorage(path) async{
    audioPlayer = await AudioCache().loop(path);
  }

  pauseAudio() async{
    int response = await audioPlayer.pause();
    print(response);
  }

  resumeAudio() async{
    int response = await audioPlayer.resume();
    print(response);
  }

  songDuration() async{
    int duration = await audioPlayer.getDuration();
    print(duration);
  }


  Widget slider(){
    return Slider(
      activeColor: Color(0xFFCD2F51),
      inactiveColor: Colors.black,
      value: null, 
      onChanged: null
    );
  }
  
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
                alignment: Alignment(-0.6, 0.9),
                child: Container(
                  height: MediaQuery.of(context).size.height*0.1,
                  child: ListView.builder(
                    itemBuilder: (context,itemCount){
                      return Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width*0.6,
                              height: MediaQuery.of(context).size.height*0.1,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(40)
                              ),
                              child: Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage: ExactAssetImage(albumCovers[itemCount]),
                                        radius: 37,
                                      ),
                                      Center(
                                        child: IconButton(
                                          icon: isPaused? Icon(Icons.play_arrow, color: Colors.white, size: 30): Icon(Icons.pause, color: Colors.white, size: 30,), 
                                          onPressed: (){
                                            setState(() {
                                              isPaused = !isPaused;
                                            });
                                            isPaused?pauseAudio():playAudioFromLocalStorage('sample.mp3');
                                          }
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        songName[itemCount], 
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18
                                        )
                                      ),
                                      Text(artistName[position], style: TextStyle(color:Colors.white60, fontSize: 11), textAlign: TextAlign.left,)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.08,
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                  ),
                )
              )
            ],
          );
        },
        itemCount: bgLocation.length,
      )
    );
  }
}