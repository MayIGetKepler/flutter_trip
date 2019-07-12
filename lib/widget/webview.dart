import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:flutter/services.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];

class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  WebView(
      {this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  FlutterWebviewPlugin _webviewPlugin;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool _exiting = false;
  String _currentUrl = '';

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
    _webviewPlugin = FlutterWebviewPlugin();
    _webviewPlugin.close();
    _onUrlChanged = _webviewPlugin.onUrlChanged.listen((String url) {
      _currentUrl = url;
    });

    _onStateChanged =
        _webviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad:
          if (_isToMain(state.url) && !_exiting) {
            if (widget.backForbid) {
              _webviewPlugin.stopLoading();
              _webviewPlugin.launch(widget.url);
            } else {
              Navigator.pop(context);
              _exiting = true;
            }
          }
          break;
        default:
          break;
      }
    });

    _onHttpError = _webviewPlugin.onHttpError.listen((WebViewHttpError e) {});
  }

  _isToMain(String url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    _webviewPlugin.dispose();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onUrlChanged.cancel();
    _onHttpError.cancel();
    _webviewPlugin.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_currentUrl != widget.url) {
      _webviewPlugin.goBack();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
        child: WillPopScope(
            child: Scaffold(
              body: Column(
                children: <Widget>[
                  _appBar(Color(int.parse('0xff' + statusBarColorStr)),
                      backButtonColor),
                  Expanded(
                      child: WebviewScaffold(
                    url: widget.url,
                    withZoom: true,
                    userAgent: 'null',
                    withLocalStorage: true,
                    hidden: true,
                    initialChild: Container(
                      color: Colors.white,
                      child: Center(
                        child: Text('Loading'),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            onWillPop: _onWillPop),
        value: backButtonColor == Colors.black
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light);
  }

  Widget _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(color: backButtonColor, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
