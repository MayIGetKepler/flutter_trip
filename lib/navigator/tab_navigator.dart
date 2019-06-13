import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/my_page.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  PageController _controller;
  int _index = 0;
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[HomePage(), SearchPage(), TravelPage(), MyPage()],
        onPageChanged: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _defaultColor,
              ),
              title: Text(
                '首页',
                style: TextStyle(
                    color: _index == 0 ? _activeColor : _defaultColor),
              ),
              activeIcon: Icon(
                Icons.home,
                color: _activeColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: _defaultColor),
              title: Text('搜索',
                  style: TextStyle(
                      color: _index == 1 ? _activeColor : _defaultColor)),
              activeIcon: Icon(Icons.search, color: _activeColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt, color: _defaultColor),
              title: Text('旅拍',
                  style: TextStyle(
                      color: _index == 2 ? _activeColor : _defaultColor)),
              activeIcon: Icon(Icons.camera_alt, color: _activeColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: _defaultColor),
              title: Text('我的',
                  style: TextStyle(
                      color: _index == 3 ? _activeColor : _defaultColor)),
              activeIcon: Icon(Icons.account_circle, color: _activeColor)),
        ],
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
