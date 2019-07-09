import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/plugin/asr_manager.dart';
import 'package:flutter_trip/utils/navigator_util.dart';

const String TIP_PRESS = '长按说话';
const String TIP_RECOGNIZING = '- 识别中 -';

class SpeakPage extends StatefulWidget {
  @override
  _SpeakPageState createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  String _speakTip = TIP_PRESS;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addStatusListener((status) {
            debugPrint(status.toString());
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[_topItem(), _bottomItem(context)],
      )),
    );
  }

  Widget _topItem() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            '你可以这样说',
            style: TextStyle(color: Colors.grey, fontSize: 24),
          ),
        ),
        Text(
          '故宫门票\n北京一日游\n迪士尼乐园',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 18),
        )
      ],
    );
  }

  Widget _bottomItem(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          FractionallySizedBox(
            widthFactor: 1,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    _speakTip,
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
                _micIcon()
              ],
            ),
          ),
          Positioned(
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey,
              ),
              iconSize: 30,
              onPressed: () => Navigator.pop(context),
            ),
            right: 0,
            bottom: 5,
          )
        ],
      ),
    );
  }

  _startRecognize() {
    setState(() {
      _speakTip = TIP_RECOGNIZING;
    });
    _animationController.forward();
    AsrManager.start().then((text) {
      Navigator.pop(context);
      NavigatorUtil.push(
          context,
          SearchPage(
            keyword: text,
          ));
    }).catchError((e) {
      print(e.toString());
    });
  }

  _stopRecognize() {
    setState(() {
      _speakTip = TIP_PRESS;
    });
    _animationController
      ..reset()
      ..stop();
    AsrManager.stop();
  }

  _cancelRecognize() {
    setState(() {
      _speakTip = TIP_PRESS;
    });
    _animationController
      ..reset()
      ..stop();
    AsrManager.cancel();
  }

  Widget _micIcon() {
    return GestureDetector(
      onTapDown: (d) => _startRecognize(),
      onTapUp: (d) => _stopRecognize(),
      onTapCancel: _cancelRecognize,
      child: Container(
        width: MIC_SIZE,
        height: MIC_SIZE,
        child: Center(child: _AnimatedIcon(_animationController),),
      ),
    );
  }
}

const MIC_SIZE = 80.0;

class _AnimatedIcon extends AnimatedWidget {
  _AnimatedIcon(Animation animation) : super(listenable: animation);
  final Tween<double> _opacity = Tween(begin: 1, end: 0.5);
  final Tween<double> _size = Tween(begin: MIC_SIZE, end: MIC_SIZE - 20);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity.evaluate(listenable),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(MIC_SIZE / 2)),
        width: _size.evaluate(listenable),
        height: _size.evaluate(listenable),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
