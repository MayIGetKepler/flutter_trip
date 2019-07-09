import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/webview.dart';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];
const URL =
    'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

class SearchPage extends StatefulWidget {
  final String hint;
  final String keyword;
  final bool hideLeft;
  final bool url;

  SearchPage(
      {this.hint = '', this.keyword = '', this.url, this.hideLeft = false});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel _searchModel;
  String keyword;

  @override
  void initState() {
    super.initState();
    if (widget.keyword != null) {
      onTextChanged(widget.keyword);
    }
  }

  onTextChanged(String text) async {
    keyword = text;
    if (text.isEmpty) {
      setState(() {
        _searchModel = null;
      });
    } else {
      SearchDao.fetch(URL + text, keyword).then((model) {
        if (model.keyword == keyword) {
          setState(() {
            _searchModel = model;
          });
        }
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar,
          Expanded(
              child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      itemCount: _searchModel?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return _item(_searchModel.data[index]);
                      })))
        ],
      ),
    );
  }

  Widget _item(SearchItem model) {
    return _wrapTap(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(2),
                child: Image.asset(
                  _getImageByType(model.type),
                  height: 26,
                  width: 26,
                ),
              ),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _title(model),
                  _subTitle(model),
                ],
              ))
            ],
          ),
        ), () {
      NavigatorUtil.push(
          context,
          WebView(
            url: model.url,
            title: '详情',
            backForbid: true,
          ));
    });
  }

  Widget _title(SearchItem model) {
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(model.word, _searchModel.keyword));
    spans.add(TextSpan(
        text: ' ${model.districtname ?? ''} ${model.zonename ?? ''}',
        style: TextStyle(color: Colors.grey, fontSize: 16)));
    return Text.rich(TextSpan(children: spans));
  }

  Widget _subTitle(SearchItem model) {
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
          text: model.price ?? '',
          style: TextStyle(fontSize: 16, color: Colors.orange),
        ),
        TextSpan(
          text: ' ' + (model.star ?? ''),
          style: TextStyle(fontSize: 12, color: Colors.grey),
        )
      ]),
    );
  }

  List<TextSpan> _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.isEmpty) return spans;
    final arr = word.split(keyword);
    const TextStyle normalStyle =
        TextStyle(fontSize: 16, color: Colors.black87);
    const TextStyle keywordStyle =
        TextStyle(fontSize: 16, color: Colors.orange);
    for (int i = 0; i < arr.length; i++) {
      if ((i + 1) % 2 == 0) {
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      final span = arr[i];
      if (span != null && span.isNotEmpty) {
        spans.add(TextSpan(text: span, style: normalStyle));
      }
    }
    return spans;
  }

  String _getImageByType(String type) {
    if (type == null || type.isEmpty) return 'images/type_travelgroup.png';
    String asset;
    for (final val in TYPES) {
      if (val.contains(type)) {
        asset = 'images/type_$val.png';
        break;
      }
    }
    return asset ?? 'images/type_travelgroup.png';
  }

  Widget get _appBar {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
      child: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 5,
            bottom: 10,
            left: 3,
            right: 5),
        color: Colors.white,
        child: FractionallySizedBox(
          widthFactor: 1,
          child: SearchBar(
            hideLeft: widget.hideLeft,
            hint: widget.hint,
            onChanged: onTextChanged,
            searchBarType: SearchBarType.normal,
            defaultText: widget.keyword,
            speakClick: _jumpToSpeak,
            leftButtonClick: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Widget _wrapTap(Widget child, VoidCallback onTap) {
    return GestureDetector(
      child: child,
      onTap: onTap,
    );
  }
  _jumpToSpeak() {
    NavigatorUtil.push(context, SpeakPage());
  }
}
