import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_web_falcorp/todoUi.dart';
import 'package:todo_web_falcorp/sidemenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        appId: '1:127813002960:android:2dafea14f67efee1eba0d5',
        apiKey: "AIzaSyCeet5bcvL6r2LP75AUzWRaKfS0EljWGrA",
        messagingSenderId: 'my_messagingSenderId',
        projectId: 'jose-35ba3',
        storageBucket: 'gs://jose-35ba3.appspot.com/',
        // Use your bucket link here
      ),
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            SystemUiOverlayStyle.dark.systemNavigationBarColor,
      ),
    );
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: sidemenu());
  }
}
