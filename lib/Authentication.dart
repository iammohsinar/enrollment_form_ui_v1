import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_controller_ui_v1/app_enum.dart';
import 'package:form_controller_ui_v1/user_entity.dart';
import 'package:provider/provider.dart';

import 'android_widgets.dart';

class Authentication extends StatefulWidget {
  Authentication(
      {required this.isLoading,
      required this.email,
      required this.user,
      required this.appLoginState,
      required this.login,
      required this.verifyEmail,
      required this.password,
      required this.register,
      required this.logout,
      required this.getEnrollYourSelf,
      required this.cancel});

  bool isInitialAppState = false;
  final void Function() cancel;
  final String? email;
  final bool isLoading;
  final Future<QuerySnapshot>? user;
  final void Function() getEnrollYourSelf;
  final AppLoginState appLoginState;
  final void Function(String email, String password, void Function(Exception e) error) login;
  final void Function() verifyEmail;
  final void Function() password;
  final void Function(
      String name,
      String email,
      String password,
      gender gender,
      String idCard,
      int contactNum,
      String programmingLang,
      bool notifyForEvent,
      bool isParentAvailable,
      String parentRelationShip,
      void Function(Exception e) errorCallback) register;
  final void Function() logout;

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.isInitialAppState = true;
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.isLoading) {
      return Stack(
        children: [Center(child: CircularProgressIndicator(value: null))],
      );
    }
    print("this.widget.isInitialAppState ${this.widget.isInitialAppState}");
    if (this.widget.isInitialAppState) {
      print("Authentication isInitialAppState");
      Future.delayed(Duration.zero, () => _showNoticeDialog(context, 'Notice'));
    }
    switch (this.widget.appLoginState) {
      case AppLoginState.LOGGED_IN:
        // show home screen and logout butto
        return Container(
          child: Column(
            children: [
              FutureBuilder<QuerySnapshot>(
                  future: widget.user,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Stack(
                        children: [Center(child: CircularProgressIndicator(value: null))],
                      );
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data!.docs.elementAt(0)['name']} you are Successfully logged in',
                          style: Theme.of(context).textTheme.headline4,
                        );
                      }
                    }

                    return Container(
                      child: Text('Something went wrong in server'),
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(14.0),
                      primary: Color(0xFFe28568),
                      textStyle: TextStyle(fontSize: 20.0)),
                  onPressed: () {
                    print("authentication l");
                    this.widget.logout();
                  },
                  child: Text('logout'))
            ],
          ),
        );
      case AppLoginState.LOGGED_OUT:
        return (Platform.isAndroid)
            ? LoginAndroid(
                email: widget.email!,
                login: (email, password) {
                  this.widget.login(email, password, (e) {
                    _showErrorDialog(context, 'Login failed', e);
                  });
                },
                getEnrolled: () {
                  this.widget.getEnrollYourSelf();
                },
              )
            : Container(
                child: Text('please use IOS'),
              );
      // show login screen
      case AppLoginState.VERIFY_EMAIL:
        // currently not in use
        // verify email with verify email call back if verified then show password if not then show signup
        return Container();
      case AppLoginState.PASSWORD:
        // currently not in use
        // signin with email and password
        return Container();
      case AppLoginState.REGISTER:
        // show register page
        return (Platform.isAndroid)
            ? RegisterAndroid(
                register: (
                  String name,
                  String email,
                  String password,
                  gender gender,
                  String idCard,
                  int contactNum,
                  String programmingLang,
                  bool notifyForEvent,
                  bool isParentAvailable,
                  String parentRelationShip,
                ) {
                  this.widget.register(
                      name,
                      email,
                      password,
                      gender,
                      idCard,
                      contactNum,
                      programmingLang,
                      notifyForEvent,
                      isParentAvailable,
                      parentRelationShip,
                      (e) => _showErrorDialog(context, 'Failed to register', e));
                },
                cancel: () => this.widget.cancel(),
              )
            : Container(
                child: Text('IOS platform'),
              );
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFF6e4875)),
                )),
          ],
        );
      },
    );
  }

  void _showNoticeDialog(context, String title) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            content: Text(
              'if you are not enroll, register first then login to enroll',
              style: TextStyle(fontSize: 18.0),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(14.0),
                        primary: Color(0xFF6e4875),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Ok'),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}
