import 'package:camera/camera.dart';
import 'package:educa/pages/camera.dart';
import 'package:educa/pages/home.dart';
import 'package:educa/pages/login.dart';
import 'package:educa/pages/splash.dart';
import 'package:educa/pages/upload_video.dart';
import 'package:educa/services/upload_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UploadProvider()),
      ],
      child: MaterialApp(
        title: 'educa',
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Color(0xFF2F71BA),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'splash',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case 'splash':
              return CupertinoPageRoute(builder: (c) => SplashScreen());
            case 'login':
              return CupertinoPageRoute(builder: (c) => LoginPage());
            case 'home':
              return CupertinoPageRoute(
                  builder: (c) => HomePage(upload: settings.arguments));
            case 'upload':
              return CupertinoPageRoute(
                  builder: (c) => UploadVidePage(settings.arguments));
            case 'camera':
              return CupertinoPageRoute(
                  builder: (c) => CameraHomeScreen(settings.arguments));
            default:
              return CupertinoPageRoute(
                  builder: (c) => SafeArea(
                          child: Center(
                        child: Text('No route with ${settings.name} exists.'),
                      )));
          }
        },
      ),
    );
  }
}
