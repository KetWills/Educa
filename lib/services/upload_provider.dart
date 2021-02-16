import 'dart:async';
import 'dart:io';

import 'package:educa/services/services.dart';
import 'package:educa/services/video_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UploadProvider extends ChangeNotifier {
  bool showLoader = false;
  bool showSuccess = false;
  void upload(File video, title, topic) {
    EducaServices().putVideo(video, title, title, topic).then((url) {
      showLoader = true;
      Future.delayed(Duration(seconds: 2)).then((v) {
        EducaServices()
            .postFileDetails(VideoModel(title: title, topic: topic, url: url))
            .then((value) {
          showSuccess = true;
          notifyListeners();
          Future.delayed(Duration(seconds: 2)).then((value) {
            showLoader = false;
            dismiss();
          });
        });
      });
    });
  }

  List<VideoModel> videos = [];
  UploadProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null)
        EducaServices().getVideos().listen((event) {
          videos = event;
          notifyListeners();
        });
      else
        notifyListeners();
    });
  }

  void dismiss() {
    showLoader = false;
    showSuccess = false;
    notifyListeners();
  }
}
