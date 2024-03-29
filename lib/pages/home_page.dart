import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/webview.dart';

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '酒店 美食 网红打卡地';

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

  ///首次加载数据Flag
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
      if (!mounted) return null;
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
//        print(_appBarAlpha);
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
          loading: _loading,
          child: Stack(children: <Widget>[
            MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: RefreshIndicator(
                  displacement: 60,
                  onRefresh: _handleRefresh,
                  child: NotificationListener(
                      onNotification: _handleScroll, child: _listView),
                )),
            _appBar
          ])),
    );
  }

  Widget get _listView {
    return ListView(
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
          child: SubNav(
            subNavList: subNavList,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SalesBox(
            salesBoxModel: _salesBoxModel,
          ),
        ),
      ],
    );
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
                return Image.network(
                  item.icon,
                  fit: BoxFit.fill,
                );
              },
              onTap: (index) => NavigatorUtil.push(
                  context,
                  WebView(
                    url: bannerList[index].url,
                    title: bannerList[index].title,
                    hideAppBar: bannerList[index].hideAppBar,
                    statusBarColor: bannerList[index].statusBarColor,
                  )))
          : Container(
              color: Colors.white,
            ),
    );
  }

  Widget get _appBar {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0x55ffffff),
            Color(0x44ffffff),
            Color(0x33ffffff),
            Color(0x33ffffff),
            Color(0x22ffffff),
            Colors.transparent
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
      child: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 5, bottom: 10),
        color: Color.fromARGB((_appBarAlpha * 255).toInt(), 255, 255, 255),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: SearchBar(
            searchBarType: _appBarAlpha > 0.2
                ? SearchBarType.homeLight
                : SearchBarType.home,
            inputBoxClick: _jumpToSearch,
            speakClick: _jumpToSpeak,
            defaultText: SEARCH_BAR_DEFAULT_TEXT,
          ),
        ),
      ),
    );
  }

  _jumpToSearch() {
    NavigatorUtil.push(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
        ));
  }

  _jumpToSpeak() {
    NavigatorUtil.push(context, SpeakPage());
  }
}
