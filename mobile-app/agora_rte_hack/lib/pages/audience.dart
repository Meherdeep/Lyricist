import '../widgets/audience_view.dart';
import '../widgets/broadcaster_status.dart';
import '../widgets/rtm.dart';
import 'package:flutter/material.dart';

class AudienceWindow extends StatefulWidget {
  final String channelName;
  final String userName;
  AudienceWindow(this.channelName, this.userName);
  @override
  _AudienceWindowState createState() => _AudienceWindowState();
}

class _AudienceWindowState extends State<AudienceWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: AudienceView(widget.channelName),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
              child: Align(
                alignment: Alignment(-0.9, -0.8),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.music_note, color: Color(0xFFFDCD33), size: 15,),
                    Text('Lyricist', style: TextStyle(color: Color(0xFFFDCD33)),)
                  ],
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment(0.9, -0.8),
            //   child: BroadcastingStatus('69'.toString()),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RealTimeMessaging(widget.channelName, widget.userName),
              ),
            ),
          ],
        ),
    );
  }
}