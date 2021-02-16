import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educa/services/video_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EducaServices {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser;
  Future<String> putVideo(File file, String name, title, topic) async {
    var ref = storage.ref('videos/${user.uid}/$name');
    var snap = ref.putFile(file);
    var completed = await snap.whenComplete(() {});
    return completed.ref.getDownloadURL();
  }

  Future<void> postFileDetails(VideoModel video) async {
    var ref = firestore.collection('videos');
    Map map = video.toMap();
    map.putIfAbsent('uid', () => user.uid);
    return ref.add(map);
  }

  Stream<List<VideoModel>> getVideos() {
    var ref = firestore.collection('videos').where('uid', isEqualTo: user.uid);
    return ref.snapshots().map(
        (event) => event.docs.map((e) => VideoModel.fromFirestore(e)).toList());
  }
}
