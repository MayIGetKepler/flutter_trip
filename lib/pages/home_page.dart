import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/model/common_model.dart';

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

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handlerRefresh();
  }

  Future<Null> _handlerRefresh() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView(
        children: <Widget>[_banner],
      ),
    ));
  }

  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: 3,
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
      ),
    );
  }
}
