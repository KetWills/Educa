import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class UploadVidePage extends StatefulWidget {
  XFile video;
  UploadVidePage(this.video);
  @override
  _UploadVidePageState createState() => _UploadVidePageState();
}

class _UploadVidePageState extends State<UploadVidePage> {
  VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();
    File f = File(widget.video.path);
    _videoPlayerController = VideoPlayerController.file(f.absolute);
    _videoPlayerController.addListener(() {
      if (startedPlaying && !_videoPlayerController.value.isPlaying) {
        Navigator.pop(context);
      }
    });
    _videoPlayerController.initialize().then((_) {
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
    });
  }

  bool ismute = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(widget.video.path);
    final node = FocusScope.of(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: StatefulBuilder(
                builder: (c, setstate) => Stack(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        )),
                    Positioned(
                      child: IconButton(
                        icon:
                            Icon(ismute ? Icons.volume_mute : Icons.volume_up),
                        color: Theme.of(context).accentColor,
                        onPressed: () => _videoPlayerController
                            .setVolume(!ismute ? 0 : .5)
                            .then((value) => setstate(() {
                                  ismute = !ismute;
                                })),
                      ),
                      left: 16,
                      bottom: 32,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () {
                            _videoPlayerController.pause().then((value) =>
                                Navigator.pushReplacementNamed(
                                    context, 'camera'));
                          },
                          child: Text(
                            'Retake',
                            style: GoogleFonts.roboto().copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          )),
                    ),
                    TextFormField(
                      style: GoogleFonts.roboto().copyWith(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                      controller: topicController,
                      textCapitalization: TextCapitalization.sentences,
                      onEditingComplete: () => node.nextFocus(),
                      decoration: InputDecoration(
                          labelText: 'Topic',
                          border: InputBorder.none,
                          labelStyle: GoogleFonts.roboto().copyWith(
                              color: Theme.of(context).accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w800)),
                    ),
                    TextFormField(
                      style: GoogleFonts.roboto().copyWith(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                      controller: titleController,
                      onEditingComplete: () => node.unfocus(),
                      decoration: InputDecoration(
                          labelText: 'Title',
                          border: InputBorder.none,
                          labelStyle: GoogleFonts.roboto().copyWith(
                              color: Theme.of(context).accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ButtonTheme(
                      buttonColor: Theme.of(context).accentColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 18,
                      ),
                      minWidth: MediaQuery.of(context).size.width * .7,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: FlatButton(
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            Map data = {
                              'file': File(widget.video.path),
                              'title': titleController.text,
                              'topic': topicController.text,
                            };

                            _videoPlayerController
                                .pause()
                                .then((value) => Navigator.pop(context, data));
                          },
                          child: Text(
                            'Upload',
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _bytesTransferred(TaskSnapshot snapshot) {
    double res = (snapshot.bytesTransferred / 1024.0) / 1000;
    double res2 = (snapshot.totalBytes / 1024.0) / 1000;
    return '${(res / res2) * 100}';
  }
}
