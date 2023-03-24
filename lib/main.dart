import 'package:flutter/material.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:notes_app/screens/add_new_note_screen.dart';
import 'package:notes_app/screens/notes_screen.dart';
import 'package:provider/provider.dart';

import './provider/auth.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor myColor = MaterialColor(
    const Color.fromRGBO(255, 160, 0, 1).value,
    const <int, Color>{
      50: Color.fromRGBO(255, 160, 0, 0.1),
      100: Color.fromRGBO(255, 160, 0, 0.2),
      200: Color.fromRGBO(255, 160, 0, 0.3),
      300: Color.fromRGBO(255, 160, 0, 0.4),
      400: Color.fromRGBO(255, 160, 0, 0.5),
      500: Color.fromRGBO(255, 160, 0, 0.6),
      600: Color.fromRGBO(255, 160, 0, 0.7),
      700: Color.fromRGBO(255, 160, 0, 0.8),
      800: Color.fromRGBO(255, 160, 0, 0.9),
      900: Color.fromRGBO(255, 160, 0, 1),
    },
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Notes>(
          create: (context) => Notes('', '', []),
          update: (context, auth, previousNotes) => Notes(
            auth.token,
            auth.userId,
            previousNotes == null ? [] : previousNotes.notes,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: myColor,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          SignupScreen.routeName: (context) => SignupScreen(),
          NotesScreen.routeName: (context) => NotesScreen(),
          AddNewNoteScreen.routeName: (context) => AddNewNoteScreen(),
        },
      ),
    );
  }
}
