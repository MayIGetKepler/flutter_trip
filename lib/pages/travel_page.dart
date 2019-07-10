import 'package:flutter/material.dart';
import 'package:flutter_trip/model/travel_model.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:flutter_trip/dao/travel_tab_dao.dart';
import 'package:flutter_trip/dao/travel_dao.dart';
import 'package:flutter_trip/pages/travel_tab_page.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage>
    with SingleTickerProviderStateMixin {
  List<TravelTab> _tabs = [];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _handleRefresh();
  }

  _handleRefresh() {
    TravelTabDao.fetch().then((TravelTabModel model) {
      _tabs = model.tabs;
      _tabController = TabController(length: _tabs.length, vsync: this);
      setState(() {});
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            tabs: _tabs.map<Tab>((TravelTab tab) {
              return Tab(
                text: tab.labelName,
              );
            }).toList(),
            isScrollable: true,
            labelColor: Colors.black,
            labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3)),
          ),
          Flexible(child: TabBarView(
              controller: _tabController,
              children: _tabs.map((e){
                return TravelTabPage(code:e.groupChannelCode);
              }).toList()))
        ],
      )),
    );
  }
}
