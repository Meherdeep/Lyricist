import 'package:flutter/material.dart';
import 'package:sheet_music/sheet_music.dart';

class MusicSheetWindow extends StatefulWidget {
  final String scale;
  final String pitch;
  MusicSheetWindow(this.scale,this.pitch);
  @override
  _MusicSheetWindowState createState() => _MusicSheetWindowState();
}

class _MusicSheetWindowState extends State<MusicSheetWindow> {
  @override
  Widget build(BuildContext context) {
    return SheetMusic(
      trebleClef: true, 
      scale: widget.scale, 
      pitch: widget.pitch,
      backgroundColor: Colors.transparent,
    );
  }
}