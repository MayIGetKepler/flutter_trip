import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'webview.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  SubNav({@required this.subNavList});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  Widget _items(BuildContext context) {
    if (subNavList == null) return Container();
    List<Widget> items = [];
    subNavList.map((e) => items.add(_item(context, e))).toList();
    var separate = (subNavList.length / 2 + 0.5).toInt();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0,separate),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(separate),
        )
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return Expanded(child: GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return WebView(
              url: model.url,
              statusBarColor: model.statusBarColor,
              title: model.title,
              hideAppBar: model.hideAppBar,
              backForbid: true,
            );
          })),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(
            model.icon,
            width: 18,
            height: 18,
          ),
          SizedBox(height: 3,),
          Text(
            model.title,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    ));
  }
}
