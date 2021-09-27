//import 'dart:io';
import 'dart:async';

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_controller_ui_v1/Authentication.dart';
import 'package:form_controller_ui_v1/android_widgets.dart';
import 'package:form_controller_ui_v1/app_enum.dart';
//import 'package:form_controller_ui_v1/user_entity.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppFirebaseState(), builder: (context, _) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xFFe28568),
          accentColor: Color(0xFFe28568),
          textTheme: TextTheme(headline5: TextStyle()).apply(bodyColor: Color(0xFF6e4875))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  //final AppFirebaseState appFirebaseState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        backgroundColor: Color(0xFFdeebe9),
        body: Column(children: [
          SizedBox(
            height: 50,
          ),
          Image.asset("assets/cover.png"),
          SizedBox(
            height: 8,
          ),
          Text(
            "Get Enrolled yourself",
            style: Theme.of(context).textTheme.headline5,
          ),
          Expanded(
              child: ListView(children: [
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Consumer<AppFirebaseState>(
                  builder: (context, appState, _) {
                    print("consumer");
                    if (appState.isInitialAppState) {
                      return Container();
                    }
                    return Authentication(
                        isLoading: appState.isLoading,
                        email: appState.email,
                        user: appState.enrollUser,
                        getEnrollYourSelf: appState.getEnrollYourSelf,
                        appLoginState: appState.loginState,
                        login: appState.login,
                        verifyEmail: appState.verifyEmail,
                        password: appState.verifyEmail,
                        register: appState.register,
                        logout: appState.logout,
                        cancel: appState.cancelRegistration);
                  },
                ))
          ])),
        ]));
  }
}

class AppFirebaseState extends ChangeNotifier {
  AppFirebaseState() {
    this._isInitialAppState = true;
    init();
  }

  AppLoginState _loginState = AppLoginState.LOGGED_OUT;
  AppLoginState get loginState => _loginState;
  bool get isLoading => _isLoading;
  Future<QuerySnapshot>? get enrollUser => _user;
  String? get email => _email;
  bool get isInitialAppState => _isInitialAppState;

  bool _isInitialAppState = false;
  bool _isLoading = false;
  Future<QuerySnapshot>? _user; //UserEntity(userName: "Annonymous");
  String? _email;

  Future<void> init() async {
    this._email = "";
    await Firebase.initializeApp();
    FirebaseAuth.instance.userChanges().listen((user) {
      print("user");
      if (user != null) {
        print("user.uid ${user.uid}");
        _loginState = AppLoginState.LOGGED_IN;
        _user = FirebaseFirestore.instance
            .collection('registered_users')
            .where('userId', isEqualTo: user.uid)
            .get();
      } else {
        _loginState = AppLoginState.LOGGED_OUT;
      }
      this._isInitialAppState = false;
      this._isLoading = false;
      notifyListeners();
    });
  }

  void login(String email, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      _loadingNotify(this.isLoading);
      this._email = email;
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      _unLoadingNotify();
    }
  }

  void _loadingNotify(bool isLoading) {
    if (!isLoading) {
      this._isLoading = true;
      notifyListeners();
    }
  }

  void _unLoadingNotify() {
    this._isLoading = false;
    notifyListeners();
  }

  void verifyEmail() {
    // not in use
  }

  void password() {
    // not in use
  }

  void getEnrollYourSelf() {
    _loginState = AppLoginState.REGISTER;
    notifyListeners();
  }

  void cancelRegistration() {
    print('AppFirebaseState cancelRegistration()');
    _loginState = AppLoginState.LOGGED_OUT;
    notifyListeners();
  }

  void register(
      String name,
      String email,
      String password,
      gender g,
      String idCard,
      int contactNum,
      String programmingLang,
      bool notifyForEvent,
      bool isParentAvailable,
      String parentRelationShip,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      _loadingNotify(this.isLoading);
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance.collection('registered_users').add(<String, dynamic>{
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'userId': credential.user!.uid,
        'name': name,
        'gender': (g == gender.MALE) ? 'M' : 'F',
        'idCard': idCard,
        'contactNum': contactNum,
        'programmingLang': programmingLang,
        'notifyForEvent': notifyForEvent,
        'isParentAvailable': isParentAvailable,
        'parentRelationShip': parentRelationShip,
      });
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      _unLoadingNotify();
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
