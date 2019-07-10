import 'package:flutter/material.dart';

class TravelTabPage extends StatefulWidget {
  final String code;

  TravelTabPage({this.code});

  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(widget.code),),
    );
  }
}
