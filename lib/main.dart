import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/user.dart';
import 'package:voluntarius/firebase_options.dart';
import 'package:voluntarius/pages/home.dart';
import 'package:voluntarius/pages/chat.dart';
import 'package:voluntarius/pages/map.dart';
import 'package:voluntarius/pages/profile.dart';
import 'package:voluntarius/pages/request.dart';
import 'package:voluntarius/pages/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
            value: FirebaseAuth.instance.authStateChanges(), initialData: null),
      ],
      child: MaterialApp(
        title: 'Voluntarius',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
            appBar: AppBar(title: const Text("Voluntarius")),
            body: Builder(
              builder: (context) {
                User? user = Provider.of<User?>(context);
                if (user == null) {
                  return ChatPage();
                }
                Stream<UserData> userData = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots()
                    .map((snap) => UserData.fromFirestore(snap));
                return MultiProvider(providers: [
                  StreamProvider<UserData>.value(
                      initialData: UserData(
                          id: "",
                          name: "",
                          notificationTokens: [],
                          averageStars: 0,
                          numReviews: 0),
                      value: userData)
                ], child: MapPage());
              },
            )),
      ),
    );
  }
}
