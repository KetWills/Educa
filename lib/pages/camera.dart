import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CameraHomeScreen extends StatefulWidget {
  List<CameraDescription> cameras;

  CameraHomeScreen(this.cameras);

  @override
  State<StatefulWidget> createState() {
    return _CameraHomeScreenState();
  }
}

class _CameraHomeScreenState extends State<CameraHomeScreen> {
  String imagePath;
  bool _toggleCamera = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CameraController controller;

  String videoPath;
  XFile videoFile;

  @override
  void initState() {
    try {
      onCameraSelected(widget.cameras[0]);
    } catch (e) {
      print(e.toString());
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No Camera Found!',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      );
    }

    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: CameraPreview(
            controller,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withAlpha(100),
                              borderRadius: BorderRadius.circular(50)),
                          margin: EdgeInsets.only(bottom: 38),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18,
                              ),
                              IconButton(
                                  icon: Image.asset('assets/images/mic.png',
                                      height: 24),
                                  onPressed: () {}),
                              SizedBox(
                                width: 18,
                              ),
                              Opacity(
                                opacity: 0,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.refresh_outlined,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    onPressed: null),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              IconButton(
                                  icon: Image.asset(
                                    'assets/images/refresh.png',
                                    height: 24,
                                  ),
                                  onPressed: () {
                                    !_toggleCamera
                                        ? onCameraSelected(widget.cameras[1])
                                        : onCameraSelected(widget.cameras[0]);
                                    setState(() {
                                      _toggleCamera = !_toggleCamera;
                                    });
                                  }),
                              SizedBox(
                                width: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 32),
                      child: ButtonTheme(
                        minWidth: 60,
                        height: 60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: FlatButton(
                          color: Theme.of(context).accentColor,
                          child: Icon(
                            isrecording
                                ? Icons.stop_circle_outlined
                                : Icons.videocam_outlined,
                            color: Colors.white,
                          ),
                          onPressed: isrecording
                              ? onStopButtonPressed
                              : onVideoRecordButtonPressed,
                        ),
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isrecording = false;
  void onCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) await controller.dispose();
    controller = CameraController(cameraDescription, ResolutionPreset.medium);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showSnackBar('Camera Error: ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showException(e);
    }

    if (mounted) setState(() {});
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void setCameraResult() {
    print("Recording Done!");

    Navigator.pushNamed(context, 'upload', arguments: videoFile).then((value) {
      Navigator.pop(context, value);
    });
  }

  void onVideoRecordButtonPressed() {
    print('onVideoRecordButtonPressed()');
    startVideoRecording().then((String filePath) {
      if (mounted)
        setState(() {
          isrecording = true;
          check120seconds();
        });
      if (filePath != null) showSnackBar('Saving video to $filePath');
    });
  }

  double progress = 0;
  Timer time;
  check120seconds() {
    time = Timer.periodic(Duration(seconds: 120), (timer) {
      onStopButtonPressed();
    });
  }

  void onStopButtonPressed() {
    time.cancel();
    stopVideoRecording().then((_) {
      if (mounted)
        setState(() {
          isrecording = false;
        });
      showSnackBar('Video recorded to: $videoPath');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Videos';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording();
    } on CameraException catch (e) {
      print('zxxxz');
      _showException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      videoFile = await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showException(e);
      return null;
    }

    setCameraResult();
  }

  void _showException(CameraException e) {
    logError(e.code, e.description);
    showSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showSnackBar(String message) {
    print(message);
  }

  void logError(String code, String message) =>
      print('Error: $code\nMessage: $message');
}
