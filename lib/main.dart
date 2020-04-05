import 'package:carpooling/screens/loading_screen.dart';
import 'package:carpooling/state/app_states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utilities/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: AppState(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarPooling',
      theme: ThemeData(
        dividerTheme: DividerThemeData(
          space: 25,
          color: kappBarColor,
          thickness: 1.5,
          indent: 40,
          endIndent: 40
        ),
        primarySwatch: Colors.blue,
      ),
      home: LoadingScreen(),
    );
  }
}
