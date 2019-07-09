import 'package:flutter/services.dart';
import 'dart:async';

const ASR_CHANNEL = 'asr_plugin';

class AsrManager {
  static const MethodChannel _methodChannel = MethodChannel(ASR_CHANNEL);

  ///开始录音
  static Future<String> start(Map params) async{
   return  _methodChannel.invokeMethod("start",params);
  }

  ///停止录音
  static Future<String> stop() async{
    return  _methodChannel.invokeMethod("stop");
  }

  ///取消录音
  static Future<String> cancel() async{
    return  _methodChannel.invokeMethod("cancel");
  }


}
