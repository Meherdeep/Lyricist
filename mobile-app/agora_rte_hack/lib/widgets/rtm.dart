import 'package:agora_rte_hack/utils/detected_text.dart';

import '../utils/appID.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:random_string/random_string.dart';


class RealTimeMessaging extends StatefulWidget {
  final String channelName;
  final String userName;
  RealTimeMessaging(this.channelName, this.userName);
  @override
  _RealTimeMessagingState createState() => _RealTimeMessagingState();
}

class _RealTimeMessagingState extends State<RealTimeMessaging> {
  bool _isLogin = false;
  bool _isInChannel = false;

  final _channelMessageController = TextEditingController();

  final _infoStrings = <String>[];

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  
  SpeechRecognition _speechRecognition;

  bool _isAvailable = true;
  bool _isListening = false;

  String resultText = '';

  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];

  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    _createClient();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0),
            borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
            )
          ),
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Column(
                  children: [
                    _buildInfoList(),
                    _buildSendChannelMessage(), 
                  ],
                ),
          );
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(appID);
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _logPeer("Peer msg: " + peerId + ", msg: " + message.text);
    };
    
    _client.onConnectionStateChanged = (int state, int reason) {
      print('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _client.logout();
        print('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    String userId = widget.channelName;
    await _client.login(null, userId);
        print('Login success: ' + userId);
        setState(() {
          _isLogin = true;
    });
    String channelName = widget.channelName;
    _channel = await _createChannel(channelName);
        await _channel.join();
        print('Join channel success.');
        setState(() {
          _isInChannel = true;
        });

  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client.createChannel(name);
    channel.onMemberJoined = (AgoraRtmMember member) {
      print(
          "Member joined: " + member.userId + ', channel: ' + member.channelId);
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      print("Member left: " + member.userId + ', channel: ' + member.channelId);
    };
    channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      _logPeer(message.text);
    };
    return channel;
  }

  Widget _buildSendChannelMessage() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width *0.5,
                      child: TextFormField(
                        controller: _channelMessageController,
                        decoration: InputDecoration(
                          hintText: 'Comment...',
                          hintStyle: TextStyle(color: Color(0xFFFDCD33)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color(0xFFFDCD33), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color(0xFFFDCD33), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color(0xFFFDCD33), width: 2),
                          ), 
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Color(0xFFFDCD33), 
                          width: 2,
                        )
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Color(0xFFFDCD33)), 
                        onPressed: _toggleSendChannelMessage, 
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Color(0xFFFDCD33), 
                          width: 2,
                        )
                      ),
                      child: IconButton(
                        icon: Icon(Icons.music_note), 
                        onPressed: !_hasSpeech || speech.isListening
                          ? null
                          : startListening,
                      ) 
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Color(0xFFFDCD33), 
                          width: 2,
                        )
                      ),
                      child: IconButton(
                        icon: Icon(Icons.music_note), 
                        onPressed: speech.isListening ? stopListening : null,
                      ) 
                    ),
                  ],
                );
  }
  
  Widget buildState(){
    return Container();
  }

  Widget _buildInfoList() {
    return Expanded(
        child: Container(
          child: _infoStrings.length>0 ? ListView.builder(  
            reverse: true,
            itemBuilder: (context, i) {
              return Container(
                child: ListTile(
                  title: Align(
                    alignment: _infoStrings[i].startsWith('%') ? Alignment.bottomLeft:Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        color: Colors.white,
                        child: _infoStrings[i].startsWith('%')? Text(_infoStrings[i].substring(1), maxLines: 10, overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,style: TextStyle(color: Colors.black), ): Text(_infoStrings[i], maxLines: 10, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),),
                      ),
                    ),
                  ),
                );
              },
          itemCount: _infoStrings.length,
        ):Container()
      )
    );
  }


  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      print('Please input text to send.');
      return;
    }
    try {
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(text);
      _channelMessageController.clear();
    } catch (errorCode) {
      print('Send channel message error: ' + errorCode.toString());
    }
  }

  void _logPeer(String info){
    info = '%'+info;
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
    
  }
  void _log(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
      onResult: resultListener,
      // listenFor: Duration(seconds: 60),
      // pauseFor: Duration(seconds: 3),
      localeId: _currentLocaleId,
      // onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      partialResults: true,
      // onDevice: true,
      // listenMode: ListenMode.confirmation,
      // sampleRate: 44100,
    );
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    detectedText = lastWords.split(' ');
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
      detectedText.add(lastWords);
    });
    print(lastWords);
    print(detectedText);
  }
}