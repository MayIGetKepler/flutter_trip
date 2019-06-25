import 'package:flutter/material.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/widget/webview.dart';

class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  GridNav(this.gridNavModel);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(color: Colors.transparent,clipBehavior: Clip.antiAlias,borderRadius: BorderRadius.circular(5),
    child: Column(
      children: _gridNavItems(context),
    ));
  }

  List<Widget> _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) return items;

    if (gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  Widget _gridNavItem(BuildContext context, GridNavItem model, bool isFirst) {
    final startColor = int.parse('0xff${model.startColor}');
    final endColor = int.parse('0xff${model.endColor}');
    return Container(
      margin: EdgeInsets.only(top: isFirst ? 0 : 3),
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(startColor), Color(endColor)])),
      height: 88,
      child: Row(
        children: [
          Expanded(child: _mainItem(context, model.mainItem)),
          Expanded(child: _doubleChildItem(context, model.item1, model.item2)),
          Expanded(child: _doubleChildItem(context, model.item3, model.item4))
        ],
      ),
    );
  }

  Widget _mainItem(BuildContext context, CommonModel model) {
    Widget item =  Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Image.network(
          model.icon,
          height: 88,
          width: 121,
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            model.title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        )
      ],
    );
    return _wrapGesture(context, item, model);
  }

  Widget _doubleChildItem(
      BuildContext context, CommonModel topModel, CommonModel bottomModel) {
    return Column(
      children: [
        Expanded(child: _item(context, topModel, true)),
        Expanded(child: _item(context, bottomModel, false))
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel model, bool isTopOne) {
    BorderSide borderSide = const BorderSide(color: Colors.white);
    Widget item = FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            border: Border(
                left: borderSide,
                bottom: isTopOne ? borderSide : BorderSide.none)),
        child: Text(
          model.title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
    return _wrapGesture(context, item, model);
  }

  Widget _wrapGesture(BuildContext context, Widget child, CommonModel model) {
    return GestureDetector(
      child: child,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                    url: model.url,
                    statusBarColor: model.statusBarColor,
                    hideAppBar: model.hideAppBar)));
      },
    );
  }
}
