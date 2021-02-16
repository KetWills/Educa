import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  bool calling = false;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      key: sKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: calling,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 110,
                  ),
                  Text(
                    'Sign In',
                    style: GoogleFonts.roboto(
                        color: Theme.of(context).accentColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 51,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Theme.of(context).accentColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: TextFormField(
                            onEditingComplete: () => node.nextFocus(),
                            decoration: InputDecoration(
                                labelText: 'Email',
                                border: InputBorder.none,
                                labelStyle: GoogleFonts.roboto().copyWith(
                                    color: Color(0xFFADADAD),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400)),
                            controller: emailController,
                            validator: (_) {
                              return (_.length < 0 || !_.contains('@'))
                                  ? 'Enter email'
                                  : null;
                            },
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).accentColor,
                          height: 1,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: TextFormField(
                            onEditingComplete: () => node.unfocus(),
                            obscureText: true,
                            decoration: InputDecoration(
                                suffixIcon: FlatButton(
                                  child: Text(
                                    'Forgot?',
                                    style: GoogleFonts.roboto().copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor,
                                        fontSize: 18),
                                  ),
                                  onPressed: () {},
                                ),
                                labelText: 'Password',
                                border: InputBorder.none,
                                labelStyle: GoogleFonts.roboto().copyWith(
                                    color: Color(0xFFADADAD),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400)),
                            controller: passwordController,
                            validator: (_) {
                              return (_.length < 6) ? 'Enter password' : null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 51,
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
                          // Navigator.pushNamed(context, 'home');
                          if (formKey.currentState.validate()) {
                            setState(() {
                              calling = true;
                            });
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text)
                                .then((value) {
                              setState(() {
                                calling = false;
                              });
                              Navigator.pushNamed(context, 'home');
                            }).catchError((e) {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text)
                                  .then((value) {
                                setState(() {
                                  calling = false;
                                });
                                Navigator.pushNamed(context, 'home');
                              }).catchError((er) {
                                setState(() {
                                  calling = false;
                                });
                                sKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                        'Try again with different credentials')));
                              });
                            });
                          }
                        },
                        child: Text(
                          'Continue',
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
