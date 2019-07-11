import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  SearchBar(
      {this.enabled = true,
      this.hideLeft = false,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.defaultText != null) {
      _controller.text = widget.defaultText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _normalSearchBar()
        : _homeSearchBar();
  }

  Widget _homeSearchBar() {
    return Row(
      children: <Widget>[
        _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
              child: Row(
                children: <Widget>[
                  Text(
                    '上海',
                    style: TextStyle(color: _homeTypeFontColor(), fontSize: 14),
                  ),
                  Icon(
                    Icons.expand_more,
                    color: _homeTypeFontColor(),
                    size: 22,
                  )
                ],
              ),
            ),
            widget.leftButtonClick),
        Expanded(child: Padding(padding: EdgeInsets.only(right: 30),child: _inputBox(),)),
//        _wrapTap(
//            Container(
//              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//              child: Icon(
//                Icons.search,
//                color: _homeTypeFontColor(),
//                size: 26,
//              ),
//            ),
//            widget.rightButtonClick),
//        _wrapTap(
//            Container(
//              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//              child: Icon(
//                Icons.comment,
//                color: _homeTypeFontColor(),
//                size: 26,
//              ),
//            ),
//            widget.rightButtonClick)

      ],
    );
  }

  Widget _normalSearchBar() {
    return Row(
      children: <Widget>[
        _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget.hideLeft
                  ? null
                  : (Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 26,
                    )),
            ),
            widget.leftButtonClick),
        Expanded(child: _inputBox()),
        _wrapTap(
            Container(
              padding: EdgeInsets.only(left: 3,right: 3),
              child: Text('搜索',
                  style: TextStyle(color: Colors.blue, fontSize: 17)),
            ),
            widget.rightButtonClick)
      ],
    );
  }

  Widget _inputBox() {
    Color boxColor = widget.searchBarType == SearchBarType.home
        ? Colors.white
        : Color(0xffEDEDED);
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(
              widget.searchBarType == SearchBarType.normal ? 5 : 15)),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal
                ? Color(0xffA9A9A9)
                : Colors.blue,
          ),
          Expanded(
              child: widget.searchBarType == SearchBarType.normal
                  ? TextField(
                      controller: _controller,
                      onChanged: _onChanged,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        border: InputBorder.none,
                        hintText: widget.hint ?? '',
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                    )
                  : _wrapTap(
                      Container(
                        padding: EdgeInsets.only(left: 3),
                        child: Text(
                          widget.defaultText ?? '',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      widget.inputBoxClick)),
          _showClear
              ? _wrapTap(Icon(Icons.clear), () {
                  _controller.clear();
                  _onChanged('');
                })
              : _wrapTap(
                  Icon(Icons.mic,
                      size: 22,
                      color: widget.searchBarType == SearchBarType.normal
                          ? Colors.blue
                          : Colors.grey),
                  widget.speakClick)
        ],
      ),
    );
  }

  _onChanged(String text) {
    setState(() {
      _showClear = text.isNotEmpty;
    });

    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  Widget _wrapTap(Widget widget, VoidCallback onTap) {
    return GestureDetector(
      child: widget,
      onTap: onTap,
    );
  }

  Color _homeTypeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
}
