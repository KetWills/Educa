import 'dart:io';

import 'package:camera/camera.dart';
import 'package:educa/services/upload_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../courses.dart';

class HomePage extends StatefulWidget {
  Map upload;
  HomePage({this.upload});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  Map data;
  UploadProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<UploadProvider>(context);

    return home();
  }

  home() {
    return Scaffold(
      backgroundColor: Color(0xFFFBFDFF),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: bnb(),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 44, top: 71),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Alex!',
                      style: GoogleFonts.roboto().copyWith(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'What would you like\nto learn today?',
                      style: GoogleFonts.roboto().copyWith(
                          color: Color(0xFFADADAD),
                          fontSize: 30,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(25, 47, 113, 186),
                            blurRadius: 50,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              height: 60,
                              child: Image.asset(
                                'assets/images/search.png',
                                height: 30,
                              ),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(10))),
                            ),
                            flex: 1,
                            fit: FlexFit.tight,
                          ),
                          Flexible(
                            child: Container(
                                padding: EdgeInsets.only(left: 8),
                                child: TextFormField(
                                    cursorColor: Color(0xFFADADAD),
                                    style: GoogleFonts.roboto().copyWith(
                                        color: Color(0xFFADADAD),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                        hintText: 'Content Creation',
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.roboto()
                                            .copyWith(
                                                color: Color(0xFFADADAD),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400)))),
                            flex: 5,
                            fit: FlexFit.tight,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        // pageSnapping: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          return CoursesWidget(
                              video: provider.videos[i],
                              width: MediaQuery.of(context).size.width * .5);
                        },
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.videos.length,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: provider.showLoader,
              child: Positioned(
                left: 16,
                right: 16,
                top: 16,
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF5B8D72),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/images/upload.png'),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your video is being uploaded!',
                            style: GoogleFonts.roboto().copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '20% Uploaded',
                            style: GoogleFonts.roboto().copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: provider.showSuccess,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 206,
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF5B8D72),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Success!',
                        style: GoogleFonts.roboto().copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Your video uploaded successfully!',
                        style: GoogleFonts.roboto().copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bnb() {
    return AbsorbPointer(
      absorbing: widget.upload != null,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              fit: StackFit.passthrough,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(47, 113, 186, 0.2),
                        blurRadius: 40,
                        offset: Offset(0, 0), // Shadow position
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(top: 40),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            onPressed: () {
                              setState(() {
                                currentTab = 0;
                              });
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/book.png',
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  height: 4,
                                  width: 4,
                                  decoration: BoxDecoration(
                                      color: currentTab == 0
                                          ? Theme.of(context).accentColor
                                          : Colors.white,
                                      shape: BoxShape.circle),
                                )
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            onPressed: () {
                              setState(() {
                                currentTab = 1;
                              });
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/msg.png',
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  height: 4,
                                  width: 4,
                                  decoration: BoxDecoration(
                                      color: currentTab == 1
                                          ? Theme.of(context).accentColor
                                          : Colors.white,
                                      shape: BoxShape.circle),
                                )
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            onPressed: () {
                              setState(() {
                                currentTab = 2;
                              });
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/user.png',
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  height: 4,
                                  width: 4,
                                  decoration: BoxDecoration(
                                      color: currentTab == 2
                                          ? Theme.of(context).accentColor
                                          : Colors.white,
                                      shape: BoxShape.circle),
                                ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child:
                              FlatButton(onPressed: null, child: Container())),
                    ],
                  ),
                ),
                Positioned(
                  child: ButtonTheme(
                    minWidth: 60,
                    height: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: FlatButton(
                      color: Theme.of(context).accentColor,
                      child: Icon(
                        Icons.videocam_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        var camera = await availableCameras();
                        Navigator.pushNamed(context, 'camera',
                                arguments: camera)
                            .then((value) {
                          if (value != null) {
                            widget.upload = value;
                            provider.upload(
                              widget.upload['file'] as File,
                              widget.upload['title'] as String,
                              widget.upload['topic'] as String,
                            );
                          }
                        });
                      },
                    ),
                  ),
                  top: 0,
                  height: 60,
                  right: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
