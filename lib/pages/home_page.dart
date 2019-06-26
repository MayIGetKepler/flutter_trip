import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  List<CommonModel> subNavList = [];
  GridNavModel _gridNavModel;
  SalesBoxModel _salesBoxModel;
  double _appBarAlpha = 0;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel homeModel = await HomeDao.fetch();
      setState(() {
        localNavList = homeModel.localNavList;
        bannerList = homeModel.bannerList;
        subNavList = homeModel.subNavList;
        _gridNavModel = homeModel.gridNav;
        _salesBoxModel = homeModel.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  bool _handleScroll(ScrollNotification notification) {
    //a notification  from its root child when scroll update
    if (notification is ScrollUpdateNotification && notification.depth == 0) {
      setState(() {
        _appBarAlpha = (notification.metrics.pixels / APPBAR_SCROLL_OFFSET)
            .clamp(0.0, 1.0);
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: Stack(children: <Widget>[
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: NotificationListener(
                  onNotification: _handleScroll,
                  child: ListView(
                    children: <Widget>[
                      _banner,
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                        child: LocalNav(localNavList: localNavList),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                        child: GridNav(_gridNavModel),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                        child: SubNav(subNavList: subNavList,),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                        child: SalesBox(salesBoxModel: _salesBoxModel,),
                      ),
                      Container(
                        height: 2000,
                      )
                    ],
                  ))),
          _appBar
        ]));
  }

  Widget get _banner {
    return Container(
      height: 160,
      child: bannerList.isNotEmpty
          ? Swiper(
              itemCount: bannerList.length,
              autoplay: true,
              pagination: SwiperPagination(),
              itemBuilder: (context, index) {
                var item = bannerList[index];
                return GestureDetector(
                  onTap: () {},
                  child: Image.network(
                    item.icon,
                    fit: BoxFit.fill,
                  ),
                );
              },
            )
          : Container(
              color: Colors.white,
            ),
    );
  }

  Widget get _appBar {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        decoration:
            BoxDecoration(color: Colors.white.withOpacity(_appBarAlpha)),
        height: 80.0,
      ),
    );
  }
}
