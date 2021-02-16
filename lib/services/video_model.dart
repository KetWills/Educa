import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id, topic, title, url;

  VideoModel({this.id, this.topic, this.title, this.url});

  factory VideoModel.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data();
    return VideoModel(
      id: doc.id,
      topic: data['topic'],
      title: data['title'],
      url: data['url'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic': topic,
      'title': title,
      'url': url,
    };
  }
}
