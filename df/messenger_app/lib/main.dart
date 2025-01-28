import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/services/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:messenger_app/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /* 
    TODO: Don't commit this project with the real api key.
    TODO: Always remember to check FirebaseOptions beforehand7.
  */
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "",
            authDomain: "",
            projectId: "",
            storageBucket: "",
            messagingSenderId: "",
            appId: ""
            )
          );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [ 
        ChangeNotifierProvider<AuthService>(create: (context) => AuthService()),
        ChangeNotifierProvider<ThemeNotifier>(create: (context) => ThemeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Flutter Chat',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.amber,
            scaffoldBackgroundColor: Colors.amber.shade100,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.amber.shade200,
              titleTextStyle: TextStyle(color: Colors.brown.shade800),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.brown,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.amber.shade900,
              titleTextStyle: const TextStyle(color: Colors.white),
            ),
          ),
          themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const AuthGate(),
        );
      }
    );
  }
}
