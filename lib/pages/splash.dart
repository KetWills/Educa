import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      Future.delayed(Duration(seconds: 1)).then((value) =>
          Navigator.pushReplacementNamed(
              context, event == null ? 'login' : 'home'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Align(
        child: Text('educa',
            style: GoogleFonts.neuton().copyWith(
                fontSize: 72,
                color: Colors.white,
                fontWeight: FontWeight.w700)),
        alignment: Alignment.center,
      ),
    );
  }
}
