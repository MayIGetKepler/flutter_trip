import 'package:flutter/material.dart';

class NavigatorUtil{
  static push(BuildContext context,Widget pageTogo){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>pageTogo));
  }
}