import 'package:flutter/material.dart';
import 'package:snake/pages/hompage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snake/pages/intro_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyD9ZDRrvHcllnf91W2kEoCZVuPkVD5Oyyg",
          authDomain: "snakegame-419d4.firebaseapp.com",
          projectId: "snakegame-419d4",
          storageBucket: "snakegame-419d4.appspot.com",
          messagingSenderId: "1009097528876",
          appId: "1:1009097528876:web:1848ac5c97d487e7752389",
          measurementId: "G-DK90858TBK"
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroScreen(),
    );
  }
}
