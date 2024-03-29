import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trip/navigator/tab_navigator.dart';

void main() => runApp(MyApp());
final SystemUiOverlayStyle _style = SystemUiOverlayStyle(
  systemNavigationBarColor: Color(0xFF000000),
  systemNavigationBarDividerColor: null,
  statusBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(_style);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '携程',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
    );
  }
}
