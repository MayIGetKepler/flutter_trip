import 'package:flutter/services.dart';

const _PLUGIN_NAME = "to_background_plugin";
class ToBackgroundManager{
  static const MethodChannel _methodChannel = MethodChannel(_PLUGIN_NAME);

  static Future<void> toBackground() async{
    return _methodChannel.invokeMethod("toBackground");
  }
}