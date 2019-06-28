import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'webview.dart';
import 'package:flutter_trip/model/sales_box_model.dart';

class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBoxModel;

  SalesBox({@required this.salesBoxModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _items(context),
    );
  }

  Widget _items(BuildContext context) {
    if (salesBoxModel == null) return Container();
    List<Widget> items = [];
    items.add(_header(context, salesBoxModel));
    items.add(_doubleItem(
        context, salesBoxModel.bigCard1, salesBoxModel.bigCard2, true, false));
    items.add(_doubleItem(context, salesBoxModel.smallCard1,
        salesBoxModel.smallCard2, false, false));
    items.add(_doubleItem(context, salesBoxModel.smallCard3,
        salesBoxModel.smallCard4, false, true));
    return Column(
      children: items,
    );
  }

  Widget _header(BuildContext context, SalesBoxModel model) {
    return Container(
      padding: EdgeInsets.fromLTRB(3, 6, 3, 6),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.network(
            model.icon,
            height: 15,
            fit: BoxFit.fill,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    colors: [Color(0xffff4e63), Color(0xffff6cc9)])),
            padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
            margin: EdgeInsets.only(right: 3, bottom: 3),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return WebView(
                    url: model.moreUrl,
                    title: "更多活动",
                  );
                }));
              },
              child: Text(
                '获取更多福利 >',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _doubleItem(BuildContext context, CommonModel left, CommonModel right,
      bool big, bool last) {
    return Row(
      children: <Widget>[
        _item(context, left, big, true, last),
        _item(context, right, big, false, last),
      ],
    );
  }

  Widget _item(
      BuildContext context, CommonModel model, bool big, bool left, bool last) {
    const border = const BorderSide(width: 0.8, color: Color(0xfff2f2f2));
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: last ? BorderSide.none : border,
              right: left ? border : BorderSide.none)),
      child: GestureDetector(
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
              height: big ? 129 : 80,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    ));
  }
}
