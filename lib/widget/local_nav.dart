import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'webview.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  LocalNav({@required this.localNavList});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.white),
      height: 64,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  Widget _items(BuildContext context) {
    if (localNavList == null) return Container();
    List<Widget> items = [];
    localNavList.map((e) => items.add(_item(context, e))).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
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
            width: 32,
            height: 32,
          ),
          Text(
            model.title,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
